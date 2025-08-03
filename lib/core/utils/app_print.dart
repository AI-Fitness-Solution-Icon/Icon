import 'package:flutter/foundation.dart';

class AppPrint {
  static void printString(var message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static void printError(String message) {
    if (kDebugMode) {
      print('\x1B[31m$message\x1B[0m');
    }
  }

  static void printSuccess(String message) {
    if (kDebugMode) {
      print('\x1B[32m$message\x1B[0m');
    }
  }

  static void printWarning(String message) {
    if (kDebugMode) {
      print('\x1B[33m$message\x1B[0m');
    }
  }

  static void printInfo(String message) {
    if (kDebugMode) {
      print('\x1B[34m$message\x1B[0m');
    }
  }

  static void printPerformance(String operation, Duration duration) {
    if (kDebugMode) {
      final color = duration.inMilliseconds > 1000 ? '\x1B[31m' : 
                  duration.inMilliseconds > 500 ? '\x1B[33m' : '\x1B[32m';
      print('$color⏱️  $operation: ${duration.inMilliseconds}ms\x1B[0m');
    }
  }

  static void printStep(String step) {
    if (kDebugMode) {
      print('\x1B[36m📋 $step\x1B[0m');
    }
  }
} 