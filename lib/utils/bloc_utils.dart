import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/cubit/common_state.dart';

class BlocUtils {
  static defaultBlocListener({
    required BuildContext context,
    required CommonState state,
    required VoidCallback onSuccess,
  }) {
    if (state is CommonLoadingState) {
      context.loaderOverlay.show();
    } else {
      context.loaderOverlay.hide();
    }

    if (state is CommonSuccessState) {
      onSuccess();
    } else if (state is CommonErrorState) {
      Fluttertoast.showToast(msg: state.message);
    }
  }
}
