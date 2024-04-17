import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:todo_app/model/todo.dart';

class NoteRepository {
  final List<Todo> _notes = [];

  List<Todo> get notes => UnmodifiableListView(_notes);

  Future<List<Todo>> fetchNotes() async{
    try {
      
    }on DioException catch (e) {
      
    }
  }
}
