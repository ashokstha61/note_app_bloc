import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/cubit/connection_cubit.dart';
import 'package:todo_app/services/database_services.dart';

class UnSyncDataControlCubit extends Cubit<CommonState> {
  final ConnectionCubit connectionCubit;
  StreamSubscription? _subscription;
  bool _dialogOpen = false;
  UnSyncDataControlCubit({required this.connectionCubit})
      : super(CommonInitialState()) {
    _subscription = connectionCubit.stream.listen((event) async {
      if (event == ConnectionCheck.Connected) {
        final unSyncList = await DatabaseServices.getUnSyncData();
        if (unSyncList.isNotEmpty && _dialogOpen == false) {
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
