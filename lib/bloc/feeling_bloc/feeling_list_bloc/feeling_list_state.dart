import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:daily_dose_of_happiness/model/user_feeling_model.dart';
import 'package:equatable/equatable.dart';

abstract class FeelingListState extends Equatable {
  const FeelingListState();
  // type user -> dynamic
  @override
  List<dynamic> get props => [];
}

class InitFeelingListState extends FeelingListState {}

class LoadedFeelingListState extends FeelingListState {
  final List<FeelingModel> feelings;
  const LoadedFeelingListState({required this.feelings});
  @override
  List<FeelingModel> get props => feelings;
}

class LoadedLastWeekFeelingListState extends FeelingListState {
  final List<UserFeelingModel> feelings;
  const LoadedLastWeekFeelingListState({required this.feelings});
  @override
  List<UserFeelingModel> get props => feelings;
}

//in loading
class LoadingFeelingListState extends FeelingListState {}

// failed, no information
class FailedLoadFeelingListState extends FeelingListState {}
