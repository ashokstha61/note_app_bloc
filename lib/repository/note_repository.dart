import 'dart:collection';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/services/database_services.dart';

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
      await DatabaseServices.deleteAllNote();
      await DatabaseServices.insertAllNote(finalList);

      _notes.clear();
      _notes.addAll(finalList);
      return Right(_notes);
    } on DioException catch (e) {
      if (e.error is SocketException) {
        final finalList = await DatabaseServices.fetchNotes();
        if (finalList.isNotEmpty) {
          _notes.addAll(finalList);
          return Right(finalList);
        }
        return Left("No Internet Connection!");
      }
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
      final _ = await DatabaseServices.createNote(
          id: temp.id,
          title: temp.title,
          description: temp.description,
          createAt: temp.createdAt);
      // final temp = await DatabaseServices.createNote(
      //     title: title, description: description);
      _notes.add(temp);
      return Right(null);
    } on DioException catch (e) {
      if (e.error is SocketException) {
        final newTodo = await DatabaseServices.createNote(
          title: title,
          description: description,
          createAt: DateTime.now(),
        );
        _notes.add(newTodo);
        return Right(null);
      }

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
      final res = await _dio.put(
        "https://note-backend-n9u1.onrender.com/api/notes/$id",
        data: {
          "title": title,
          "description": description,
        },
      );
      Todo temp = Todo.fromMap(res.data["data"]);

      await DatabaseServices.updateNote(
        id: id,
        title: title,
        description: description,
        sync: true,
      );
      final index = _notes.indexWhere((e) => e.id == temp.id);
      if (index != -1) {
        _notes[index] = temp;
      }
      return Right(null);
    } on DioException catch (e) {
      if (e.error is SocketException) {
        final updatedNote = await DatabaseServices.updateNote(
          id: id,
          title: title,
          description: description,
          sync: false,
        );
        final index = _notes.indexWhere((e) => e.id == id);
        if (index != -1) {
          _notes[index] = updatedNote;
        }
        return Right(null);
      }
      return Left(e.response?.data["message"] ?? "Unable to Update note");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> deleteNotes({required String id}) async {
    try {
      final _ = await _dio.delete(
        "https://note-backend-n9u1.onrender.com/api/notes/$id",
      );
      // await DatabaseServices.deleteNote(id: id);
      _notes.removeWhere((e) => e.id == id);
      return Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to delete note");
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> syncNotes() async {
    try {
      final unsyncData = await DatabaseServices.getUnSyncronizedData();

      final _ = await _dio.post(
        "https://note-backend-n9u1.onrender.com/api/notes/sync",
        data: {
          "todo": unsyncData.map((e) => {
                "id": e.id,
                "title": e.title,
                "description": e.description,
              }),
        },
      );
      //res.status code
      //

      return Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to sync notes");
    } catch (e) {
      return Left(e.toString());
    }
  }
}
