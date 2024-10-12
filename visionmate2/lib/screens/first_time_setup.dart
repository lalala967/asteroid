import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart'; // Make sure to import your home page

class FirstTimeSetup extends StatefulWidget {
  const FirstTimeSetup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstTimeSetupState createState() => _FirstTimeSetupState();
}

class _FirstTimeSetupState extends State<FirstTimeSetup> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Time Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _completeSetup,
              child: const Text('Complete Setup'),
            ),
          ],
        ),
      ),
    );
  }

  void _completeSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the user details (optional, in case you want to retrieve them later)
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setInt('age', int.tryParse(_ageController.text) ?? 0);

    // Mark the setup as complete
    await prefs.setBool('is_setup_complete', true);

    // Navigate to the home page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
