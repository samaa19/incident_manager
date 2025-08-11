# Incident Manager

A Flutter package for managing incidents in event management applications. This package provides incident management components that can be easily integrated into any Flutter app.

## Features

- **Incidents Chart Widget**: A widget that displays incident statistics with pie chart visualization
- **Incidents Statistics and List Screen**: A complete screen for viewing incidents with statistics and filtering
- **Incident Models**: Complete data models for incidents, including severity levels and status
- **State Management**: Bloc/Cubit state management for incidents statistics
- **API Layer**: Self-contained API calls for incidents data
- **Customizable UI**: Uses `blink_component` for consistent theming and UI components

## Prerequisites

This package depends on `blink_component` for UI components, theming, and colors. Make sure you have access to the `blink_component` repository before using this package.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  incident_manager: ^0.0.1
  blink_component:
    git:
      url: git@github.com:blink-global/blink_component.git
      ref: incident-module-changes
```

Then run:
```bash
flutter pub get
```

## Setup

1. **Initialize the package** with your API base URL:

```dart
import 'package:incident_manager/incident_manager.dart';

void main() {
  // Initialize with your API base URL
  IncidentManagerConfig.initialize(
    baseUrl: 'https://your-api-base-url.com',
  );
  
  runApp(MyApp());
}
```

2. **Optional**: Provide a custom Dio instance if you need special configuration:

```dart
IncidentManagerConfig.initialize(
  baseUrl: 'https://your-api-base-url.com',
  customAppDio: YourCustomAppDio(),
);
```

## Usage

### Incidents Chart Widget

The `IncidentsChartWidget` displays incident statistics with a pie chart and uses internal state management:

```dart
import 'package:incident_manager/incident_manager.dart';
import 'package:blink_component/blink_component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => IncidentsStatisticsCubit()..getIncidentsStatistics(context),
        child: IncidentsChartWidget(
          palette: MyColorsPalette(), // From blink_component
          appIcons: AppIcons(), // From blink_component
          appBorders: AppBorders(), // From blink_component
          onTap: () {
            // Handle chart tap
            print('Chart tapped');
          },
          onSeeAllTap: () {
            // Navigate to incidents list
            Navigator.pushNamed(context, '/incidents');
          },
        ),
      ),
    );
  }
}
```

### Incidents Statistics and List Screen

The `IncidentsStatisticsAndListScreen` provides a complete incidents management interface:

```dart
import 'package:incident_manager/incident_manager.dart';
import 'package:blink_component/blink_component.dart';
import 'package:get/get.dart';

class MyIncidentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IncidentsStatisticsAndListController>(
      init: IncidentsStatisticsAndListController(),
      builder: (controller) {
        return IncidentsStatisticsAndListScreen(
          palette: MyColorsPalette(), // From blink_component
          appIcons: AppIcons(), // From blink_component
          appBorders: AppBorders(), // From blink_component
          assets: MyAssets(), // From blink_component
          isDark: false, // Your dark mode state
          onBackTap: () {
            // Handle back navigation
            Navigator.pop(context);
          },
          onIncidentTap: (incident) {
            // Handle incident tap
            print('Incident tapped: ${incident.title}');
          },
          onChangeStatus: (incidentId) {
            // Handle status change
            print('Status changed for incident: $incidentId');
          },
        );
      },
    );
  }
}
```

### Using State Management Directly

```dart
import 'package:incident_manager/incident_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncidentsStatisticsCubit(),
      child: BlocBuilder<IncidentsStatisticsCubit, IncidentsStatisticsState>(
        builder: (context, state) {
          if (state is IncidentsStatisticsLoading) {
            return CircularProgressIndicator();
          } else if (state is IncidentsStatisticsLoaded) {
            return Text('Total incidents: ${state.incidentsStatistics.incidents?.count ?? 0}');
          }
          return Container();
        },
      ),
    );
  }
}
```

### Using Models and Enums

```dart
import 'package:incident_manager/incident_manager.dart';

// Create an incident
final incident = IncidentModel(
  id: 1,
  title: 'Technical Issue',
  description: 'Audio system not working',
  severity: IncidentSeverity.moderate,
  status: IncidentStatus.open,
);

// Use enums
final severity = IncidentSeverity.severe;
print(severity.getName); // "Severe"
```

### Direct API Usage

```dart
import 'package:incident_manager/incident_manager.dart';

// Use the API repository directly
final repository = IncidentsApiRepository();
final result = await repository.getIncidentsStatistics();

result.fold(
  (error) => print('Error: $error'),
  (statistics) => print('Statistics: $statistics'),
);
```

## Dependencies

This package depends on:

- `blink_component`: For UI components, themes, and colors
- `flutter_bloc`: For state management
- `dio`: For HTTP requests
- `retrofit`: For API client generation
- `dartz`: For functional programming utilities
- `get`: For internationalization and utilities
- `fl_chart`: For pie chart visualization

## API Endpoints

The package expects the following API endpoints:

- `GET /api/home/statistics` - Returns incident statistics data
- `GET /api/home/incidents` - Returns paginated incidents list

The response should match the `OrganizerStatisticsModel` structure from `blink_component`.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
