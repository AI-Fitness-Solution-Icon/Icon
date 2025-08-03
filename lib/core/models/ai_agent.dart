import 'package:equatable/equatable.dart';
import 'coach.dart';

/// AI Agent model representing an AI agent in the Icon app
class AiAgent extends Equatable {
  static const String tableName = 'ai_agents';

  final String aiAgentId;
  final String coachId;
  final String agentName;
  final Map<String, dynamic>? brandingInfo;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Related models (optional, populated when joined)
  final Coach? coach;

  const AiAgent({
    required this.aiAgentId,
    required this.coachId,
    required this.agentName,
    this.brandingInfo,
    required this.createdAt,
    required this.updatedAt,
    this.coach,
  });

  /// Creates an AiAgent from JSON data
  factory AiAgent.fromJson(Map<String, dynamic> json) {
    return AiAgent(
      aiAgentId: json['ai_agent_id'] as String,
      coachId: json['coach_id'] as String,
      agentName: json['agent_name'] as String,
      brandingInfo: json['branding_info'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      coach: json['coach'] != null 
          ? Coach.fromJson(json['coach'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts AiAgent to JSON data
  Map<String, dynamic> toJson() {
    return {
      'ai_agent_id': aiAgentId,
      'coach_id': coachId,
      'agent_name': agentName,
      'branding_info': brandingInfo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'coach': coach?.toJson(),
    };
  }

  /// Creates a copy of AiAgent with updated fields
  AiAgent copyWith({
    String? aiAgentId,
    String? coachId,
    String? agentName,
    Map<String, dynamic>? brandingInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    Coach? coach,
  }) {
    return AiAgent(
      aiAgentId: aiAgentId ?? this.aiAgentId,
      coachId: coachId ?? this.coachId,
      agentName: agentName ?? this.agentName,
      brandingInfo: brandingInfo ?? this.brandingInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coach: coach ?? this.coach,
    );
  }

  @override
  List<Object?> get props => [
    aiAgentId,
    coachId,
    agentName,
    brandingInfo,
    createdAt,
    updatedAt,
    coach,
  ];

  @override
  String toString() {
    return 'AiAgent(aiAgentId: $aiAgentId, agentName: $agentName, coachId: $coachId)';
  }
} 