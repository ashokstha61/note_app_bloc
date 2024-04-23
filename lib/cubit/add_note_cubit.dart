import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/cubit/note_event.dart';
import 'package:todo_app/repository/note_repository.dart';

class AddNoteCubit extends Bloc<NoteEvent, CommonState> {
  final NoteRepository repository;
  AddNoteCubit({required this.repository}) : super(CommonInitialState()) {
    on<AddNoteEvent>(
      (event, emit) async {
        emit(CommonLoadingState());
        await Future.delayed(Duration(seconds: 2));
        final res = await repository.addNotes(
            title: event.title, description: event.description);
        res.fold(
          (err) => emit(CommonErrorState(message: err)),
          (data) => emit(CommonSuccessState(data: null)),
        );
      },
      transformer: droppable(),
    );
  }
  // addNote({required String title, required String description}) async {

  // }
}
