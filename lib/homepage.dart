import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/create_notes_screen.dart';
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
  Future<List<Todo>> fetchTodoList() async {
    final dio = Dio();
    final res =
        await dio.get("https://note-backend-n9u1.onrender.com/api/notes");
    //res.status code
    //
    List temp = List.from(res.data["data"]);
    return temp.map((e) => Todo.fromMap(e)).toList();
    // return List.generate(
    //   10,
    //   (index) => Todo(
    //     title: Faker().person.name(),
    //     description: Faker().address.city(),
    //   ),
    // );
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateNotesScreen(),
            ),
          );
          if (res == true) {
            setState(() {});
          }
        },
        child: Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder<List<Todo>>(
        future: fetchTodoList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("No NOtes Found."),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].description),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => DeleteNoteWarningDialog(
                              onConfirm: () {
                                onDelete(snapshot.data![index].id);
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                      onTap: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateNotesScreen(
                              todo: snapshot.data![index],
                            ),
                          ),
                        );
                        if (res == true) {
                          setState(() {});
                        }
                      },
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
              }
            } else {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
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
