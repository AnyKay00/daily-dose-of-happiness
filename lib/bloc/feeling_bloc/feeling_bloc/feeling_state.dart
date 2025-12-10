import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:equatable/equatable.dart';

abstract class FeelingState extends Equatable {
  const FeelingState();
  // type user -> dynamic
  @override
  List<FeelingModel> get props => [];
}

class InitFeelingState extends FeelingState {}

class SuccessfullFeelingState extends FeelingState {}

//in loading
class LoadingFeelingState extends FeelingState {}

// failed, no information
class FailedLoadFeelingState extends FeelingState {}
