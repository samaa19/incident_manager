import 'package:blink_component/blink_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incident_manager/incident_manager.dart';

class IncidentCategoryWidget extends StatelessWidget {
  final bool isDark;
  final MyColorsPalette palette;
  const IncidentCategoryWidget({super.key, required this.palette, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncidentsStatisticsCubit, IncidentsStatisticsState>(
      builder: (context, state) {
        if(state is IncidentsStatisticsLoaded) {
          final int totalCount = state.incidentsStatistics.incidents.count;
          return CategoryStatisticsGridWidget(
            palette: palette,
            borderRadiusXLarge: incidentsModuleAppBorders.xLarge,
            icon: AppIcons(fontFamily: ThemeIconData.getFilledIcon(incidentsModuleAppIcons.fontFamily),).lightEmergencyOnIcon,
            title: incidentsTextKey,
            totalNumber: totalCount,
            nowNumber: 0,
            appIcons: incidentsModuleAppIcons,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IncidentsStatisticsAndListScreen(
                  palette: palette,
                  isDark: isDark,
                ),
              ),
            ),
          );

        }
        return Container();
      }
    );
  }
}
