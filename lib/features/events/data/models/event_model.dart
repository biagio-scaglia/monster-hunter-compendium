class EventModel {
  final int id;
  final String name;
  final String platform;
  final String? exclusive;
  final String type;
  final String expansion;
  final String? description;
  final String? requirements;
  final int? questRank;
  final String? successConditions;
  final String? startTimestamp;
  final String? endTimestamp;
  final Map<String, dynamic>? location;

  EventModel({
    required this.id,
    required this.name,
    required this.platform,
    this.exclusive,
    required this.type,
    required this.expansion,
    this.description,
    this.requirements,
    this.questRank,
    this.successConditions,
    this.startTimestamp,
    this.endTimestamp,
    this.location,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      platform: (json['platform'] as String?) ?? '',
      exclusive: json['exclusive'] as String?,
      type: (json['type'] as String?) ?? '',
      expansion: (json['expansion'] as String?) ?? '',
      description: json['description'] as String?,
      requirements: json['requirements'] as String?,
      questRank: json['questRank'] is int ? json['questRank'] as int : (json['questRank'] as num?)?.toInt(),
      successConditions: json['successConditions'] as String?,
      startTimestamp: json['startTimestamp'] as String?,
      endTimestamp: json['endTimestamp'] as String?,
      location: json['location'] as Map<String, dynamic>?,
    );
  }
}

