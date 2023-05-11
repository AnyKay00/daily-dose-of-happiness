import 'package:equatable/equatable.dart';

abstract class MotivationEvent extends Equatable {
  const MotivationEvent();

  @override
  List<Object> get props => [];
}

class LoadMotivationEvent extends MotivationEvent {}
