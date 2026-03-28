import 'package:flutter/material.dart';
import 'package:meetwho/models/profile.dart';

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
  
  String? _selectedPurpose;
  final List<String> _purposes = ['Work', 'Project', 'Personal', 'Team', 'School', 'Other'];

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

    final hh = picked.hour.toString().padLeft(2, '0');
    final mm = picked.minute.toString().padLeft(2, '0');
    _timeController.text = '$hh:$mm';

    if (!_isSelectedDateTimeValid()) {
      _timeController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot pick a time in the past.')),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      final yyyy = picked.year.toString().padLeft(4, '0');
      final mm = picked.month.toString().padLeft(2, '0');
      final dd = picked.day.toString().padLeft(2, '0');
      _dateController.text = '$yyyy-$mm-$dd';

      if (_timeController.text.isNotEmpty && !_isSelectedDateTimeValid()) {
        _timeController.clear();
      }
    }
  }

  bool _isSelectedDateTimeValid() {
    final dateStr = _dateController.text.trim();
    final timeStr = _timeController.text.trim();

    if (dateStr.isEmpty || timeStr.isEmpty) return true;

    final partsD = dateStr.split('-');
    final partsT = timeStr.split(':');
    
    final y = int.tryParse(partsD[0]) ?? 0;
    final m = int.tryParse(partsD[1]) ?? 0;
    final d = int.tryParse(partsD[2]) ?? 0;
    final hh = int.tryParse(partsT[0]) ?? 0;
    final mm = int.tryParse(partsT[1]) ?? 0;

    final selected = DateTime(y, m, d, hh, mm);
    final now = DateTime.now();
    
    return !selected.isBefore(now);
  }

  void onAdd() {
    if (_formKey.currentState!.validate()) {
      Profile newProfile = Profile(
        name: _nameController.text.trim(),
        time: _timeController.text.trim(),
        date: _dateController.text.trim(),
        interests: [_selectedPurpose!],
      );
      Navigator.pop<Profile>(context, newProfile);
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const _HeaderWave(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputStyle('Person Name', Icons.person),
                      validator: (value) => (value == null || value.isEmpty) ? 'Enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: _inputStyle('Select Date', Icons.calendar_today),
                      onTap: _pickDate,
                      validator: (value) => (value == null || value.isEmpty) ? 'Select a date' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      decoration: _inputStyle('Select Time', Icons.access_time),
                      onTap: _pickTime,
                      validator: (value) => (value == null || value.isEmpty) ? 'Select a time' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedPurpose,
                      decoration: _inputStyle('Meeting Purpose', Icons.category),
                      items: _purposes.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                      onChanged: (val) => setState(() => _selectedPurpose = val),
                      validator: (value) => (value == null) ? 'Select a purpose' : null,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onAdd,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Create Meeting', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
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
    );
  }
}

class _HeaderWave extends StatelessWidget {
  const _HeaderWave();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        gradient: LinearGradient(
          colors: [Color(0xFF2E7AF6), Color(0xFF45ABF0)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text("Create Meeting", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("Schedule a new session", style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
