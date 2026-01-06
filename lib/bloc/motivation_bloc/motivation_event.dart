import 'package:equatable/equatable.dart';

abstract class MotivationEvent extends Equatable {
  const MotivationEvent();

  @override
  List<Object> get props => [];
}


class SaveMotivationToMemoryBookEvent extends MotivationEvent {
  final String id;
  const SaveMotivationToMemoryBookEvent({required this.id});
}

class LikeMotivationEvent extends MotivationEvent {
  final String id;
  const LikeMotivationEvent({required this.id});
}
