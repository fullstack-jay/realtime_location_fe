import 'package:hive/hive.dart';

enum Role { viewer, creator, member }

@HiveType(typeId: 1)
class Movement {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String creator;

  @HiveField(4)
  int km;

  @HiveField(5)
  List<String> members;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  Role role;

  Movement({
    required this.id,
    required this.title,
    required this.description,
    required this.members,
    required this.creator,
    required this.createdAt,
    required this.km,
    required this.role,
  });

  factory Movement.fromJSON(dynamic json) {
    return Movement(
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      members: List<String>.from(json["actors"]),
      creator: json["creator"],
      createdAt: DateTime.parse(json["createdAt"]),
      km: 17,
      role: Role.member,
    );
  }
}
