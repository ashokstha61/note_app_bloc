import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/repository/note_repository.dart';

class DeleteNoteCubit extends Cubit<CommonState> {
  final NoteRepository repository;
  DeleteNoteCubit({required this.repository}) : super(CommonInitialState());
  DeleteNote({required String id}) async {
    emit(CommonLoadingState());
    final res = await repository.deleteNotes(id: id);
    res.fold(
      (err) => emit(CommonErrorState(message: err)),
      (data) => emit(CommonSuccessState(data: null)),
    );
  }
}
