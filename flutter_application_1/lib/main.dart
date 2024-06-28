import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/note.dart';
import 'models/settings.dart';
import 'pin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and Hive Flutter
  await Hive.initFlutter();

  // Registering the adapters
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(SettingsAdapter());

  // Opening the boxes
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Settings>('settings');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PinScreen(),
    );
  }
}
