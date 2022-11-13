import 'package:clean_architecture_note_app/domain/model/note.dart';
import 'package:clean_architecture_note_app/domain/util/note_order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'notes_state.freezed.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    required List<Note> notes,
    required NoteOrder noteOrder,
    required bool isOrderSectionVisible,
  }) = _NotesState;
}
