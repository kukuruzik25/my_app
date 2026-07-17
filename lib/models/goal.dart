class Goal {

  String id;
  String title;
  DateTime targetDate;
  DateTime createdDate;

   Goal({
    required this.id,
    required this.title,
    required this.targetDate,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'targetDate': targetDate.toIso8601String(),
    'createdDate': createdDate.toIso8601String(),
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'],
    title: json['title'],
    targetDate: DateTime.parse(json['targetDate']),
    createdDate: DateTime.parse(json['createdDate']),
  );
}