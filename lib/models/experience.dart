import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    required this.title,
    required this.description,
    required this.category,
    required this.stage,
    this.thumbnail,
    this.endedAt,
    this.id,
    this.startedAt,
    this.isOngoing = true,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  final String title, description, category, stage;
  final String? thumbnail;
  final DateTime? endedAt;
  @JsonKey(includeToJson: false)
  final String? id;
  @JsonKey(includeToJson: false)
  final DateTime? startedAt;
  @JsonKey(includeToJson: false)
  final bool isOngoing;
  @JsonKey(includeToJson: false)
  final int starCount;
  @JsonKey(includeToJson: false)
  final bool isStarred;
  @JsonKey(includeToJson: false)
  final String starredByNames;

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);
  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
