import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/school_model.dart';
import '../utils/marker_icon_loader.dart';

Future<BitmapDescriptor> getClusterIcon(Cluster<SchoolModel> cluster) async {
  int countZero =
      cluster.items.where((element) => element.airQualityPm25 == 0).length;
  int countOne =
      cluster.items.where((element) => element.airQualityPm25 == 1).length;
  return await getMarkerBitmap(150, 150, countZero, countOne,
      text: cluster.count.toString());
}

Future<BitmapDescriptor> getSingleMarkerIcon(SchoolModel item) async {
  String imagePath = item.airQualityPm25 == 0
      ? "assets/images/dot_red_48.png"
      : "assets/images/dot_green_48.png";
  return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), imagePath);
}




 Future<BitmapDescriptor> getIconBasedOnPm25(SchoolModel item, MarkerIconLoader iconLoader) async {
  const highPm25Level = 55;
  const mediumPm25Level = 35;
  const lowPm25Level = 13;

  if (item.airQualityPm25 > highPm25Level) {
    return iconLoader.markerIcon4; 
  } else if (item.airQualityPm25 > mediumPm25Level) {
    return iconLoader.markerIcon3; 
  } else if (item.airQualityPm25 > lowPm25Level) {
    return iconLoader.markerIcon2;
  } else {
    return iconLoader.markerIcon; 
  }
  }

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
