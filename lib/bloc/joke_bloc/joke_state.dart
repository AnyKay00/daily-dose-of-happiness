import 'package:daily_dose_of_happiness/model/joke_model.dart';
import 'package:equatable/equatable.dart';

//abstract class for the states
//equatable overrides == operator
abstract class JokeState extends Equatable {
  const JokeState();
  @override
  List<JokeModel> get props => [];
}

// loaded daily motivation
class LoadedJokeState extends JokeState {
  const LoadedJokeState({required this.joke});
  final List<JokeModel> joke;
  @override
  List<JokeModel> get props => joke;
}

// in loading
class LoadingJokeState extends JokeState {}

// failed, no information
class FailedLoadJokeState extends JokeState {}
