import 'package:clean_architecture_note_app/domain/model/note.dart';
import 'package:clean_architecture_note_app/domain/util/note_order.dart';
import 'package:clean_architecture_note_app/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:clean_architecture_note_app/presentation/notes/components/note_item.dart';
import 'package:clean_architecture_note_app/presentation/notes/components/order_section.dart';
import 'package:clean_architecture_note_app/presentation/notes/notes_event.dart';
import 'package:clean_architecture_note_app/presentation/notes/notes_view_model.dart';
import 'package:clean_architecture_note_app/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Your note',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              viewModel.onEvent(const NotesEvent.toggleOrderSection());
            },
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isSaved = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditNoteScreen(),
            ),
          );
          if (isSaved != null && isSaved) {
            viewModel.onEvent(const NotesEvent.loadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: state.isOrderSectionVisible
                ? OrderSection(
                    noteOrder: viewModel.state.noteOrder,
                    onOrderChanged: (NoteOrder noteOrder) {
                      viewModel.onEvent(NotesEvent.changeOrder(noteOrder));
                    },
                  )
                : Container(),
          ),
          ...state.notes
              .map(
                (note) => GestureDetector(
                  onTap: () async {
                    bool? isSaved = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditNoteScreen(
                          note: note,
                        ),
                      ),
                    );

                    if (isSaved != null && isSaved) {
                      viewModel.onEvent(const NotesEvent.loadNotes());
                    }
                  },
                  child: NoteItem(
                    note: note,
                    onDeleteTap: () {
                      viewModel.onEvent(NotesEvent.deleteNote(note));

                      final snackBar = SnackBar(
                        content: const Text('????????? ?????????????????????.'),
                        action: SnackBarAction(
                          label: '??????',
                          onPressed: () {
                            viewModel.onEvent(const NotesEvent.restoreNote());
                          },
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                ),
              )
              .toList(),
        ]),
      ),
    );
  }
}
