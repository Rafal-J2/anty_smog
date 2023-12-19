import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'block/location_gps.dart';
import 'block/marker_cubit.dart';
import 'shared preferences/map_service.dart';
import 'shared preferences/preferences_service.dart';
import 'package:logger/logger.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

var logger = Logger();

class MyAppState extends State<MyApp> {
  late GoogleMapController _controller;
  MapType _currentMapType = MapType.normal;

  double _todayValue = 250;
 bool _isMarkerVisible = false;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  //    void _toggleVisibility() {
  //   setState(() {
  //    _isMarkerVisible = !_isMarkerVisible;
  //   });
  // }


  Future<void> _printSavedCameraPosition() async {
    final prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    double? zoom = prefs.getDouble('zoom');
    logger.i('Saved latitude: $latitude');
    logger.i('Saved longitude: $longitude');
    logger.i('Saved zoom: $zoom');
  }

  void _initCameraPosition() async {
    CameraPosition position = await MapService().initCameraPosition();
    _controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

 


  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: BlocBuilder<MarkerCubit, Map<String, Marker>>(
        builder: (context, state) {
          return Stack(
            children: [
              Stack(
                children: [
                  GoogleMap(
                    onTap: (LatLng position) {
                      setState(() {
                        _isMarkerVisible = true;                   
                      });
                    },
                    mapType: _currentMapType,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) async {
                      _controller = controller;
                      _printSavedCameraPosition();
                      _initCameraPosition();
                    },
                    onCameraMove: (CameraPosition position) {
                      PreferencesService().saveCameraPosition(position);
                    },
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(52.237049, 21.017532),
                      zoom: 6,
                    ),
                    markers: state.values.toSet(),
                  ),
                  if (_isMarkerVisible)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Container(
                        width: 500,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              buildSleepQualityGauge(), // Call the chart widget here
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 240,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      child: _currentMapType == MapType.normal
                          ? const Icon(Icons.map)
                          : const Icon(Icons.satellite),
                    ),
                  ),
                ],
              ),
              // other widgets...
            ],
          );
        },
      ),
      floatingActionButton: BlocConsumer<LocationGps, Position?>(
        listener: (context, position) {},
        builder: (context, position) {
          return FloatingActionButton(
            onPressed: () {
              if (position != null) {
                final locationCubit = BlocProvider.of<LocationGps>(context);
                locationCubit.getCurrentLocation();
                _controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 12,
                    ),
                  ),
                );
              }
            },
            child: const Icon(Icons.my_location),
          );
        },
      ),
    ));
  }

  Widget buildSleepQualityGauge() {
    final Brightness brightness = Theme.of(context).brightness;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'TODAY',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text(
                  _todayValue.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 26,
                      color: _todayValue < 200
                          ? Colors.green
                          : _todayValue < 300
                              ? Colors.amber
                              : _todayValue < 400
                                  ? const Color(0xffFB7D55)
                                  : Colors.red,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Expanded(
              child: SfLinearGauge(
                  minimum: 100.0,
                  maximum: 500.0,
                  interval: 50.0,
                  animateAxis: true,
                  animateRange: true,
                  showLabels: false,
                  showTicks: false,
                  minorTicksPerInterval: 0,
                  axisTrackStyle: LinearAxisTrackStyle(
                    thickness: 15,
                    color: brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.grey[350],
                  ),
                  markerPointers: <LinearMarkerPointer>[
                    LinearShapePointer(
                        value: _todayValue,
                        onChanged: (dynamic value) {
                          setState(() {
                            _todayValue = value as double;
                          });
                        },
                        height: 20,
                        width: 20,
                        color: _todayValue < 200
                            ? Colors.green
                            : _todayValue < 300
                                ? Colors.amber
                                : _todayValue < 400
                                    ? const Color(0xffFB7D55)
                                    : Colors.red,
                        position: LinearElementPosition.cross,
                        shapeType: LinearShapePointerType.circle),
                    const LinearWidgetPointer(
                      value: 150,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Doskonała',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 250,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Dobra',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 350,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Umiarkowana',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 450,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Zła',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                  ranges: const <LinearGaugeRange>[
                    LinearGaugeRange(
                      startValue: 100.0,
                      endValue: 200,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      position: LinearElementPosition.cross,
                      color: Colors.green,
                    ),
                    LinearGaugeRange(
                      startValue: 200.0,
                      endValue: 300,
                      startWidth: 8,
                      position: LinearElementPosition.cross,
                      midWidth: 8,
                      endWidth: 8,
                      color: Colors.amber,
                    ),
                    LinearGaugeRange(
                      startValue: 300.0,
                      endValue: 400,
                      position: LinearElementPosition.cross,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      color: Color(0xffFB7D55),
                    ),
                    LinearGaugeRange(
                      startValue: 400.0,
                      endValue: 500,
                      position: LinearElementPosition.cross,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      color: Colors.red,
                    ),
                  ]),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'TODAY',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text(
                  _todayValue.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 26,
                      color: _todayValue < 200
                          ? Colors.green
                          : _todayValue < 300
                              ? Colors.amber
                              : _todayValue < 400
                                  ? const Color(0xffFB7D55)
                                  : Colors.red,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              child: SfLinearGauge(
                  minimum: 100.0,
                  maximum: 500.0,
                  interval: 50.0,
                  animateAxis: true,
                  animateRange: true,
                  showLabels: false,
                  showTicks: false,
                  minorTicksPerInterval: 0,
                  axisTrackStyle: LinearAxisTrackStyle(
                    thickness: 15,
                    color: brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.grey[350],
                  ),
                  markerPointers: <LinearMarkerPointer>[
                    LinearShapePointer(
                        value: _todayValue,
                        onChanged: (dynamic value) {
                          setState(() {
                            _todayValue = value as double;
                          });
                        },
                        height: 20,
                        width: 20,
                        color: _todayValue < 200
                            ? Colors.green
                            : _todayValue < 300
                                ? Colors.amber
                                : _todayValue < 400
                                    ? const Color(0xffFB7D55)
                                    : Colors.red,
                        position: LinearElementPosition.cross,
                        shapeType: LinearShapePointerType.circle),
                    const LinearWidgetPointer(
                      value: 150,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Doskonała',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 250,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Dobra',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 350,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Umiarkowana',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 450,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Zła',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                  ranges: const <LinearGaugeRange>[
                    LinearGaugeRange(
                      startValue: 100.0,
                      endValue: 200,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      position: LinearElementPosition.cross,
                      color: Colors.green,
                    ),
                    LinearGaugeRange(
                      startValue: 200.0,
                      endValue: 300,
                      startWidth: 8,
                      position: LinearElementPosition.cross,
                      midWidth: 8,
                      endWidth: 8,
                      color: Colors.amber,
                    ),
                    LinearGaugeRange(
                      startValue: 300.0,
                      endValue: 400,
                      position: LinearElementPosition.cross,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      color: Color(0xffFB7D55),
                    ),
                    LinearGaugeRange(
                      startValue: 400.0,
                      endValue: 500,
                      position: LinearElementPosition.cross,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      color: Colors.red,
                    ),
                  ]),
            ),
          ],
        ),
      ],
    );
  }
}
