import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../bloc/pm_data_cubit.dart';

class MarkerHelperUdate extends StatefulWidget {
  const MarkerHelperUdate({
    super.key,
  });
  @override
  State<MarkerHelperUdate> createState() => _MarkerHelperUdateState();
}

class _MarkerHelperUdateState extends State<MarkerHelperUdate> {
  // Initial values for PM2.5 and PM10 measurements.
  double _pm25Value = 50;
  double _pm10Value = 50;

  @override
  Widget build(BuildContext context) {
    // Listen for changes in PMDataCubit state and rebuild the gauge.
    return BlocBuilder<PMDataCubit, PMDataState>(
      builder: (context, state) {
        _pm25Value = state.pm25Value;
        _pm10Value = state.pm10Value;
        return buildQualityGauge();
      },
    );
  }

  // Helper function to create text style.
  TextStyle textStyle(double size, FontWeight weight) =>
      TextStyle(fontSize: size, fontWeight: weight);

// Determines the color based on the PM value.
  Color valueColor(double value) {
    if (value < 13) {
      return Colors.green;
    } else if (value < 35) {
      return Colors.amber;
    } else if (value < 55) {
      return const Color(0xffFB7D55);
    } else {
      return Colors.red;
    }
  }

// Builds a pointer widget for the gauge.
  LinearWidgetPointer buildPointer(double value, String text) =>
      LinearWidgetPointer(
          value: value,
          position: LinearElementPosition.outside,
          child: MediaQuery.of(context).size.width > 360
              ? Text(text, style: textStyle(12, FontWeight.normal))
              : const SizedBox.shrink());

// Constructs the quality gauge widget.
  Widget buildQualityGauge() {
    final Brightness brightness = Theme.of(context).brightness;
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: <Widget>[
                const Text('PM 2,5',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                Text(_pm25Value.toStringAsFixed(0),
                    style: TextStyle(
                        fontSize: 26,
                        color: valueColor(_pm25Value),
                        fontWeight: FontWeight.bold))
              ],
            ),
            Expanded(
              child: SfLinearGauge(
                  minimum: 1.0,
                  maximum: 75.0,
                  interval: 1.0,
                  animateAxis: true,
                  animateRange: true,
                  showLabels: false,
                  showTicks: false,
                  minorTicksPerInterval: 0,
                  axisTrackStyle: LinearAxisTrackStyle(
                    thickness: 15,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.grey[350],
                  ),
                  markerPointers: [
                    LinearShapePointer(
                        value: _pm25Value,
                        onChanged: (dynamic value) {
                          setState(() {
                            _pm25Value = value as double;
                          });
                        },
                        height: 20,
                        width: 20,
                        color: valueColor(_pm25Value),
                        position: LinearElementPosition.cross,
                        shapeType: LinearShapePointerType.circle),
                    buildPointer(13, 'Doskonała'),
                    buildPointer(35, 'Dobra'),
                    buildPointer(55, 'Umiarkowana'),
                    buildPointer(75, 'Zła'),
                  ],
                  ranges: const [
                    LinearGaugeRange(
                        startValue: 1.0,
                        endValue: 13,
                        startWidth: 8,
                        midWidth: 8,
                        endWidth: 8,
                        position: LinearElementPosition.cross,
                        color: Colors.green),
                    LinearGaugeRange(
                        startValue: 13.0,
                        endValue: 35,
                        startWidth: 8,
                        position: LinearElementPosition.cross,
                        midWidth: 8,
                        endWidth: 8,
                        color: Colors.amber),
                    LinearGaugeRange(
                        startValue: 35.0,
                        endValue: 55,
                        position: LinearElementPosition.cross,
                        startWidth: 8,
                        midWidth: 8,
                        endWidth: 8,
                        color: Color(0xffFB7D55)),
                    LinearGaugeRange(
                        startValue: 55.0,
                        endValue: 75,
                        position: LinearElementPosition.cross,
                        startWidth: 8,
                        midWidth: 8,
                        endWidth: 8,
                        color: Colors.red),
                  ]),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              children: <Widget>[
                const Text(
                  'PM 10',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text(
                  _pm10Value.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 26,
                      color: valueColor(_pm10Value),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            Expanded(
              child: SfLinearGauge(
                  minimum: 1.0,
                  maximum: 75.0,
                  interval: 1.0,
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
                        value: _pm10Value,
                        onChanged: (dynamic value) {
                          setState(() {
                            _pm10Value = value as double;
                          });
                        },
                        height: 20,
                        width: 20,
                        color: valueColor(_pm25Value),
                        position: LinearElementPosition.cross,
                        shapeType: LinearShapePointerType.circle),
                    buildPointer(13, 'Doskonała'),
                    buildPointer(35, 'Dobra'),
                    buildPointer(55, 'Umiarkowana'),
                    buildPointer(75, 'Zła'),
                  ],
                  ranges: const <LinearGaugeRange>[
                    LinearGaugeRange(
                      startValue: 1.0,
                      endValue: 13,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      position: LinearElementPosition.cross,
                      color: Colors.green,
                    ),
                    LinearGaugeRange(
                      startValue: 13.0,
                      endValue: 35,
                      startWidth: 8,
                      position: LinearElementPosition.cross,
                      midWidth: 8,
                      endWidth: 8,
                      color: Colors.amber,
                    ),
                    LinearGaugeRange(
                      startValue: 35.0,
                      endValue: 55,
                      position: LinearElementPosition.cross,
                      startWidth: 8,
                      midWidth: 8,
                      endWidth: 8,
                      color: Color(0xffFB7D55),
                    ),
                    LinearGaugeRange(
                      startValue: 55.0,
                      endValue: 75,
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
