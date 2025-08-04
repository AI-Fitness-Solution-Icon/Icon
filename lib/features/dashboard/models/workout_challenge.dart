import 'package:equatable/equatable.dart';

/// Model representing a workout challenge
class WorkoutChallenge extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String challengeType;
  final String description;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isAccepted;
  final bool isDismissed;

  const WorkoutChallenge({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.challengeType,
    required this.description,
    required this.createdAt,
    required this.expiresAt,
    this.isAccepted = false,
    this.isDismissed = false,
  });

  /// Check if challenge is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if challenge is active
  bool get isActive => !isAccepted && !isDismissed && !isExpired;

  /// Create from JSON
  factory WorkoutChallenge.fromJson(Map<String, dynamic> json) {
    return WorkoutChallenge(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      challengeType: json['challenge_type'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      isAccepted: json['is_accepted'] as bool? ?? false,
      isDismissed: json['is_dismissed'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'challenge_type': challengeType,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_accepted': isAccepted,
      'is_dismissed': isDismissed,
    };
  }

  /// Create a copy with updated values
  WorkoutChallenge copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? challengeType,
    String? description,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isAccepted,
    bool? isDismissed,
  }) {
    return WorkoutChallenge(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      challengeType: challengeType ?? this.challengeType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isAccepted: isAccepted ?? this.isAccepted,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }

  @override
  List<Object?> get props => [
    id,
    senderId,
    senderName,
    challengeType,
    description,
    createdAt,
    expiresAt,
    isAccepted,
    isDismissed,
  ];
} 