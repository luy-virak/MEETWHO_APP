import 'package:flutter/material.dart';
import 'package:meetwho/model/profile.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  extendBodyBehindAppBar: true,
  backgroundColor: Colors.transparent,
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
    title: const Text("Create Profile"),
  ),
  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2E7AF6),
          Color(0xFF45ABF0),
          Color(0xFFE8F2FF), // light bottom
        ],
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time (in minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _interestsController,
                decoration: const InputDecoration(labelText: 'Interests (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one interest';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final profile = Profile(
                      name: _nameController.text,
                      time: int.parse(_timeController.text),
                      date: _dateController.text,
                      interests: _interestsController.text.split(',').map((e) => e.trim()).toList(),
                    );
                    // Handle the created profile (e.g., save it or navigate)
                    Navigator.pop(context, profile);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);  }
}