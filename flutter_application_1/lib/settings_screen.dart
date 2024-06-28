import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/settings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _pinController = TextEditingController();
  late Box<Settings> settingsBox;

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box<Settings>('settings');
  }

  void _changePin() {
    final newPin = _pinController.text;
    final settings = settingsBox.get('settings') as Settings?;
    if (settings != null) {
      settings.pin = newPin;
      settings.save();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN updated')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(labelText: 'New PIN'),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePin,
              child: const Text('Change PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
