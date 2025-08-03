/// AI response model representing responses from the AI coach
class AIResponse {
  final String id;
  final String text;
  final String? voiceUrl;
  final AIResponseType type;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final String userId;

  const AIResponse({
    required this.id,
    required this.text,
    this.voiceUrl,
    this.type = AIResponseType.text,
    this.metadata,
    required this.createdAt,
    required this.userId,
  });

  /// Creates an AIResponse from JSON data
  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      id: json['id'] as String,
      text: json['text'] as String,
      voiceUrl: json['voice_url'] as String?,
      type: AIResponseType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => AIResponseType.text,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String,
    );
  }

  /// Converts AIResponse to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'voice_url': voiceUrl,
      'type': type.name,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }

  /// Creates a copy of AIResponse with updated fields
  AIResponse copyWith({
    String? id,
    String? text,
    String? voiceUrl,
    AIResponseType? type,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    String? userId,
  }) {
    return AIResponse(
      id: id ?? this.id,
      text: text ?? this.text,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AIResponse && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AIResponse(id: $id, type: $type, text: ${text.length > 50 ? '${text.substring(0, 50)}...' : text})';
  }
}

/// AI response types
enum AIResponseType {
  text,
  voice,
  workout,
  nutrition,
  motivation,
} 