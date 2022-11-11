import 'package:clean_architecture_note_app/data/data_source/note_db.dart';
import 'package:clean_architecture_note_app/domain/model/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('db test', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    await db.execute(
        'CREATE TABLE note (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, color INTEGER, timeStamp INTEGER)');

    final noteDbHelper = NoteDbHelper(db);

    await noteDbHelper.insertNote(const Note(
      title: 'test',
      content: 'test',
      color: 1,
      timeStamp: 1,
    ));

    expect((await noteDbHelper.getNotes()).length, 1);

    Note note = (await noteDbHelper.getNoteById(1))!;
    expect(note.id, 1);

    await noteDbHelper.updateNote(note.copyWith(title: 'change'));

    note = (await noteDbHelper.getNoteById(1))!;
    expect(note.title, 'change');

    await noteDbHelper.deleteNote(note);
    expect((await noteDbHelper.getNotes()).length, 0);

    await db.close();
  });
}
