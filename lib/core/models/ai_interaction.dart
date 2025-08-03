import 'package:equatable/equatable.dart';
import 'client.dart';
import 'ai_agent.dart';
import 'workout_session.dart';

/// AiInteraction model representing AI interactions in the Icon app
class AiInteraction extends Equatable {
  static const String tableName = 'ai_interactions';

  final String interactionId;
  final String clientId;
  final String aiAgentId;
  final String? sessionId;
  final String interactionType;
  final String? content;
  final DateTime timestamp;
  
  // Related models (optional, populated when joined)
  final Client? client;
  final AiAgent? aiAgent;
  final WorkoutSession? session;

  const AiInteraction({
    required this.interactionId,
    required this.clientId,
    required this.aiAgentId,
    this.sessionId,
    required this.interactionType,
    this.content,
    required this.timestamp,
    this.client,
    this.aiAgent,
    this.session,
  });

  /// Creates an AiInteraction from JSON data
  factory AiInteraction.fromJson(Map<String, dynamic> json) {
    return AiInteraction(
      interactionId: json['interaction_id'] as String,
      clientId: json['client_id'] as String,
      aiAgentId: json['ai_agent_id'] as String,
      sessionId: json['session_id'] as String?,
      interactionType: json['interaction_type'] as String,
      content: json['content'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      client: json['client'] != null 
          ? Client.fromJson(json['client'] as Map<String, dynamic>) 
          : null,
      aiAgent: json['ai_agent'] != null 
          ? AiAgent.fromJson(json['ai_agent'] as Map<String, dynamic>) 
          : null,
      session: json['session'] != null 
          ? WorkoutSession.fromJson(json['session'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts AiInteraction to JSON data
  Map<String, dynamic> toJson() {
    return {
      'interaction_id': interactionId,
      'client_id': clientId,
      'ai_agent_id': aiAgentId,
      'session_id': sessionId,
      'interaction_type': interactionType,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'client': client?.toJson(),
      'ai_agent': aiAgent?.toJson(),
      'session': session?.toJson(),
    };
  }

  /// Creates a copy of AiInteraction with updated fields
  AiInteraction copyWith({
    String? interactionId,
    String? clientId,
    String? aiAgentId,
    String? sessionId,
    String? interactionType,
    String? content,
    DateTime? timestamp,
    Client? client,
    AiAgent? aiAgent,
    WorkoutSession? session,
  }) {
    return AiInteraction(
      interactionId: interactionId ?? this.interactionId,
      clientId: clientId ?? this.clientId,
      aiAgentId: aiAgentId ?? this.aiAgentId,
      sessionId: sessionId ?? this.sessionId,
      interactionType: interactionType ?? this.interactionType,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      client: client ?? this.client,
      aiAgent: aiAgent ?? this.aiAgent,
      session: session ?? this.session,
    );
  }

  @override
  List<Object?> get props => [
    interactionId,
    clientId,
    aiAgentId,
    sessionId,
    interactionType,
    content,
    timestamp,
    client,
    aiAgent,
    session,
  ];

  @override
  String toString() {
    return 'AiInteraction(interactionId: $interactionId, clientId: $clientId, interactionType: $interactionType)';
  }
} 