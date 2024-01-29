import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/school_model.dart';
import '../utils/marker_icon_loader.dart';


 // Define the thresholds for each air quality level
const highPm25Level = 55;
const mediumPm25Level = 35;
const lowPm25Level = 13;

// Generates a cluster icon based on air quality data
Future<BitmapDescriptor> getClusterIcon(Cluster<SchoolModel> cluster) async {
  // Count the number of items in each air quality category
  int countZero = cluster.items
      .where((element) => element.airQualityPm25 <= lowPm25Level)
      .length; // Green category
  int countOne = cluster.items
      .where((element) =>
          element.airQualityPm25 > 13 &&
          element.airQualityPm25 <= mediumPm25Level)
      .length; // Yellow category
  int countTwo = cluster.items
      .where((element) =>
          element.airQualityPm25 > 35 &&
          element.airQualityPm25 <= highPm25Level)
      .length; // Orangecategory
  int countThree = cluster.items
      .where((element) => element.airQualityPm25 > highPm25Level)
      .length; // Red category

  return await getMarkerBitmap(
      150, 150, countZero, countOne, countTwo, countThree,
      text: cluster.count.toString());
}

// Select an icon based on the airQualityPm25 value
Future<BitmapDescriptor> getIconBasedOnPm25(
    SchoolModel item, MarkerIconLoader iconLoader) async {
   // Return the appropriate icon based on the air quality value
  if (item.airQualityPm25 > highPm25Level) {
    return iconLoader.getMarkerIcon('assets/images/dot_red_48.png');  // Red for high levels
  } else if (item.airQualityPm25 > mediumPm25Level) {
    return iconLoader.getMarkerIcon('assets/images/dot_orange_48.png'); // Orange for values > 35 and <= 55
  } else if (item.airQualityPm25 > lowPm25Level) {
    return iconLoader.getMarkerIcon('assets/images/dot_yellow_48.png'); // Orange for values > 35 and <= 55
  } else {
    return iconLoader.getMarkerIcon('assets/images/dot_green_48.png'); // Default case (green)
  }
}

// Creates a bitmap representation of the cluster icon
Future<BitmapDescriptor> getMarkerBitmap(int width, int height, int countZero,
    int countOne, int countTwo, int countThree,
    {String? text}) async {
  // Setup for drawing
  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  // Define paints for each air quality category
  final Paint paintGreen = Paint()..color = Colors.green;
  final Paint paintYellow = Paint()..color = Colors.yellow;
  final Paint paintOrange = Paint()..color = Colors.orange;
  final Paint paintRed = Paint()..color = Colors.red;
  final Paint paintWhite = Paint()..color = Colors.white;
  
// Calculate the total number of items
  int total = countZero + countOne + countTwo + countThree;
  total = max(total, 1);
 
  // Calculate the start angle
  double startAngle = -pi / 2;  // Start from the top
  double sweepAngleGreen = 2 * pi * (countZero / total);
  double sweepAngleYellow = 2 * pi * (countOne / total);
  double sweepAngleOrange = 2 * pi * (countTwo / total);
  double sweepAngleRed = 2 * pi * (countThree / total);

// Draw each sector on the canvas
  canvas.drawArc(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    startAngle,
    sweepAngleGreen,
    true,
    paintGreen,
  );
  startAngle += sweepAngleGreen;

  canvas.drawArc(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    startAngle,
    sweepAngleYellow,
    true,
    paintYellow,
  );
  startAngle += sweepAngleYellow;

  canvas.drawArc(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      startAngle, sweepAngleOrange, true, paintOrange);
  startAngle += sweepAngleOrange;

  canvas.drawArc(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      startAngle, sweepAngleRed, true, paintRed);
  startAngle += sweepAngleRed;

  double innerCircleRadius = height / 3.2;
  canvas.drawCircle(
    Offset(width / 2, height / 2),
    innerCircleRadius,
    paintWhite,
  );
  // Add text to the center, if provided
  if (text != null) {
    TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: height / 3,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset((width - painter.width) / 2, (height - painter.height) / 2),
    );
  }

  // Finish drawing and convert to an image
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}
