import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/add_note_cubit.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/note_repository.dart';

class FetchNoteCubit extends Cubit<CommonState> {
  final NoteRepository repository;
  final AddNoteCubit addNoteCubit;

  StreamSubscription? _subscription;
  
  FetchNoteCubit({required this.addNoteCubit, required this.repository})
      : super(CommonInitialState());

  fetch() async {
    emit(CommonLoadingState());
    final res = await repository.fetchNotes();
    res.fold(
      (err) => emit(CommonErrorState(message: err)),
      (data) {
        if (data.isEmpty) {
          emit(CommonNoDataState());
        } else {
          emit(CommonSuccessState<List<Todo>>(data: data));
        }
      },
    );
  }
}
