import 'package:blink_component/blink_component.dart';
import 'package:blink_component/models/capacity_indicator.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:incident_manager/src/controllers/incident_scope_controller.dart';

import '../../incident_manager.dart';
import '../controllers/create_incident_controller.dart';
import '../controllers/incident_details_controller.dart';
import '../state_management/capacity_indicators_state_management.dart';

late Dio incidentAppDio;
late String googleMapsApiWebKey;
late FlavorConfig? incidentsModuleFlavorConfig;
late AppBorders incidentsModuleAppBorders;
late AppIcons incidentsModuleAppIcons;
List<CapacityIndicatorModel> get capacityIndicators => CapacityIndicatorsGlobal.instance.current;

/// Configuration class for the Incident Manager package
class IncidentManagerConfig {
  static Dio? _appDio;
  static String _baseUrl = '';
  static FlavorConfig? flavorConfig;

  /// Initialize the package with required configuration
  static void initialize({
    required Dio appDio,
    required FlavorConfig flavorConfig,
    required String googleApiWebKey,
  }) async {
    _appDio = appDio;
    _baseUrl = flavorConfig.urlType;

    // Set global variables
    IncidentManagerConfig.flavorConfig = flavorConfig;
    incidentAppDio = appDio;
    googleMapsApiWebKey = googleApiWebKey;
    incidentsModuleFlavorConfig = flavorConfig;
    incidentsModuleAppBorders = flavorConfig.appBorders;
    incidentsModuleAppIcons = flavorConfig.appIcons;

    // Initialize incidents controllers
    await initializeControllers();

    print('IncidentManagerConfig capacityIndicators ${capacityIndicators}');
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

  /// Initialize controllers
  static Future<void> initializeControllers() async {
    await CapacityIndicatorsGlobal.instance.init();

    Get.put(IncidentsStatisticsAndListController());
    Get.put(IncidentDetailsController());
    Get.put(IncidentScopeController());
    Get.put(CreateIncidentController());
  }
}


