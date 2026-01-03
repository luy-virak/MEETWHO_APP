import 'package:flutter/material.dart';
import 'package:meetwho/model/profile.dart';

class Edit extends StatefulWidget {
  const Edit({super.key, required this.existingProfile});

  final Profile existingProfile;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _timeController;
  late final TextEditingController _dateController;
  late final TextEditingController _interestsController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.existingProfile.name);
    _timeController = TextEditingController(text: widget.existingProfile.time);
    _dateController = TextEditingController(text: widget.existingProfile.date);
    _interestsController = TextEditingController(
      text: widget.existingProfile.interests.isEmpty
          ? ''
          : widget.existingProfile.interests.first,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  bool _isSelectedDateTimeValid() {
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

    if (selectedDay == today) {
      return !selected.isBefore(now);
    }
    return true;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime initial = today;
    final currentText = _dateController.text.trim();
    final parts = currentText.split('-');
    if (parts.length == 3) {
      final y = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2]);
      if (y != null && m != null && d != null) {
        initial = DateTime(y, m, d);
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selected time is in the past. Pick a new time.'),
          ),
        );
      }
    }
  }

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
        const SnackBar(
          content: Text('Selected time is in the past. Pick a new time.'),
        ),
      );
    }
  }

  void _onCancel() {
    Navigator.pop<Profile>(context);
  }

  void _onUpdate() {
    if (_formKey.currentState!.validate()) {
      final purpose = _interestsController.text.trim();

      final updated = Profile(
        name: _nameController.text.trim(),
        time: _timeController.text.trim(),
        date: _dateController.text.trim(),
        interests: purpose.isEmpty
            ? <String>[]
            : <String>[purpose], // ✅ only one purpose
      );

      Navigator.pop<Profile>(context, updated);
    }
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
            const _HeaderWave(title: "Edit Meeting"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
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
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
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
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Please select a date'
                              : null,
                        ),
                        TextFormField(
                          controller: _interestsController,
                          decoration: const InputDecoration(
                            labelText:
                                'Purpose of the meeting (Only one Purpose is allowed)',
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Please enter a purpose'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _onCancel,
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 30),
                            ElevatedButton(
                              onPressed: _onUpdate,
                              child: const Text('Update'),
                            ),
                          ],
                        ),
                      ],
                    ),
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
  const _HeaderWave({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    const r = 20.0;

    return Container(
      height: 125,
      width: double.infinity,
      margin: EdgeInsets.zero,
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
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const Text(
              "Update your meeting info",
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
