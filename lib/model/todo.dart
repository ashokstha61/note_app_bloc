class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map["_id"],
      title: map["title"],
      description: map["description"], createdAt: DateTime.parse(map["createdAt"]).toLocal(),
    );
  }
  factory Todo.fromDB(Map<String, dynamic> map) {
    return Todo(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["created_at"]),
    );
  }

  Map<String, dynamic> toDBData() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "created_at": createdAt.millisecondsSinceEpoch,
      "sync":true,
    };
  }
}
