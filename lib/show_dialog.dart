import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'marker/marker_helper.dart';
import 'marker/marker_icon_loader.dart';

class YourMapWidget extends StatelessWidget {
  final MarkerHelper _markerHelper;

  YourMapWidget(MarkerIconLoader iconLoader, {super.key}) 
    : _markerHelper = MarkerHelper(iconLoader);

  @override
  Widget build(BuildContext context) {
    // Fetch station data...
    Map<String, dynamic> station = {}; // Replace with your station data

    Marker marker = _markerHelper.buildMarker(station, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(station['school']['name']),
            content: Text('PM 2.5: ${(station['data']['pm25_avg'] as num).toInt()}'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });

    // Add marker to map...

    // Return your map widget...
    return Container();
  }
}