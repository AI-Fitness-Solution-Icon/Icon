import 'package:equatable/equatable.dart';
import 'client.dart';
import 'badge.dart';

/// ClientBadge model representing the relationship between clients and badges
class ClientBadge extends Equatable {
  static const String tableName = 'client_badges';

  final String clientBadgeId;
  final String clientId;
  final String badgeId;
  final DateTime earnedAt;
  
  // Related models (optional, populated when joined)
  final Client? client;
  final Badge? badge;

  const ClientBadge({
    required this.clientBadgeId,
    required this.clientId,
    required this.badgeId,
    required this.earnedAt,
    this.client,
    this.badge,
  });

  /// Creates a ClientBadge from JSON data
  factory ClientBadge.fromJson(Map<String, dynamic> json) {
    return ClientBadge(
      clientBadgeId: json['client_badge_id'] as String,
      clientId: json['client_id'] as String,
      badgeId: json['badge_id'] as String,
      earnedAt: DateTime.parse(json['earned_at'] as String),
      client: json['client'] != null 
          ? Client.fromJson(json['client'] as Map<String, dynamic>) 
          : null,
      badge: json['badge'] != null 
          ? Badge.fromJson(json['badge'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts ClientBadge to JSON data
  Map<String, dynamic> toJson() {
    return {
      'client_badge_id': clientBadgeId,
      'client_id': clientId,
      'badge_id': badgeId,
      'earned_at': earnedAt.toIso8601String(),
      'client': client?.toJson(),
      'badge': badge?.toJson(),
    };
  }

  /// Creates a copy of ClientBadge with updated fields
  ClientBadge copyWith({
    String? clientBadgeId,
    String? clientId,
    String? badgeId,
    DateTime? earnedAt,
    Client? client,
    Badge? badge,
  }) {
    return ClientBadge(
      clientBadgeId: clientBadgeId ?? this.clientBadgeId,
      clientId: clientId ?? this.clientId,
      badgeId: badgeId ?? this.badgeId,
      earnedAt: earnedAt ?? this.earnedAt,
      client: client ?? this.client,
      badge: badge ?? this.badge,
    );
  }

  @override
  List<Object?> get props => [
    clientBadgeId,
    clientId,
    badgeId,
    earnedAt,
    client,
    badge,
  ];

  @override
  String toString() {
    return 'ClientBadge(clientBadgeId: $clientBadgeId, clientId: $clientId, badgeId: $badgeId)';
  }
} 