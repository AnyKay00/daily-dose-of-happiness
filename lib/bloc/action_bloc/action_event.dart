import 'package:equatable/equatable.dart';

abstract class ActionEvent extends Equatable {
  const ActionEvent();

  @override
  List<Object> get props => [];
}

class LoadActionEvent extends ActionEvent {}

class SaveActionToMemoryBookEvent extends ActionEvent {
  final String id;
  const SaveActionToMemoryBookEvent({required this.id});
}

class LikeActionEvent extends ActionEvent {
  final String id;
  const LikeActionEvent({required this.id});
}
