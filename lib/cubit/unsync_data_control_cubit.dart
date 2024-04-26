import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/cubit/connection_state_check.dart';
import 'package:todo_app/services/database_services.dart';

class UnSyncDataControlCubit extends Cubit<CommonState> {
  final ConnectionCheckCubit connectionCubit;
  StreamSubscription? _subscription;
  bool _dialogOpen = false;
  UnSyncDataControlCubit({required this.connectionCubit})
      : super(CommonInitialState()) {
    _subscription = connectionCubit.stream.listen((event) async {
      if (event == ConnectionCheck.Connected && _dialogOpen == false) {
        final unsyncList = await DatabaseServices.getUnSyncronizedData();
        if (unsyncList.isNotEmpty) {
          _dialogOpen = true;
          emit(CommonLoadingState());
          emit(CommonSuccessState(data: true));
        } else {
          emit(CommonLoadingState());
          emit(CommonSuccessState(data: true));
        }
      }
    });
  }
  void dialogBoxClosed() {
    _dialogOpen = false;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
