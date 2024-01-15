import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../screens/maps.dart';
import 'get_api.dart';
import 'school_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<Marker> markers = {};
  late Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  late ClusterManager clusterManager;

  //final Set<Marker> _markers = {};

  List<SchoolModel> placeList = [];

  CameraPosition initialCameraPosition = const CameraPosition(
     target: LatLng(52.237049, 21.017532),
    zoom: 6,
  );

  @override
  void initState() {
    clusterManager = _initClusterManager();
    super.initState();
    loadAndSetSchools();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<SchoolModel>(placeList, _updateMarkers,
        markerBuilder: markerBuilder);
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

    Future<void> loadAndSetSchools() async {
  try {
    List<dynamic> apiData = await fetchApiData();
    logger.t('Data received from API: $apiData');
    List<SchoolModel> schools = apiData.map((json) => SchoolModel.fromJson(json)).toList();
    logger.t('List of schools creatd: $schools');
    clusterManager.setItems(schools);
    logger.t('ClusterManager update');
  } catch (e) {
    logger.t('Erro occurred: $e');
  }
}

  Future<Marker> Function(Cluster<SchoolModel>) get markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.isMultiple
              ? cluster.getId()
              : cluster.items.single.name.toString()),
          position: cluster.location,
          icon: cluster.isMultiple
              ? await getMarkerBitmap(
                  150,
                  150,
                  cluster.items.where((element) => element.pm25 == 0).length,
                  cluster.items.where((element) => element.pm25 == 1).length,
                  text: cluster.count.toString())
              : await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(48, 48)), // Rozmiar ikony
                  cluster.items.single.pm25 == 0
                      ? "assets/images/dot_red_48.png"
                      : "assets/images/dot_green_48.png"),
          infoWindow: cluster.isMultiple
              ? const InfoWindow()
              : InfoWindow(title: cluster.items.single.name),
        );
      };

  Future<BitmapDescriptor> getMarkerBitmap(
      int size, double size2, int typeZeroLength, int typeOneLength,
      {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = const Color(0xFF4051B5);
    final Paint paint2 = Paint()..color = Colors.white;
    final Paint paint3 = Paint()..color = Colors.red;

    double degreesToRads(num deg) {
      return (deg * 3.14) / 180.0;
    }

    int total = typeZeroLength + typeOneLength;
    var totalRatio = 2.09439666667 * 3;
    double percentageOfLength = (typeZeroLength / total);
    var resultRatio = totalRatio * percentageOfLength;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.8, paint3);
    canvas.drawArc(const Offset(0, 0) & Size(size2, size2), degreesToRads(90.0),
        resultRatio, true, paint3);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.2, paint2);
    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.black,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context,
    String assetName,
    double size,
  ) async {
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(size, size));
    ui.Image image = await picture.toImage(size.toInt(), size.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        onMapCreated: (GoogleMapController controller) async {
          googleMapController.complete(controller);
          clusterManager.setMapId(controller.mapId);
        },
        onCameraMove: (position) {
          clusterManager.onCameraMove(position);
        },
        onCameraIdle: clusterManager.updateMap,
      ),
    );
  }
}
