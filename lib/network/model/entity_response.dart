import 'dart:convert';

class EntityResponse {
  final List<Entity> entity;

  EntityResponse({required this.entity});

  factory EntityResponse.fromJson(Map<String, dynamic> json) {
    return EntityResponse(
      entity: (json['EntityList'] as List<dynamic>? ?? [])
          .map((e) => Entity.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'EntityList': entity.map((e) => e.toJson()).toList()};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Entity {
  final String? entityId;
  final String? entityName;
  final String? displayInAssociation;
  final String? displayInVoting;

  Entity({
    this.entityId,
    this.entityName,
    this.displayInAssociation,
    this.displayInVoting,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      entityId: json['entity_id']?.toString() ?? '',
      entityName: json['entity_name']?.toString() ?? '',
      displayInAssociation: json['display_in_association']?.toString() ?? '',
      displayInVoting: json['display_in_voting']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entity_id': entityId,
      'entity_name': entityName,
      'display_in_association': displayInAssociation,
      'display_in_voting': displayInVoting,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
