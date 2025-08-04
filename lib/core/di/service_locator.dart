import '../../features/trainer_onboarding/data/datasources/trainer_onboarding_local_datasource.dart';
import '../../features/trainer_onboarding/data/mappers/trainer_profile_mapper.dart';
import '../../features/trainer_onboarding/data/repositories/trainer_onboarding_repository_impl.dart';
import '../../features/trainer_onboarding/domain/repositories/trainer_onboarding_repository.dart';
import '../../features/trainer_onboarding/domain/usecases/create_trainer_account_usecase.dart';
import '../../features/trainer_onboarding/domain/usecases/save_trainer_profile_usecase.dart';
import '../../features/trainer_onboarding/bloc/trainer_onboarding_bloc.dart';
import '../services/supabase_service.dart';

/// Simple service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Lazy initialization of services
  TrainerOnboardingLocalDataSource? _localDataSource;
  TrainerProfileMapper? _mapper;
  TrainerOnboardingRepository? _repository;
  SaveTrainerProfileUseCase? _saveProfileUseCase;
  CreateTrainerAccountUseCase? _createAccountUseCase;
  TrainerOnboardingBloc? _bloc;

  /// Gets the local data source instance
  TrainerOnboardingLocalDataSource get localDataSource {
    _localDataSource ??= TrainerOnboardingLocalDataSource();
    return _localDataSource!;
  }

  /// Gets the mapper instance
  TrainerProfileMapper get mapper {
    _mapper ??= TrainerProfileMapper();
    return _mapper!;
  }

  /// Gets the repository instance
  TrainerOnboardingRepository get repository {
    _repository ??= TrainerOnboardingRepositoryImpl(
      localDataSource: localDataSource,
      mapper: mapper,
      supabaseService: SupabaseService.instance,
    );
    return _repository!;
  }

  /// Gets the save profile use case instance
  SaveTrainerProfileUseCase get saveProfileUseCase {
    _saveProfileUseCase ??= SaveTrainerProfileUseCase(repository);
    return _saveProfileUseCase!;
  }

  /// Gets the create account use case instance
  CreateTrainerAccountUseCase get createAccountUseCase {
    _createAccountUseCase ??= CreateTrainerAccountUseCase(repository);
    return _createAccountUseCase!;
  }

  /// Gets the trainer onboarding bloc instance
  TrainerOnboardingBloc get trainerOnboardingBloc {
    _bloc ??= TrainerOnboardingBloc(
      saveProfileUseCase: saveProfileUseCase,
      createAccountUseCase: createAccountUseCase,
      repository: repository,
    );
    return _bloc!;
  }

  /// Clears all instances (useful for testing)
  void clear() {
    _localDataSource = null;
    _mapper = null;
    _repository = null;
    _saveProfileUseCase = null;
    _createAccountUseCase = null;
    _bloc = null;
  }
} 