import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:meetwho/model/profile.dart';

final List<Profile> dummylistitem = [];

const String _fileName = 'meetwho_profiles.json';

Future<File> _getFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$_fileName');
}

Future<void> loadProfiles() async {
  try {
    final file = await _getFile();
    if (!await file.exists()) return;

    final content = await file.readAsString();
    if (content.trim().isEmpty) return;

    final decoded = jsonDecode(content) as List<dynamic>;
    final loaded = decoded
        .map((e) => Profile.fromJson(e as Map<String, dynamic>))
        .toList();

    dummylistitem
      ..clear()
      ..addAll(loaded);
  } catch (_) {
    // If file is broken / invalid JSON, keep empty list (no crash)
  }
}

Future<void> saveProfiles() async {
  final file = await _getFile();
  final data = dummylistitem.map((p) => p.toJson()).toList();
  await file.writeAsString(jsonEncode(data), flush: true);
}

Future<void> addProfile(Profile p) async {
  dummylistitem.add(p);
  await saveProfiles();
}

Future<void> removeProfileAt(int index) async {
  if (index < 0 || index >= dummylistitem.length) return;
  dummylistitem.removeAt(index);
  await saveProfiles();
}

Future<void> updateProfileAt(int index, Profile p) async {
  if (index < 0 || index >= dummylistitem.length) return;
  dummylistitem[index] = p;
  await saveProfiles();
}
