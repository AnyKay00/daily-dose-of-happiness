import 'package:equatable/equatable.dart';

abstract class FeelingEvent extends Equatable {
  const FeelingEvent();

  @override
  List<Object> get props => [];
}

class SendDailyFeelingEvent extends FeelingEvent {
  final String feelingId;
  const SendDailyFeelingEvent({required this.feelingId});
}
