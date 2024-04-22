import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/cubit/add_note_cubit.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/cubit/delete_note_cubit.dart';
import 'package:todo_app/cubit/update_notes_cubit.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/repository/note_repository.dart';

class FetchNoteCubit extends Cubit<CommonState> {
  final NoteRepository repository;
  final AddNoteCubit addNoteCubit;
  final UpdateNoteCubit updateNoteCubit;
  final DeleteNoteCubit deleteNoteCubit;

  StreamSubscription? _subscription;

  FetchNoteCubit({
    required this.addNoteCubit,
    required this.repository,
    required this.updateNoteCubit,
    required this.deleteNoteCubit,
  }) : super(CommonInitialState()) {
    // _subscription=Rx.merge([addNoteCubit.stream,deleteNoteCubit.stream,updateNoteCubit.stream]).listen(event){
    // _subscription = addNoteCubit.stream.listen((event) {
    final combinedStream=Rx.merge([
      addNoteCubit.stream,
      updateNoteCubit.stream,
      deleteNoteCubit.stream
    ]);
    _subscription = combinedStream.listen((event) {
      if (event is CommonSuccessState) {
        // fetch();
        refresh();
      }
    });
  }

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

  refresh() async {
    emit(CommonLoadingState());
    emit(CommonSuccessState<List<Todo>>(data: repository.notes));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
