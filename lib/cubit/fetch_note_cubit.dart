import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/note_state.dart';
import 'package:todo_app/repository/note_repository.dart';

class FetchNoteCubit extends Cubit<NoteState> {
  final NoteRepository repository;
  FetchNoteCubit(this.repository) : super(NoteInitialState());

  fetch() async {
    emit(NoteLoadingState());
    final res = await repository.fetchNotes();
    res.fold(
      (err) => emit(NoteErrorState(message: err)),
      (data) {
        if (data.isEmpty) {
          emit(NoteNoDataState());
        } else {
          emit(NoteSuccessState(todo: data));
        }
      },
    );
  }
}
