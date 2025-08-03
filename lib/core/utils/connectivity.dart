import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity utility for checking network status
class ConnectivityService {
  static ConnectivityService? _instance;
  late final Connectivity _connectivity;

  ConnectivityService._() {
    _connectivity = Connectivity();
  }

  /// Singleton instance of ConnectivityService
  static ConnectivityService get instance {
    _instance ??= ConnectivityService._();
    return _instance!;
  }

  /// Get the connectivity instance
  Connectivity get connectivity => _connectivity;

  /// Check if device is connected to the internet
  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  /// Check if device is connected to WiFi
  Future<bool> isConnectedToWifi() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.wifi);
  }

  /// Check if device is connected to mobile data
  Future<bool> isConnectedToMobile() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile);
  }

  /// Get connection type as string
  Future<String> getConnectionType() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return 'Mobile';
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth';
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      return 'Other';
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      return 'None';
    } else {
      return 'Unknown';
    }
  }

  /// Check if device has a stable connection
  Future<bool> hasStableConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.wifi) || 
           connectivityResult.contains(ConnectivityResult.mobile);
  }

  /// Check if connection is suitable for video streaming
  Future<bool> isSuitableForVideoStreaming() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // WiFi and mobile are generally suitable for video streaming
    return connectivityResult.contains(ConnectivityResult.wifi) || 
           connectivityResult.contains(ConnectivityResult.mobile);
  }

  /// Check if connection is suitable for voice calls
  Future<bool> isSuitableForVoiceCalls() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    // WiFi and mobile are suitable for voice calls
    return connectivityResult.contains(ConnectivityResult.wifi) || 
           connectivityResult.contains(ConnectivityResult.mobile);
  }

  /// Get connection quality indicator
  Future<ConnectionQuality> getConnectionQuality() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return ConnectionQuality.excellent;
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return ConnectionQuality.good;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return ConnectionQuality.excellent;
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return ConnectionQuality.good;
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      return ConnectionQuality.poor;
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      return ConnectionQuality.unknown;
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      return ConnectionQuality.none;
    } else {
      return ConnectionQuality.unknown;
    }
  }
}

/// Connection quality enum
enum ConnectionQuality {
  none,
  poor,
  fair,
  good,
  excellent,
  unknown,
}

/// Extension on ConnectionQuality for user-friendly descriptions
extension ConnectionQualityExtension on ConnectionQuality {
  String get description {
    switch (this) {
      case ConnectionQuality.none:
        return 'No Connection';
      case ConnectionQuality.poor:
        return 'Poor Connection';
      case ConnectionQuality.fair:
        return 'Fair Connection';
      case ConnectionQuality.good:
        return 'Good Connection';
      case ConnectionQuality.excellent:
        return 'Excellent Connection';
      case ConnectionQuality.unknown:
        return 'Unknown Connection';
    }
  }

  bool get isSuitableForApp {
    switch (this) {
      case ConnectionQuality.none:
      case ConnectionQuality.poor:
      case ConnectionQuality.unknown:
        return false;
      case ConnectionQuality.fair:
      case ConnectionQuality.good:
      case ConnectionQuality.excellent:
        return true;
    }
  }
} 