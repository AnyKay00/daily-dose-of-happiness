import 'package:daily_dose_of_happiness/model/motivation_model.dart';
import 'package:equatable/equatable.dart';

//abstract class for the states
//equatable overrides == operator
abstract class MotivationState extends Equatable {
  const MotivationState();
  // type user -> dynamic
  @override
  List<MotivationModel> get props => [];
}

// loaded daily motivation
class LoadedMotivationState extends MotivationState {
  const LoadedMotivationState({required this.motivation});
  final List<MotivationModel> motivation;
  @override
  List<MotivationModel> get props => motivation;
}

//in loading
class LoadingMotivationState extends MotivationState {}

// failed, no information
class FailedLoadMotivationState extends MotivationState {}
