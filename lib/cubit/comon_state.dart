import 'package:todo_app/model/todo.dart';

abstract class CommonState {}

class CommonInitialState extends CommonState {}

class CommonLoadingState extends CommonState {}

class CommonErrorState extends CommonState {
  final String message;

  CommonErrorState({required this.message});
}

class CommonSuccessState<T> extends CommonState {
  final T data;
  // final List<Todo> todo;

  CommonSuccessState({required this.data});
}

class CommonNoDataState extends CommonState {}
