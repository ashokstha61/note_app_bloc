import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/create_notes_screen.dart';
import 'package:todo_app/cubit/common_state.dart';
import 'package:todo_app/cubit/fetch_note_cubit.dart';

import 'package:todo_app/model/todo.dart';
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

  Future<void> onDelete(String id) async {
    try {
      context.loaderOverlay.show();
      final dio = Dio();
      final _ = await dio.delete(
        "https://note-backend-n9u1.onrender.com/api/notes/${id}",
      );
      Fluttertoast.showToast(msg: "Notes Deleted successfully");
      setState(() {});
    } on DioException catch (e) {
      Fluttertoast.showToast(
          msg: e.response?.data["message"] ?? "Unable to Delete note");
    } catch (e) {
      Fluttertoast.showToast(msg: "unable to Delete message");
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  void initState() {
    context.read<FetchNoteCubit>().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
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
      body: BlocBuilder<FetchNoteCubit, CommonState>(
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
                            onDelete(state.data[index].id);
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
    );
  }
}
