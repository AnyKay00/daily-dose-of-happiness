import 'package:equatable/equatable.dart';

abstract class HappinessPackEvent extends Equatable {
  const HappinessPackEvent();

  @override
  List<Object> get props => [];
}

class LoadHappinessPackOfFeelingEvent extends HappinessPackEvent {
  final String feelingId;
  const LoadHappinessPackOfFeelingEvent({required this.feelingId});
}
