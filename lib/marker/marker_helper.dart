//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'marker_icon_loader.dart';

class MarkerHelperUdate extends StatefulWidget {
 
  const MarkerHelperUdate({super.key});

  @override
  State<MarkerHelperUdate> createState() => _MarkerHelperUdateState();
}
class _MarkerHelperUdateState extends State<MarkerHelperUdate> {
  double _todayValue = 250;

    @override
  Widget build(BuildContext context) {
    return buildSleepQualityGauge();
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

class MarkerHelper {
  final MarkerIconLoader _iconLoader;
  MarkerHelper(this._iconLoader);

// This method builds a marker for a given station.
// It takes a Map representing a station as a parameter.
// The station Map should contain 'school' and 'data' keys.
// The 'school' key should map to another Map containing 'name', 'latitude', and 'longitude' keys.
// The 'data' key should map to another Map containing 'pm25_avg' key.
// It returns a Marker object.
  Marker buildMarker(Map<String, dynamic> station, VoidCallback onTap) {
    num pm25Avg = station['data']['pm25_avg'] as num;
    return Marker(
      markerId: MarkerId(station['school']['name'].toString()),
      position: LatLng(double.parse(station['school']['latitude']),
          double.parse(station['school']['longitude'])),
      infoWindow: InfoWindow(
        title: station['school']['name'],
        snippet: 'PM 2.5: ${(station['data']['pm25_avg'] as num).toInt()}',
      ),
      icon: pm25Avg > 55
          ? _iconLoader.markerIcon4
          : pm25Avg > 35
              ? _iconLoader.markerIcon3
              : pm25Avg > 13
                  ? _iconLoader.markerIcon2
                  : _iconLoader.markerIcon,
    );
  }
}
