import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/bloc/chart_panel_cubit.dart';
import '../services/school_model.dart';

class ClusterMarkerManager {

 final ChartPanelCubit chartPanelCubit;
 ClusterMarkerManager(this.chartPanelCubit);

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
                    const ImageConfiguration(
                        size: Size(48, 48)), // Rozmiar ikony
                    cluster.items.single.pm25 == 0
                        ? "assets/images/dot_red_48.png"
                        : "assets/images/dot_green_48.png"),
            infoWindow: cluster.isMultiple
                ? const InfoWindow()
                : InfoWindow(title: cluster.items.single.name),
            onTap: () {
               chartPanelCubit.togglePanel(true);
            });
      };


}
