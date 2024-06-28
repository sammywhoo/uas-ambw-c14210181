import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../models/settings.dart';
import 'note_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Note> notesBox;
  late Box<Settings> settingsBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
    settingsBox = Hive.box<Settings>('settings');
  }

  void _addOrEditNote([Note? note]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteScreen(note: note),
      ),
    ).then((_) => setState(() {}));
  }

  void _changePin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UAS AMBW - NOTE APP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addOrEditNote(),
          ),
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: _changePin,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('No notes available'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Note note = box.getAt(index)!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 0),
                        blurRadius: 1.0,
                        spreadRadius: 0.1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Text('Created : ${note.createdDate}'),
                            Text('Edited : ${note.lastEditedDate}'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {
                                  _addOrEditNote(note);
                                },
                                icon: Icon(Icons.edit)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                onPressed: () {
                                  note.delete();
                                },
                                icon: Icon(Icons.delete)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
