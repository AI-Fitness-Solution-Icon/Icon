import '../models/trainer_profile_model.dart';
import '../../domain/entities/trainer_profile.dart';

/// Mapper for converting between TrainerProfile entity and TrainerProfileModel
/// Handles the conversion between domain and data layers
class TrainerProfileMapper {
  /// Converts TrainerProfileModel to TrainerProfile entity
  TrainerProfile toEntity(TrainerProfileModel model) {
    return TrainerProfile(
      id: model.id,
      fullName: model.fullName,
      pronouns: model.pronouns,
      customPronouns: model.customPronouns,
      nickname: model.nickname,
      experienceLevel: model.experienceLevel,
      descriptiveWords: model.descriptiveWords,
      motivation: model.motivation,
      certifications: model.certifications,
      coachingExperience: model.coachingExperience,
      equipmentDetails: model.equipmentDetails,
      trainingPhilosophy: model.trainingPhilosophy,
      email: model.email,
      password: model.password,
    );
  }

  /// Converts TrainerProfile entity to TrainerProfileModel
  TrainerProfileModel toModel(TrainerProfile entity) {
    return TrainerProfileModel(
      id: entity.id,
      fullName: entity.fullName,
      pronouns: entity.pronouns,
      customPronouns: entity.customPronouns,
      nickname: entity.nickname,
      experienceLevel: entity.experienceLevel,
      descriptiveWords: entity.descriptiveWords,
      motivation: entity.motivation,
      certifications: entity.certifications,
      coachingExperience: entity.coachingExperience,
      equipmentDetails: entity.equipmentDetails,
      trainingPhilosophy: entity.trainingPhilosophy,
      email: entity.email,
      password: entity.password,
    );
  }
} 