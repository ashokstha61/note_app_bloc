import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/repository/note_repository.dart';

class SyncDataCubit extends Cubit<CommonState> {
  final NoteRepository repo;
  SyncDataCubit({required this.repo}) : super(CommonInitialState());
  void sync() async {
    emit(CommonLoadingState());
    final res = await repo.syncNotes();
    res.fold(
      (err) => emit(CommonErrorState(message: err)),
      (data) => emit(CommonSuccessState(data: null)),
    );
  }
}
