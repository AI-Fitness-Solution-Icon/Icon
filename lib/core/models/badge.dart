import 'package:equatable/equatable.dart';

/// Badge model representing badges in the Icon app
class Badge extends Equatable {
  static const String tableName = 'badges';

  final String badgeId;
  final String name;
  final String? description;
  final String? iconUrl;

  const Badge({
    required this.badgeId,
    required this.name,
    this.description,
    this.iconUrl,
  });

  /// Creates a Badge from JSON data
  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      badgeId: json['badge_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
    );
  }

  /// Converts Badge to JSON data
  Map<String, dynamic> toJson() {
    return {
      'badge_id': badgeId,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
    };
  }

  /// Creates a copy of Badge with updated fields
  Badge copyWith({
    String? badgeId,
    String? name,
    String? description,
    String? iconUrl,
  }) {
    return Badge(
      badgeId: badgeId ?? this.badgeId,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  @override
  List<Object?> get props => [
    badgeId,
    name,
    description,
    iconUrl,
  ];

  @override
  String toString() {
    return 'Badge(badgeId: $badgeId, name: $name)';
  }
} 