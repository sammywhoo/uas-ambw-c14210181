import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  NoteScreen({this.note});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late Box<Note> notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() {
    final title = _titleController.text;
    final content = _contentController.text;
    final now = DateTime.now();

    if (widget.note == null) {
      notesBox.add(Note(
        title: title,
        content: content,
        createdDate: now,
        lastEditedDate: now,
      ));
    } else {
      widget.note!.title = title;
      widget.note!.content = content;
      widget.note!.lastEditedDate = now;
      widget.note!.save();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
