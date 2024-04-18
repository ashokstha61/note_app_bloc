import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/comon_state.dart';

class AddNoteCubit extends Cubit<CommonState> {
  AddNoteCubit() : super(AddNoteInitial());
}