import 'package:daily_dose_of_happiness/model/dailys/action_model.dart';
import 'package:equatable/equatable.dart';

abstract class ActionState extends Equatable {
  const ActionState();
  @override
  List<ActionModel> get props => [];
}

// loaded daily action
class LoadedActionState extends ActionState {
  const LoadedActionState({required this.action});
  final ActionModel action;
}

//in loading
class LoadingActionState extends ActionState {}

// failed, no information
class FailedLoadActionState extends ActionState {}
