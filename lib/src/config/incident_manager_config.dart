import 'package:dio/dio.dart';

late Dio incidentAppDio;

/// Configuration class for the Incident Manager package
class IncidentManagerConfig {
  static Dio? _appDio;
  static String _baseUrl = '';

  /// Initialize the package with required configuration
  static void initialize({
    required Dio appDio,
    required String baseUrl,
  }) {
    _appDio = appDio;
    _baseUrl = baseUrl;
    
    // Set the global appDio instance
    incidentAppDio = appDio;
  }

  /// Get the configured AppDio instance
  static Dio get appDio {
    if (_appDio == null) {
      throw Exception('IncidentManagerConfig not initialized. Call initialize() first.');
    }
    return _appDio!;
  }

  /// Get the configured base URL
  static String get baseUrl {
    if (_baseUrl.isEmpty) {
      throw Exception('IncidentManagerConfig not initialized. Call initialize() first.');
    }
    return _baseUrl;
  }

  /// Check if the package is initialized
  static bool get isInitialized => _appDio != null && _baseUrl.isNotEmpty;
} 