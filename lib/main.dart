import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'maps.dart';
import 'block/marker_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => MarkerCubit()..fetchAndSetMarkers(),
      child: const MyApp(),
    ),
  );
}