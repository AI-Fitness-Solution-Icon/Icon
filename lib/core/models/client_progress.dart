import 'package:equatable/equatable.dart';
import 'client.dart';

/// ClientProgress model representing client progress tracking in the Icon app
class ClientProgress extends Equatable {
  static const String tableName = 'client_progress';

  final String progressId;
  final String clientId;
  final DateTime date;
  final double? weight;
  final double? bodyFatPercentage;
  final double? muscleMass;
  
  // Related models (optional, populated when joined)
  final Client? client;

  const ClientProgress({
    required this.progressId,
    required this.clientId,
    required this.date,
    this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    this.client,
  });

  /// Creates a ClientProgress from JSON data
  factory ClientProgress.fromJson(Map<String, dynamic> json) {
    return ClientProgress(
      progressId: json['progress_id'] as String,
      clientId: json['client_id'] as String,
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num?)?.toDouble(),
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      muscleMass: (json['muscle_mass'] as num?)?.toDouble(),
      client: json['client'] != null 
          ? Client.fromJson(json['client'] as Map<String, dynamic>) 
          : null,
    );
  }

  /// Converts ClientProgress to JSON data
  Map<String, dynamic> toJson() {
    return {
      'progress_id': progressId,
      'client_id': clientId,
      'date': date.toIso8601String(),
      'weight': weight,
      'body_fat_percentage': bodyFatPercentage,
      'muscle_mass': muscleMass,
      'client': client?.toJson(),
    };
  }

  /// Creates a copy of ClientProgress with updated fields
  ClientProgress copyWith({
    String? progressId,
    String? clientId,
    DateTime? date,
    double? weight,
    double? bodyFatPercentage,
    double? muscleMass,
    Client? client,
  }) {
    return ClientProgress(
      progressId: progressId ?? this.progressId,
      clientId: clientId ?? this.clientId,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      muscleMass: muscleMass ?? this.muscleMass,
      client: client ?? this.client,
    );
  }

  @override
  List<Object?> get props => [
    progressId,
    clientId,
    date,
    weight,
    bodyFatPercentage,
    muscleMass,
    client,
  ];

  @override
  String toString() {
    return 'ClientProgress(progressId: $progressId, clientId: $clientId, date: $date)';
  }
} 