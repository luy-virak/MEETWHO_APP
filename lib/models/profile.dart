class Profile {
  final String name;
  final String time;
  final String date;
  final List<String> interests;

  Profile({
    required this.name,
    required this.time,
    required this.date,
    required this.interests,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: (json['name'] ?? '') as String,
      time: (json['time'] ?? '') as String,
      date: (json['date'] ?? '') as String,
      interests: (json['interests'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'time': time,
    'date': date,
    'interests': interests,
  };
}
