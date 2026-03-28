import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetwho/models/profile.dart';

class ListRepository extends ChangeNotifier {
  final List<Profile> _profiles = [];
  List<Profile> get profiles => List.unmodifiable(_profiles);

  static const String _key = 'meetwho_profiles';

  Future<void> loadProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final content = prefs.getString(_key);
      
      if (content == null || content.trim().isEmpty) return;

      final decoded = jsonDecode(content) as List<dynamic>;
      final loaded = decoded
          .map((e) => Profile.fromJson(e as Map<String, dynamic>))
          .toList();

      _profiles.clear();
      _profiles.addAll(loaded);
      notifyListeners();
    } catch (_) {
      // Handle error
    }
  }

  Future<void> saveProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _profiles.map((p) => p.toJson()).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<void> addProfile(Profile p) async {
    _profiles.add(p);
    notifyListeners();
    await saveProfiles();
  }

  Future<void> removeProfileAt(int index) async {
    if (index < 0 || index >= _profiles.length) return;
    _profiles.removeAt(index);
    notifyListeners();
    await saveProfiles();
  }

  Future<void> updateProfileAt(int index, Profile p) async {
    if (index < 0 || index >= _profiles.length) return;
    _profiles[index] = p;
    notifyListeners();
    await saveProfiles();
  }
}
