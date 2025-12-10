import 'package:equatable/equatable.dart';

abstract class JokeEvent extends Equatable {
  const JokeEvent();

  @override
  List<Object> get props => [];
}

class LoadJokeEvent extends JokeEvent {}

class SaveJokeToMemoryBookEvent extends JokeEvent {
  final String id;
  const SaveJokeToMemoryBookEvent({required this.id});
}

class LikeJokeEvent extends JokeEvent {
  final String id;
  const LikeJokeEvent({required this.id});
}
