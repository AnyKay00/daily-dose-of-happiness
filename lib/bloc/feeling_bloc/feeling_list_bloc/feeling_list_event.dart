import 'package:equatable/equatable.dart';

abstract class FeelingListEvent extends Equatable {
  const FeelingListEvent();

  @override
  List<Object> get props => [];
}

class LoadFeelingsEvent extends FeelingListEvent {}


class LoadLastWeekFeelingsEvent extends FeelingListEvent {}
