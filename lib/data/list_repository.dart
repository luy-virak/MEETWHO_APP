import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../model/meeting.dart';
import '../model/profile.dart';

List<Meeting> dummylistitem = [];
List<Profile> dummylistprofile = [];

Future<void> loadMeetings() async {
  final String response = await rootBundle.loadString('lib/data/local/meeting.json');
  final List<dynamic> data = json.decode(response);
  dummylistitem = data.map((json) => Meeting.fromJson(json)).toList();
}