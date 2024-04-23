
abstract class NoteEvent {}

class AddNoteEvent extends NoteEvent {
  final String title;
  final String description;
  AddNoteEvent({
    required this.title,
    required this.description,
  }) {}
}
