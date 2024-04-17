import 'package:todo_app/model/todo.dart';

abstract class NoteState {}

class NoteInitialState extends NoteState {}

class NoteLoadingState extends NoteState {}

class NoteErrorState extends NoteState {
  final String message;

  NoteErrorState({required this.message});
}

class NoteSuccessState extends NoteState {
  final List<Todo> todo;

  NoteSuccessState({required this.todo});
}

class NoteNoDataState extends NoteState {}
