import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/bloc/location_gps.dart';
import 'package:google_maps_rest_api/bloc/pm_data_cubit.dart';
import 'package:google_maps_rest_api/cluster%20manger/cluster_marker_manager.dart';
import 'package:google_maps_rest_api/services/get_api.dart';
import 'package:google_maps_rest_api/utils/marker_icon_loader.dart';
import '../bloc/chart_panel_cubit.dart';
import '../services/school_model.dart';
import '../shared/map_service.dart';
import '../shared/preferences_service.dart';
import 'package:logger/logger.dart';
import 'chart_panel.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class AntySmogApp extends StatefulWidget {
  const AntySmogApp({super.key});
  @override
  AntySmogAppState createState() => AntySmogAppState();
}

var logger = Logger();

/// Class representing the state of the AntySmogApp.
/// It includes methods for initializing the camera position, updating map type,
/// and building the main application widget.
class AntySmogAppState extends State<AntySmogApp> {
  late GoogleMapController _controller;
  MapType _currentMapType = MapType.normal;
  late ChartPanelCubit chartPanelCubit;
  late ClusterMarkerManager clusterMarkerManager;
  PMDataCubit pmDataCubit = PMDataCubit();
  MarkerIconLoader iconLoader = MarkerIconLoader();
  final LocationGps locationGps = LocationGps();

  /// Toggles the map type between normal (street view) and satellite when the map type button is pressed.
  /// This allows users to switch between different views of the map according to their preferences..
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Set<Marker> markers = {};
  late ClusterManager clusterManager;
  List<SchoolModel> schoolList = [];

  @override
  void initState() {
    super.initState();
    clusterMarkerManager = ClusterMarkerManager(pmDataCubit, iconLoader);
    clusterManager = _initialClusterManager();
    chartPanelCubit = ChartPanelCubit();
    loadAndSetSchools();
    iconLoader.loadMarkerIcons();
  }

  ClusterManager _initialClusterManager() {
    return ClusterManager<SchoolModel>(
      schoolList,
      _updateMarkers,
      markerBuilder: (cluster) =>
          clusterMarkerManager.markerBuilder(cluster, context),
      levels: [1, 4.25, 5.25, 8.25, 11.0, 14.0, 15.5, 16.0, 19.5],
      stopClusteringZoom: 10,
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

  Future<void> loadAndSetSchools() async {
    try {
      List<dynamic> apiData = await fetchApiData();
      List<SchoolModel> schools =
          apiData.map((json) => SchoolModel.fromJson(json)).toList();
      clusterManager.setItems(schools);
    } catch (e) {
      logger.t('Error occurred: $e');
    }
  }

  /// Initializes the camera position to the last known user position.
  /// It retrieves the last known latitude, longitude, and zoom level from SharedPreferences,
  /// which are saved whenever the user checks the air quality.
  void _initialCameraPosition() async {
    try {
      var mapService = getIt<MapService>();
      CameraPosition position = await mapService.initCameraPosition();
      _controller.animateCamera(CameraUpdate.newCameraPosition(position));
    } catch (e) {
      logger.e('Error initializing camera position $e');
    }
  }

  /// Builds the main application widget.
  ///
  /// This widget is the root of the application and contains a [GoogleMap] widget
  /// that displays dynamic markers. It uses [BlocBuilder] to listen for changes
  /// in [MarkerCubit], which manages the state of the markers based on geographical data.
  ///
  /// The map displays markers for each station, which are provided by the state of
  /// [MarkerCubit] as a set of markers (`state.values.toSet()`).
  ///
  ///  A GoogleMap widget that displays markers and allows interaction.
  /// - `onTap`: Defines behavior when the map is tapped. Currently, it sets '_isMarkerVisible' to true,
  ///   which triggers the display of a panel with charts related to the tapped location.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: BlocBuilder<ChartPanelCubit, bool>(
            builder: (context, isVisible) {
              return Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                      myLocationButtonEnabled: true,         
                      mapToolbarEnabled: false,        
                      onTap: (LatLng position) {
                        context.read<ChartPanelCubit>().togglePanel(false);
                      },
                      mapType: _currentMapType,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller = controller;
                        _initialCameraPosition();
                        clusterManager.setMapId(controller.mapId);
                      },
                      onCameraMove: (CameraPosition position) {
                        PreferencesService().saveCameraPosition(position);
                        clusterManager.onCameraMove(position);
                      },
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(52.237049, 21.017532),
                        zoom: 6,
                      ),
                      onCameraIdle: clusterManager.updateMap,
                      markers: markers),
                  if (isVisible)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
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
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: MarkerHelperUdate(),
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
                  Positioned(
                    bottom: 180,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: () async {
                        try {
                          Position? position =
                              await locationGps.getCurrentLocation();
                          if (position != null) {
                            _controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                      position.latitude, position.longitude),
                                  zoom: 12,
                                ),
                              ),
                            );
                          } else {
                            logger.i("Location is not available");
                          }
                        } catch (e) {
                          if (!mounted) return;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Błąd'),
                                content:
                                    Text('Location cannot be obtained: $e'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Icon(Icons.my_location),
                    ),
                  )
                ],
              );
            },
          ),
        ));
  }
}
