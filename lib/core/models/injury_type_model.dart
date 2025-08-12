import 'package:flutter/foundation.dart';

/// Model representing an injury type
/// Used for categorizing different types of injuries in the fitness app
class InjuryTypeModel {
  final int id;
  final String name;

  const InjuryTypeModel({
    required this.id,
    required this.name,
  });

  /// Creates an InjuryTypeModel from a JSON map
  factory InjuryTypeModel.fromJson(Map<String, dynamic> json) {
    return InjuryTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  /// Converts the InjuryTypeModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// Prints the injury type information in a readable format
  void printInfo() {
    if (kDebugMode) {
      print('InjuryTypeModel:');
      print('  ID: $id');
      print('  Name: $name');
    }
  }

  /// Creates a copy of the InjuryTypeModel with updated values
  InjuryTypeModel copyWith({
    int? id,
    String? name,
  }) {
    return InjuryTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InjuryTypeModel &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'InjuryTypeModel(id: $id, name: $name)';
  }
}
