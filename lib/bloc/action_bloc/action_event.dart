import 'package:equatable/equatable.dart';

abstract class ActionEvent extends Equatable {
  const ActionEvent();

  @override
  List<Object> get props => [];
}

class LoadActionEvent extends ActionEvent {}
