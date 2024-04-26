import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/cubit/add_note_cubit.dart';
import 'package:todo_app/cubit/connection_state_check.dart';
import 'package:todo_app/cubit/delete_note_cubit.dart';
import 'package:todo_app/cubit/fetch_note_cubit.dart';
import 'package:todo_app/cubit/unsync_data_control_cubit.dart';
import 'package:todo_app/cubit/update_notes_cubit.dart';
import 'package:todo_app/homepage.dart';
import 'package:todo_app/repository/note_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NoteRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ConnectionCheckCubit(),
          ),
          BlocProvider(
            create: (context) => UnSyncDataControlCubit(
                connectionCubit: context.read<ConnectionCheckCubit>()),
          ),
          BlocProvider(
            create: (context) => AddNoteCubit(
              repository: context.read<NoteRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => UpdateNoteCubit(
              repository: context.read<NoteRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => DeleteNoteCubit(
              repository: context.read<NoteRepository>(),
            ),
          ),
        ],
        child: GlobalLoaderOverlay(
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: false,
            ),
            home: BlocProvider(
              create: (context) => FetchNoteCubit(
                repository: context.read<NoteRepository>(),
                addNoteCubit: context.read<AddNoteCubit>(),
                updateNoteCubit: context.read<UpdateNoteCubit>(),
                deleteNoteCubit: context.read<DeleteNoteCubit>(),
              ),
              child: HomePageScreen(),
            ),
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}
