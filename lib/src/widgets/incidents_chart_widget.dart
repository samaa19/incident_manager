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
import '../state_management/incidents_statistics_state_management.dart';

class IncidentsDetailsChartWidget extends StatefulWidget {
  final MyColorsPalette palette;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final VoidCallback? onSeeAllTap;

  const IncidentsDetailsChartWidget({
    super.key,
    required this.palette,
    required this.appIcons,
    required this.appBorders,
    this.onSeeAllTap,
  });

  @override
  State<IncidentsDetailsChartWidget> createState() =>
      _IncidentsDetailsChartWidgetState();
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
                      palette: widget.palette,
                      appIcons: widget.appIcons,
                      seAllOnTap: widget.onSeeAllTap ?? () {},
                    ),
                    CustomInkWell(
                      onTap: widget.onSeeAllTap ?? () {},
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.palette.themeColorsSurfaceElevationRaised,
                          border: Border.all(color: widget.palette.themeColorsBorderNeutral11),
                          borderRadius: BorderRadius.circular(widget.appBorders.xLarge),
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
                                        color: widget.palette.themeColorsDangerDefault,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    Text(
                                      "$severCount ${severeTextKey.tr}",
                                      style: defaultTextStyle(
                                        14,
                                        color: widget.palette.themeColorsTextTitle,
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
                                        color: widget.palette.themeColorsWarningDefault,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    Text(
                                      "$moderateCount ${moderateTextKey.tr}",
                                      style: defaultTextStyle(
                                        14,
                                        color: widget.palette.themeColorsTextTitle,
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
                                        color: widget.palette.themeColorsBorderNeutral08,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    5.horizontalSpace,
                                    Text(
                                      "$lowCount ${lowTextKey.tr}",
                                      style: defaultTextStyle(
                                        14,
                                        color: widget.palette.themeColorsTextTitle,
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
                                              color: widget.palette.themeColorsDangerDefault),
                                          PieChartSectionData(
                                            badgeWidget: Container(),
                                            value: moderateCount.toDouble(),
                                            radius: 45,
                                            showTitle: false,
                                            color: widget.palette.themeColorsWarningDefault,
                                          ),
                                          PieChartSectionData(
                                            badgeWidget: Container(),
                                            radius: 45,
                                            value: lowCount.toDouble(),
                                            showTitle: false,
                                            color: widget.palette.themeColorsBorderNeutral08,
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
                                        color: widget.palette.themeColorsSurfaceElevationRaised,
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
                                                color: widget.palette.themeColorsTextTitle,
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
                                              color: widget.palette.themeColorsTextTitle,
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
