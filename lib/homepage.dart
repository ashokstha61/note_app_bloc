import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/create_notes_screen.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/cubit/delete_note_cubit.dart';
import 'package:todo_app/cubit/fetch_note_cubit.dart';
import 'package:todo_app/cubit/sync_data_cubit.dart';
import 'package:todo_app/cubit/unsync_data_control_cubit.dart';

import 'package:todo_app/model/todo.dart';
import 'package:todo_app/sync_botton_page.dart';
import 'package:todo_app/utils/bloc_utils.dart';
import 'package:todo_app/widgets/warinig_diaglog.dart';

class HomePageScreen extends StatefulWidget {
  final Todo? todo;
  const HomePageScreen({
    super.key,
    this.todo,
  });

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  // Future<List<Todo>> fetchTodoList() async {
  //   final dio = Dio();
  //   final res =
  //       await dio.get("https://note-backend-n9u1.onrender.com/api/notes");
  //   //res.status code
  //   //
  //   List temp = List.from(res.data["data"]);
  //   return temp.map((e) => Todo.fromMap(e)).toList();
  //   // return List.generate(
  //   //   10,
  //   //   (index) => Todo(
  //   //     title: Faker().person.name(),
  //   //     description: Faker().address.city(),
  //   //   ),
  //   // );
  // }

  // Future<void> onDelete(String id) async {
  //   try {
  //     context.loaderOverlay.show();
  //     final dio = Dio();
  //     final _ = await dio.delete(
  //       "https://note-backend-n9u1.onrender.com/api/notes/${id}",
  //     );
  //     Fluttertoast.showToast(msg: "Notes Deleted successfully");
  //     setState(() {});
  //   } on DioException catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.response?.data["message"] ?? "Unable to Delete note");
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "unable to Delete message");
  //   } finally {
  //     context.loaderOverlay.hide();
  //   }
  // }

  @override
  void initState() {
    context.read<FetchNoteCubit>().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocSelector<FetchNoteCubit, CommonState, String>(
          selector: (state) {
            if (state is CommonSuccessState<List<Todo>>) {
              return state.data.length.toString();
            } else if (state is CommonNoDataState) {
              return "0";
            } else {
              return "-";
            }
          },
          builder: (context, state) {
            return Text("Notes ($state)");
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSyncDialog(context: context);
            },
            icon: Icon(
              Icons.check_box,
            ),
          )
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CreateNotesScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteNoteCubit, CommonState>(
            listener: (context, state) {
              BlocUtils.defaultBlocListener(
                  context: context,
                  state: state,
                  onSuccess: () {
                    Fluttertoast.showToast(msg: "Note Delete Successfully");
                  });
            },
          ),
          BlocListener<UnSyncDataControlCubit, CommonState>(
            listener: (context, state) {
              if (state is CommonSuccessState<bool> && state.data) {
                if (state.data) {
                  showSyncDialog(context: context);
                } else {
                  context.read<FetchNoteCubit>().fetch();
                }
              }
            },
          ),
          BlocListener<SyncDataCubit, CommonState>(
            listener: (context, state) {
              BlocUtils.defaultBlocListener(
                  context: context,
                  state: state,
                  onSuccess: () {
                    Fluttertoast.showToast(msg: "Note Sync Successfully");
                    context.read<FetchNoteCubit>().fetch();
                  });
            },
          ),
        ],
        child: BlocBuilder<FetchNoteCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonSuccessState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.data[index].title),
                    subtitle: Text(state.data[index].description),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => DeleteNoteWarningDialog(
                            onConfirm: () {
                              context.read<DeleteNoteCubit>().DeleteNote(
                                    id: state.data[index].id,
                                  );
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.delete),
                    ),
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateNotesScreen(
                            todo: state.data[index],
                          ),
                        ),
                      );
                    },
                  );
                },
                itemCount: state.data.length,
              );
            } else if (state is CommonErrorState) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is CommonNoDataState) {
              return Center(
                child: Text("No data saved till now."),
              );
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
