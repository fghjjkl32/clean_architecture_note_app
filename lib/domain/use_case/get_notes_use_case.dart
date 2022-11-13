import 'package:clean_architecture_note_app/domain/model/note.dart';
import 'package:clean_architecture_note_app/domain/repository/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  Future<List<Note>> call() async {
    List<Note> notes = await repository.getNotes();
    notes.sort((a, b) => -a.timeStamp.compareTo(b.timeStamp));
    return notes;
  }
}
