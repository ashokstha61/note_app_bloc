import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:todo_app/model/todo.dart';

class NoteRepository {
  final Dio _dio = Dio();
  final List<Todo> _notes = [];

  List<Todo> get notes => UnmodifiableListView(_notes);

  Future<Either<String, List<Todo>>> fetchNotes() async {
    try {
      final res =
          await _dio.get("https://note-backend-n9u1.onrender.com/api/notes");
      //res.status code
      //
      List temp = List.from(res.data["data"]);
      final finalList = temp.map((e) => Todo.fromMap(e)).toList();
      return Right(finalList);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to fetch notes");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
