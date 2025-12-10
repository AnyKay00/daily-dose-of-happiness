import 'package:equatable/equatable.dart';

abstract class FeelingEvent extends Equatable {
  const FeelingEvent();

  @override
  List<Object> get props => [];
}

class SendDailyFeelingsEvent extends FeelingEvent {
  final String feelingId;
  const SendDailyFeelingsEvent({required this.feelingId});
}
