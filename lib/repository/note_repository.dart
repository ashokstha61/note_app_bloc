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
      _notes.clear();
      _notes.addAll(finalList);
      return Right(_notes);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to fetch notes");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> addNotes({
    required String title,
    required String description,
  }) async {
    try {
      final res = await _dio.post(
        "https://note-backend-n9u1.onrender.com/api/notes",
        data: {
          "title": title,
          "description": description,
        },
      );
      //res.status code
      //
      Todo temp = Todo.fromMap(res.data["data"]);
      _notes.add(temp);
      return Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to add notes");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> updateNotes(
      {required String id,
      required String title,
      required String description}) async {
    try {
      final res = await _dio.delete(
        "https://note-backend-n9u1.onrender.com/api/notes/$id}",
      );
      Todo temp = Todo.fromMap(res.data["data"]);
      final index = _notes.indexWhere((e) => e.id == temp.id);
      if (index != -1) {
        _notes[index] = temp;
      }
      return Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to Update note");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> deleteNotes({required String id}) async {
    try {
      final _ = await _dio.put(
        "https://note-backend-n9u1.onrender.com/api/notes/$id}",
      );
      _notes.removeWhere((e) => e.id == id);
      return Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to delete note");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
