import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/unsync_data_control_cubit.dart';

class SyncBottomPage extends StatelessWidget {
  const SyncBottomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Syncing Alert"),
      content: Text("You have unsyncronized data. Please Sync the data"),
      actions: [
        TextButton(
          onPressed: () {
            context.read<UnSyncDataControlCubit>().dialogBoxClosed();
            Navigator.pop(context);
          },
          child: Text("Sync"),
        ),
      ],
    );
  }
}

showSyncDialog({required BuildContext context}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SyncBottomPage();
      });
}
