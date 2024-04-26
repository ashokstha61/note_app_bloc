import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectionCheck { Connected, NotConnected }

class ConnectionCheckCubit extends Cubit<ConnectionCheck> {
  StreamSubscription? _subscription;
  ConnectionCheckCubit() : super(ConnectionCheck.NotConnected) {
    Connectivity().checkConnectivity().then((event) {
      if (!event.contains(ConnectivityResult.none)) {
        emit(ConnectionCheck.Connected);
      } else {
        emit(ConnectionCheck.NotConnected);
      }
    });
    _subscription = Connectivity().onConnectivityChanged.listen((event) {
      if (!event.contains(ConnectivityResult.none)) {
        emit(ConnectionCheck.Connected);
      } else {
        emit(ConnectionCheck.NotConnected);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription!.cancel();
    return super.close();
  }
}
