import 'package:flutter/material.dart';
import 'package:meetwho/model/profile.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  Future<void> _pickTime() async {
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date first')),
      );
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    // Put chosen time into controller (HH:mm)
    final hh = picked.hour.toString().padLeft(2, '0');
    final mm = picked.minute.toString().padLeft(2, '0');
    _timeController.text = '$hh:$mm';

    // Validate: if date is today, time must be >= now
    if (!_isSelectedDateTimeValid()) {
      _timeController.clear();
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today, // ✅ block yesterday
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      final yyyy = picked.year.toString().padLeft(4, '0');
      final mm = picked.month.toString().padLeft(2, '0');
      final dd = picked.day.toString().padLeft(2, '0');
      _dateController.text = '$yyyy-$mm-$dd';

      // If date changed, and time is now invalid, clear time
      if (_timeController.text.isNotEmpty && !_isSelectedDateTimeValid()) {
        _timeController.clear();
      }
    }
  }

  bool _isSelectedDateTimeValid() {
    // date: YYYY-MM-DD
    final dateStr = _dateController.text.trim();
    final timeStr = _timeController.text.trim();

    if (dateStr.isEmpty || timeStr.isEmpty) return true;

    final partsD = dateStr.split('-');
    final partsT = timeStr.split(':');
    if (partsD.length != 3 || partsT.length != 2) return true;

    final y = int.tryParse(partsD[0]) ?? 0;
    final m = int.tryParse(partsD[1]) ?? 0;
    final d = int.tryParse(partsD[2]) ?? 0;

    final hh = int.tryParse(partsT[0]) ?? 0;
    final mm = int.tryParse(partsT[1]) ?? 0;

    final selected = DateTime(y, m, d, hh, mm);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selected.year, selected.month, selected.day);

    // if selected day is today, must be >= now
    if (selectedDay == today) {
      return !selected.isBefore(now);
    }

    // future days are always valid
    return true;
  }

  void onAdd() {
    if (_formKey.currentState!.validate()) {
      // Create and return the new profile
      Profile newProfile = Profile(
        name: _nameController.text,
        time: _timeController.text,
        date: _dateController.text,
        interests: _purposeController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
      );
      Navigator.pop<Profile>(context, newProfile);
    }
  }

  void onCancel() {
    Navigator.pop<Profile>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 46, 122, 246),
              Color(0xFF45ABF0),
              Color(0xFFE8F2FF),
            ],
          ),
        ),
        child: Column(
          children: [
            const _HeaderWave(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter your name'
                            : null,
                      ),

                      TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          hintText: 'Select time',
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        onTap: _pickTime,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please select a time'
                            : null,
                      ),

                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          hintText: 'Select date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: _pickDate,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please select a date'
                            : null,
                      ),

                      TextFormField(
                        controller: _purposeController,
                        decoration: const InputDecoration(
                          labelText:
                              'Purpose of the meeting (Only one Purpose is allowed)',
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter at least one interest'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: onCancel,
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: onAdd,
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderWave extends StatelessWidget {
  const _HeaderWave();

  @override
  Widget build(BuildContext context) {
    const r = 20.0;

    return Container(
      height: 125,
      width: double.infinity, // fill full width
      margin:
          EdgeInsets.zero, // no gap on sides// important so shadow has space
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF2E7AF6), Color(0xFF45ABF0), Color(0xFF4DD7FF)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 50),
            Text(
              "Create Your Meeting",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              "Who are you meeting today?",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(179, 29, 28, 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
