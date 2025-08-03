import 'package:equatable/equatable.dart';
import 'client.dart';

/// Gamification model representing gamification data in the Icon app
class Gamification extends Equatable {
  static const String tableName = 'gamification';

  final String gamificationId;
  final String clientId;
  final int points;
  final int level;
  
  // Related models (optional, populated when joined)
  final Client? client;

  const Gamification({
    required this.gamificationId,
    required this.clientId,
    this.points = 0,
    this.level = 1,
    this.client,
  });

  /// Creates a Gamification from JSON data
  factory Gamification.fromJson(Map<String, dynamic> json) {
    return Gamification(
      gamificationId: json['gamification_id'] as String,
      clientId: json['client_id'] as String,
      points: json['points'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      client: json['client'] != null 
          ? Client.fromJson(json['client'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts Gamification to JSON data
  Map<String, dynamic> toJson() {
    return {
      'gamification_id': gamificationId,
      'client_id': clientId,
      'points': points,
      'level': level,
      'client': client?.toJson(),
    };
  }

  /// Creates a copy of Gamification with updated fields
  Gamification copyWith({
    String? gamificationId,
    String? clientId,
    int? points,
    int? level,
    Client? client,
  }) {
    return Gamification(
      gamificationId: gamificationId ?? this.gamificationId,
      clientId: clientId ?? this.clientId,
      points: points ?? this.points,
      level: level ?? this.level,
      client: client ?? this.client,
    );
  }

  @override
  List<Object?> get props => [
    gamificationId,
    clientId,
    points,
    level,
    client,
  ];

  @override
  String toString() {
    return 'Gamification(gamificationId: $gamificationId, clientId: $clientId, points: $points, level: $level)';
  }
} 