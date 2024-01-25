import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/bloc/pm_data_cubit.dart';
import 'package:google_maps_rest_api/cluster%20manger/map_icon_generator.dart';
import 'package:google_maps_rest_api/utils/marker_icon_loader.dart';
import '../bloc/chart_panel_cubit.dart';
import '../services/school_model.dart';

class ClusterMarkerManager {
  ClusterMarkerManager(this.pmDataCubit, this.iconLoader);
  final PMDataCubit pmDataCubit;
  final MarkerIconLoader iconLoader;

  Future<Marker> Function(
      Cluster<SchoolModel>, BuildContext context) get markerBuilder => (cluster,
          context) async {
        return Marker(
            markerId: MarkerId(cluster.isMultiple
                ? cluster.getId()
                : cluster.items.single.schoolName.toString()),
            position: cluster.location,
            icon: cluster.isMultiple
                ? await getClusterIcon(cluster) : await getIconBasedOnPm25(cluster.items.single, iconLoader), 
            infoWindow: cluster.isMultiple
                ? const InfoWindow()
                : InfoWindow(title: cluster.items.single.schoolName),
            onTap: () {
              context.read<PMDataCubit>().updateData(cluster.items.single.airQualityPm25);
              context.read<ChartPanelCubit>().togglePanel(!cluster.isMultiple);
            });
      };
}
