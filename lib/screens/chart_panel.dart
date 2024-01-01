import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../block/cubit/pm_data_cubit.dart';

class MarkerHelperUdate extends StatefulWidget {
  const MarkerHelperUdate({super.key, });
  @override
  State<MarkerHelperUdate> createState() => _MarkerHelperUdateState();
}

class _MarkerHelperUdateState extends State<MarkerHelperUdate> {
 double _todayValue = 50;
  

  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PMDataCubit, PMDataState>( 
      builder: (context, state) {
        _todayValue = state.pm25Value;
        return buildQualityGauge();
      },
    );
  }


  Widget buildQualityGauge() {
    final Brightness brightness = Theme.of(context).brightness;
    return Column(
      children: [
      Row(
          children: [
            Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'TODAY 2',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text(
                  _todayValue.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 26,
                      color: _todayValue < 13
                          ? Colors.green
                          : _todayValue < 35
                              ? Colors.amber
                              : _todayValue < 55
                                  ? const Color(0xffFB7D55)
                                  : Colors.red,
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
                        value: _todayValue,
                        onChanged: (dynamic value) {
                          setState(() {
                            _todayValue = value as double;
                          });
                        },
                        height: 20,
                        width: 20,
                        color: _todayValue < 13
                            ? Colors.green
                            : _todayValue < 35
                                ? Colors.amber
                                : _todayValue < 55
                                    ? const Color(0xffFB7D55)
                                    : Colors.red,
                        position: LinearElementPosition.cross,
                        shapeType: LinearShapePointerType.circle),
                    const LinearWidgetPointer(
                      value: 13,
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
                      value: 35,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Dobra',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 55,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Umiarkowana',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 75,
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
        Row(
          children: [
            Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'TODAY 2',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
                Text(
                  _todayValue.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 26,
                      color: _todayValue < 13
                          ? Colors.green
                          : _todayValue < 35
                              ? Colors.amber
                              : _todayValue < 55
                                  ? const Color(0xffFB7D55)
                                  : Colors.red,
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
                        value: _todayValue,
                        onChanged: (dynamic value) {
                          setState(() {
                            _todayValue = value as double;
                          });
                        },
                        height: 20,
                        width: 20,
                        color: _todayValue < 13
                            ? Colors.green
                            : _todayValue < 35
                                ? Colors.amber
                                : _todayValue < 55
                                    ? const Color(0xffFB7D55)
                                    : Colors.red,
                        position: LinearElementPosition.cross,
                        shapeType: LinearShapePointerType.circle),
                    const LinearWidgetPointer(
                      value: 13,
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
                      value: 35,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Dobra',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 55,
                      enableAnimation: true,
                      position: LinearElementPosition.outside,
                      offset: 4,
                      child: Text(
                        'Umiarkowana',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const LinearWidgetPointer(
                      value: 75,
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
