import 'package:daily_dose_of_happiness/model/dailys/happiness_package_model.dart';
import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:equatable/equatable.dart';

abstract class HappinessPackState extends Equatable {
  const HappinessPackState();
  // type user -> dynamic
  @override
  List<FeelingModel> get props => [];
}

class InitHappinessPackState extends HappinessPackState {}

class LoadedHappinessPackState extends HappinessPackState {
  final HappinessPackModel pack;
  const LoadedHappinessPackState({required this.pack});
}

//in loading
class LoadingHappinessPackState extends HappinessPackState {}

// failed, no information
class FailedLoadHappinessPackState extends HappinessPackState {}
