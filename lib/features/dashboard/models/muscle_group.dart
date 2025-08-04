import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Model representing a muscle group
class MuscleGroup extends Equatable {
  final String id;
  final String name;
  final BodyView view;
  final Offset position;
  final Size size;
  final Color color;
  final double intensity; // 0.0 to 1.0

  const MuscleGroup({
    required this.id,
    required this.name,
    required this.view,
    required this.position,
    required this.size,
    required this.color,
    this.intensity = 1.0,
  });

  /// Create from JSON
  factory MuscleGroup.fromJson(Map<String, dynamic> json) {
    return MuscleGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      view: BodyView.values.firstWhere(
        (e) => e.toString() == 'BodyView.${json['view']}',
        orElse: () => BodyView.front,
      ),
      position: Offset(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
      size: Size(
        (json['size']['width'] as num).toDouble(),
        (json['size']['height'] as num).toDouble(),
      ),
      color: Color((json['color'] as num).toInt()),
      intensity: (json['intensity'] as num?)?.toDouble() ?? 1.0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'view': view.toString().split('.').last,
      'position': {
        'x': position.dx,
        'y': position.dy,
      },
      'size': {
        'width': size.width,
        'height': size.height,
      },
      'color': color.toARGB32(),
      'intensity': intensity,
    };
  }

  /// Create a copy with updated values
  MuscleGroup copyWith({
    String? id,
    String? name,
    BodyView? view,
    Offset? position,
    Size? size,
    Color? color,
    double? intensity,
  }) {
    return MuscleGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      view: view ?? this.view,
      position: position ?? this.position,
      size: size ?? this.size,
      color: color ?? this.color,
      intensity: intensity ?? this.intensity,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    view,
    position,
    size,
    color,
    intensity,
  ];
}

/// Body view types
enum BodyView {
  front,
  back,
  internal,
} 