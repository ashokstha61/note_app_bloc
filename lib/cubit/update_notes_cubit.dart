import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/repository/note_repository.dart';

class UpdateNoteCubit extends Cubit<CommonState> {
  final NoteRepository repository;
  UpdateNoteCubit({required this.repository}) : super(CommonInitialState());
  updateNote({
    required String id,
    required String title,
    required String description,
  }) async {
    emit(CommonLoadingState());
    final res = await repository.updateNotes(
      id: id,
      title: title,
      description: description,
    );
    res.fold(
      (err) => emit(CommonErrorState(message: err)),
      (data) => emit(CommonSuccessState(data: null)),
    );
  }
}
