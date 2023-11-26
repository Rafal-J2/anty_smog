import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserSate extends Equatable {}

class UserLoadingState extends UserSate {
  @override
  List<Object?> get props => [];
}