import 'package:clean_architecture_note_app/domain/model/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_ui_event.freezed.dart';

@freezed
abstract class AddEditNoteUIEvent with _$AddEditNoteUIEvent {
  const factory AddEditNoteUIEvent.saveNote() = SaveNote;
}
