/// Input validation utilities for the Icon app
class Validators {
  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    return null;
  }

  /// Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Validate age
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Age is optional
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    
    if (age < 13 || age > 120) {
      return 'Age must be between 13 and 120';
    }
    
    return null;
  }

  /// Validate weight
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Weight is optional
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid weight';
    }
    
    if (weight < 20 || weight > 500) {
      return 'Weight must be between 20 and 500 kg';
    }
    
    return null;
  }

  /// Validate height
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Height is optional
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid height';
    }
    
    if (height < 100 || height > 250) {
      return 'Height must be between 100 and 250 cm';
    }
    
    return null;
  }

  /// Validate workout title
  static String? validateWorkoutTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Workout title is required';
    }
    
    if (value.length < 3) {
      return 'Workout title must be at least 3 characters long';
    }
    
    if (value.length > 100) {
      return 'Workout title must be less than 100 characters';
    }
    
    return null;
  }

  /// Validate exercise name
  static String? validateExerciseName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Exercise name is required';
    }
    
    if (value.length < 2) {
      return 'Exercise name must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return 'Exercise name must be less than 50 characters';
    }
    
    return null;
  }

  /// Validate sets count
  static String? validateSets(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of sets is required';
    }
    
    final sets = int.tryParse(value);
    if (sets == null) {
      return 'Please enter a valid number of sets';
    }
    
    if (sets < 1 || sets > 20) {
      return 'Sets must be between 1 and 20';
    }
    
    return null;
  }

  /// Validate reps count
  static String? validateReps(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of reps is required';
    }
    
    final reps = int.tryParse(value);
    if (reps == null) {
      return 'Please enter a valid number of reps';
    }
    
    if (reps < 1 || reps > 100) {
      return 'Reps must be between 1 and 100';
    }
    
    return null;
  }

  /// Validate rest time
  static String? validateRestTime(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Rest time is optional
    }
    
    final restTime = int.tryParse(value);
    if (restTime == null) {
      return 'Please enter a valid rest time';
    }
    
    if (restTime < 0 || restTime > 600) {
      return 'Rest time must be between 0 and 600 seconds';
    }
    
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    
    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    
    return null;
  }

  /// Validate numeric range
  static String? validateNumericRange(String? value, double min, double max, String fieldName) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid $fieldName';
    }
    
    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }
    
    return null;
  }
} 