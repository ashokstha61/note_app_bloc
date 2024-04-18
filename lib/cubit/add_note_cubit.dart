import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/repository/note_repository.dart';

class AddNoteCubit extends Cubit<CommonState> {
  final NoteRepository repository;
  AddNoteCubit({required this.repository}) : super(CommonInitialState());
  addNote({required String title, required String description}) async {
    emit(CommonLoadingState());
    final res =
        await repository.addNotes(title: title, description: description);
    res.fold(
      (err) => emit(CommonErrorState(message: err)),
      (data) => emit(CommonSuccessState(data: null)),
    );
  }
}
