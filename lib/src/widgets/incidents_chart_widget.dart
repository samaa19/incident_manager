/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'package:blink_component/blink_component.dart';
import 'package:blink_component/widgets/network_feature_widgets/common_widgets/title_with_see_all_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../incident_manager.dart';

class IncidentsDetailsChartWidget extends StatefulWidget {
  final MyColorsPalette palette;
  final bool isDark;
  final VoidCallback? onSeeAllTap;

  const IncidentsDetailsChartWidget({
    super.key,
    required this.palette,
    required this.isDark,
    this.onSeeAllTap,
  });

  @override
  State<IncidentsDetailsChartWidget> createState() => _IncidentsDetailsChartWidgetState();
}

class _IncidentsDetailsChartWidgetState
    extends State<IncidentsDetailsChartWidget> {
  final int maxVisibleCount = 999;

  int moderateCount = 0;
  int severCount = 0;
  int lowCount = 0;
  int allCount = 0;

  String _getTotalCount() {
    int total = severCount + moderateCount + lowCount;

    if (total > maxVisibleCount) {
      return "$maxVisibleCount+";
    } else {
      return total.toString();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final appIcons = incidentsModuleAppIcons;
    final appBorders = incidentsModuleAppBorders;

    return BlocProvider(
      create: (context) => IncidentsStatisticsCubit()..getIncidentsStatistics(context),
      child: BlocBuilder<IncidentsStatisticsCubit, IncidentsStatisticsState>(
        builder: (context, state) {

          if (state is IncidentsStatisticsLoaded &&
              (state.incidentsStatistics.incidents.moderateCount > 0 ||
                  state.incidentsStatistics.incidents.severCount > 0)) {
            moderateCount = state.incidentsStatistics.incidents.moderateCount;
            severCount = state.incidentsStatistics.incidents.severCount;
            lowCount = state.incidentsStatistics.incidents.lowCount;
            allCount = state.incidentsStatistics.incidents.count;

            return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TitleAndSeeAllWidget(
                      title: openIncidentsKey,
                      seeAllText: showAllTextKey,
                      showSeeAll: true,
                      palette: palette,
                      appIcons: appIcons,
                      seAllOnTap: widget.onSeeAllTap ?? () {},
                    ),
                    CustomInkWell(
                      onTap: () {
                        // Get.put(IncidentsStatisticsAndListController());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IncidentsStatisticsAndListScreen(
                              palette: palette,
                              isDark: widget.isDark,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.themeColorsSurfaceElevationRaised,
                          border: Border.all(color: palette.themeColorsBorderNeutral11),
                          borderRadius: BorderRadius.circular(appBorders.xLarge),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: palette.themeColorsDangerDefault,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    Text(
                                      "$severCount ${severeTextKey.tr}",
                                      style: defaultTextStyle(
                                        14,
                                        color: palette.themeColorsTextTitle,
                                        context: context,
                                      ),
                                    ),
                                  ],
                                ),
                                4.verticalSpace,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: palette.themeColorsWarningDefault,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    Text(
                                      "$moderateCount ${moderateTextKey.tr}",
                                      style: defaultTextStyle(
                                        14,
                                        color: palette.themeColorsTextTitle,
                                        context: context,
                                      ),
                                    )
                                  ],
                                ),
                                4.verticalSpace,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: palette.themeColorsBorderNeutral08,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    Text(
                                      "$lowCount ${lowTextKey.tr}",
                                      style: defaultTextStyle(
                                        14,
                                        color: palette.themeColorsTextTitle,
                                        context: context,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 90,
                              width: 90,
                              child: Stack(
                                children: [
                                  PieChart(
                                    key: ValueKey(severCount + moderateCount + lowCount),
                                    PieChartData(
                                        borderData: FlBorderData(show: false),
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 0,
                                        sections: [
                                          PieChartSectionData(
                                              badgeWidget: Container(),
                                              value: severCount.toDouble(),
                                              radius: 45,
                                              showTitle: false,
                                              color: palette.themeColorsDangerDefault),
                                          PieChartSectionData(
                                            badgeWidget: Container(),
                                            value: moderateCount.toDouble(),
                                            radius: 45,
                                            showTitle: false,
                                            color: palette.themeColorsWarningDefault,
                                          ),
                                          PieChartSectionData(
                                            badgeWidget: Container(),
                                            radius: 45,
                                            value: lowCount.toDouble(),
                                            showTitle: false,
                                            color: palette.themeColorsBorderNeutral08,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: palette.themeColorsSurfaceElevationRaised,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(_getTotalCount(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: defaultTextStyle(
                                                16,
                                                color: palette.themeColorsTextTitle,
                                                weight: FontWeight.w700,
                                                context: context,
                                              )),
                                          Text(
                                            severCount + moderateCount + lowCount > 1
                                                ? incidentsTextKey.tr
                                                : incidentTextKey.tr,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: defaultTextStyle(
                                              12,
                                              color: palette.themeColorsTextTitle,
                                              context: context,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
