import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/settings.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  final bool isCreatingPin;

  PinScreen({this.isCreatingPin = false});

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _pinController = TextEditingController();
  late Box<Settings> settingsBox;

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box<Settings>('settings');
  }

  void _submitPin() {
    final enteredPin = _pinController.text;
    final settings = settingsBox.get('settings') as Settings?;
    
    if (widget.isCreatingPin) {
      // Create a new PIN
      settingsBox.put('settings', Settings(pin: enteredPin));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      if (settings == null) {
        // No PIN set, prompt to create one
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PinScreen(isCreatingPin: true)));
      } else if (settings.pin == enteredPin) {
        // Correct PIN entered
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        // Incorrect PIN
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect PIN')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCreatingPin ? 'Create PIN' : 'Enter PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(labelText: widget.isCreatingPin ? 'Create PIN' : 'Enter PIN'),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPin,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
