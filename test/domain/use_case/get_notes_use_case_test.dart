import 'package:clean_architecture_note_app/domain/model/note.dart';
import 'package:clean_architecture_note_app/domain/repository/note_repository.dart';
import 'package:clean_architecture_note_app/domain/use_case/get_notes_use_case.dart';
import 'package:clean_architecture_note_app/domain/util/note_order.dart';
import 'package:clean_architecture_note_app/domain/util/order_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_notes_use_case_test.mocks.dart';

@GenerateMocks([NoteRepository])
void main() {
  test('정렬 기능 작동', () async {
    final repository = MockNoteRepository();
    final getNotes = GetNotesUseCase(repository);

    when(repository.getNotes()).thenAnswer((_) async => [
          Note(title: 'title', content: 'content', timeStamp: 0, color: 1),
          Note(title: 'title2', content: 'content2', timeStamp: 2, color: 2),
        ]);

    List<Note> result =
        await getNotes(const NoteOrder.date(OrderType.descending()));

    expect(result, isA<List<Note>>());
    expect(result.first.timeStamp, 2);
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.date(OrderType.ascending()));
    expect(result.first.timeStamp, 0);
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.title(OrderType.ascending()));
    expect(result.first.title, 'title');
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.title(OrderType.descending()));
    expect(result.first.title, 'title2');
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.color(OrderType.ascending()));
    expect(result.first.color, 1);
    verify(repository.getNotes());

    result = await getNotes(const NoteOrder.color(OrderType.descending()));
    expect(result.first.color, 2);
    verify(repository.getNotes());

    verifyNoMoreInteractions(repository);
  });
}
