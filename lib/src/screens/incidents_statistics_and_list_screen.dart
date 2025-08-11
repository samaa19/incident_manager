import 'package:blink_component/blink_component.dart';
import 'package:blink_component/models/capacity_indicator.dart';
import 'package:blink_component/models/incident/incident_model.dart';
import 'package:blink_component/models/role_access_model.dart';
import 'package:blink_component/widgets/agenda/new_design_widgets/scroll_top_floating_button.dart';
import 'package:blink_component/widgets/agenda/title_and_count_widget.dart';
import 'package:blink_component/widgets/card_widgets/incident_card/incidents_cards_group_view.dart';
import 'package:blink_component/widgets/skeleton_widgets/new_design_skeletons/agenda_card_skeleton.dart';
import 'package:blink_component/widgets/skeleton_widgets/new_design_skeletons/agenda_summary_and_list_skeleton.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:incident_manager/src/config/assets.dart';
import 'package:incident_manager/src/controllers/incident_details_controller.dart';

import '../../incident_manager.dart';
import '../state_management/capacity_indicators_state_management.dart';
import 'create_incident_screen.dart';
import 'incident_details_screen.dart';

class IncidentsStatisticsAndListScreen extends StatelessWidget {
  final MyColorsPalette palette;
  final bool isDark;

  IncidentsStatisticsAndListScreen({
    super.key,
    required this.palette,
    required this.isDark,
  });

  final controller = Get.find<IncidentsStatisticsAndListController>();

  @override
  Widget build(BuildContext context) {
    final appIcons = incidentsModuleAppIcons;
    final appBorders = incidentsModuleAppBorders;

    return Scaffold(
      body: GetBuilder<IncidentsStatisticsAndListController>(
        builder: (controller) {
          if(controller.isScreenLoading.value){
            return Center(
              child: AgendaSummaryAndListSkeleton(
                palette: palette,
                appBorders: appBorders,
                appIcons: appIcons,
                isDark: isDark,
              ),
            );
          }
          return RefreshIndicator.adaptive(
            onRefresh: () async => controller.refreshData(),
            color: palette.themeColorsBorderNeutral09,
            edgeOffset: agendaSummaryHeight + searchFieldHeight + searchFieldHeight,
            child: DraggableView(
              backgroundColor: getPaletteColor(palette.themeColorsSurfaceElevationSurface),
              isDark: isDark,
              stretch: false,
              centerTitle: false,
              scrollController: controller.scrollController,
              headerWidget: StatisticsHeaderWidget(
                type: StatisticsTypeEnum.incidents,
                palette: palette,
                agendaSummary: controller.agendaSummary,
                appIcons: appIcons,
                height: controller.getHeaderHeight,
                key: UniqueKey(),
              ),
              headerExpandedHeight: agendaSummaryHeight / Get.height,
              headerBorderRadius: appBorders.plus,
              body: [
                if (controller.isInternetConnected.isTrue) ...[
                  20.gap,
                  IncidentsFilterAndSearchWidget(
                    palette: palette,
                    appBorders: appBorders,
                    appIcons: appIcons,
                    controller: controller,
                  ),
                ],
                IncidentsFilterAndList(
                  appBorders: appBorders,
                  appIcons: appIcons,
                  palette: palette,
                  isDark: isDark,
                  controller: controller,
                  capacityIndicators: capacityIndicators,
                ),
              ],
              leading: CustomInkWell(
                onTap: Get.back,
                child: Icon(
                  appIcons.backArrowIcon,
                  color: getPaletteColor(palette.themeColorsTextTitle),
                  size: 18,
                ),
              ),
              title: Text(
                controller.screenTitle,
                textAlign: TextAlign.start,
                style: getTextStyle(
                  fontSize: 22,
                  context: context,
                  color: getPaletteColor(palette.themeColorsTextTitle),
                  weight: FontWeight.w700,
                ),
              ),
              customPaintBgColor: getPaletteColor(palette.themeColorsSurfaceElevationRaised),
              borderColor: getPaletteColor(palette.themeColorsBorderNeutral11),
              borderWidth: 1,
              showDraggableLine: false,
              showCustomPaint: false,
            ),
          );
        },
      ),
      floatingActionButton: Obx(
            () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            backToStartOfList(palette),
              if (!(controller.isScrollAtTop.value ||
                  controller.isScreenLoading.value ||
                  controller.headerHeight.value != controller.getHeaderHeight))
                4.gap,
              RoleRestrictedWidget(
                requiredLevel: AccessLevel.fullAccess,
                roleKey: RoleAccessKey.incidentsAccess,
                child: FloatingAddButton(
                  onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateIncidentScreen(
                        palette: palette,
                        isDark: isDark,
                        incidentModel: null,
                      ),
                    ),
                  );
                },
                palette: palette,
                  appIcons: appIcons,
                  smallBorderRadius: appBorders.medium,
                ),
              ),

            12.gap,
          ],
        ),
      ),
    );

  }

  AnimatedOpacity backToStartOfList(MyColorsPalette palette) {
    return AnimatedOpacity(
      opacity: controller.isScrollAtTop.value ||
          controller.isScreenLoading.value ||
          controller.headerHeight.value != controller.getHeaderHeight
          ? 0
          : 1,
      duration: const Duration(seconds: 0),
      child: GestureDetector(
        onTap: () {
          controller.scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ScrollTopFloatingButton(
            palette: palette,
            appBorders: incidentsModuleAppBorders,
            appIcons: incidentsModuleAppIcons,
          ),
        ),
      ),
    );
  }
}


class IncidentsFilterAndList extends StatelessWidget {
  final bool isDark;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final MyColorsPalette palette;
  final List<CapacityIndicatorModel> capacityIndicators;
  final IncidentsStatisticsAndListController controller;

  const IncidentsFilterAndList({
    super.key,
    required this.controller,
    required this.appBorders,
    required this.appIcons,
    required this.palette,
    required this.isDark, required this.capacityIndicators,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _dataList(context, appIcons),

        /// Load more skeleton
        Obx(
              () {
            if (controller.showLoadingNewPage.isTrue) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _getLoadMoreSkeleton());
            }
            return const Offstage();
          },
        ),
        92.gap,
      ],
    );
  }

  Widget _getLoadMoreSkeleton() {
    return AgendaCardSkeleton(palette: palette, appBorders: appBorders,);
  }

  Column _dataList(BuildContext context, AppIcons appIcons) {
    return Column(
      children: [
        20.verticalSpace,
        _incidentsListWidget(
          palette: palette,
          appIcons: appIcons,
          isDark: isDark,
          context: context,
          // errorBackgroundImage: errorBackgroundImage,
          // errorCardsImage: errorCardsImage,
        ),
      ],
    );
  }

  Widget quickFilterEmptyDataWidget({
    required BuildContext context,
    required String errorBackgroundImage,
    required String errorCardsImage,
  }) {
    return DataStateIndicatorWidget(
      errorModel: DesignErrorModel(
        image: errorCardsImage,
        title: noMatchesFoundTextKey,
        subTitle1: theSelectedFilterDidNotReturnAnyResultsTryAdjustingYourFilterOrExploringOtherOptionsTextKey,
      ),
      backgroundImage: errorBackgroundImage,
      withFilter: controller.canFilterClear.value,
      onClearFilter: () {
      },
    );
  }

  Widget _incidentsListWidget({
    required BuildContext context,
    required MyColorsPalette palette,
    required AppIcons appIcons,
    // required MyAssets assets,
    // required String errorBackgroundImage,
    // required String errorCardsImage,
    required bool isDark,
  }) {
    return ConditionalBuilder(
      condition: controller.isScreenLoading.value,
      builder: (_) => AgendaCardsListSkeleton(palette: palette, appBorders: appBorders, padding: const EdgeInsets.only(bottom: 60, left: 20, right: 20)),
      fallback: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ConditionalBuilder(
          condition: controller.dateError.value.isNotEmpty,
          builder: (_) => Center(
            child: DataStateIndicatorWidget(
              errorModel: DesignErrorModel(
                image: AppImages.errorCardsImage,
                title: '',
                subTitle1: controller.dateError.value,
              ),
              backgroundImage: AppImages.errorBackgroundImage,
              withFilter: controller.canFilterClear.value,
            )
          ),
          fallback: (_) => ConditionalBuilder(
            condition: controller.incidentsGroups.isNotEmpty,
            builder: (_) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding:  EdgeInsets.only(right: 4, left: 4, bottom: controller.canLoadMore.value ? spaceBetweenItemsInList : 20),
              // itemBuilder: (_, index) {
              //   if (controller.canFilterClear.value &&
              //       index == controller.incidentsGroups.length) {
              //     return ClearFilterWidget(
              //       palette: palette,
              //       hasFilter: !controller.canFilterClear.value,
              //       color:
              //       getPaletteColor(palette.themeColorsActionLinkDefaultFg),
              //       gap: 20,
              //       onClearClicked: () {
              //       },
              //     );
              //   }

              itemBuilder: (_, index) {
                final addClear = controller.canFilterClear.value &&
                    index == controller.incidentsGroups.length;
                if (addClear) {
                  return ClearFilterWidget(
                    palette: palette,
                    hasFilter: true, // ✅
                    color: getPaletteColor(palette.themeColorsActionLinkDefaultFg),
                    gap: 20,
                    onClearClicked: () {
                      controller.updateTap([IncidentTabsEnum.all.getApiKey]);
                      controller.onSearchTextChanged('');
                    },
                  );
                }
                return IncidentsCardsGroupView(
                  palette: palette,
                  appBorders: appBorders,
                  appIcons: appIcons,
                  incidentsCardsGroupModel: controller.incidentsGroups[index],
                  onTap: (incidentModel) {
                    Get.find<IncidentDetailsController>().getIncidentDetails(
                      incidentId: incidentModel.id,
                      context: context,
                      palette: palette,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IncidentDetailsScreen(
                          isDark: isDark,
                          palette: palette,
                        ),
                      ),
                    );
                    // navigateToIncidentDetailsScreen(
                    //     context: context,
                    //     statisticsControllerTag: tagOfController,
                    //     beforeNavigating: () {
                    //       Get.find<IncidentController>().getIncidentDetails(incidentId: incidentModel.id, context: context, palette: palette, assets: assets);
                    //     }
                    // );
                  },
                  onChangeStatus: (incidentModel) {
                    // updateIncidentStatus(
                    //     context: context,
                    //     palette: palette,
                    //     isDark: isDark,
                    //     controller: Get.find<IncidentController>(),
                    //     incidentId: incidentModel.id,
                    //     incidentStatus: incidentModel.status,
                    //     onUpdateIncidentStatus: () {
                    //       controller.refreshStatistics(loading: false);
                    //       controller.updateItemStatusInIncident(incidentModel.id);
                    //       Navigator.of(context).pop();
                    //
                    //     });
                  },
                );
              },
              separatorBuilder: (_, index) => const SizedBox(
                height: 20,
              ),
              itemCount: controller.incidentsGroups.length +
                  (controller.canFilterClear.value ? 1 : 0),
            ),
            fallback: (_) => controller.searchText.isNotEmpty
                ? NoResultsFoundWidget(
                searchNotFoundImage: AppImages.errorSearchImage,
                backgroundImage: AppImages.errorBackgroundImage,
            )
                : DataStateIndicatorWidget(
              errorModel: DesignErrorModel(
                image: AppImages.errorCardsImage,
                title: noIncidentsYetTextKey,
                subTitle1: noIncidentsHaveBeenAddedYetTextKey,
              ),
              backgroundImage: AppImages.errorBackgroundImage,
              withFilter: controller.searchText.isEmpty && controller.canFilterClear.value,
              onClearFilter: () {
              },
            ),
          ),
        ),
      ),
    );
  }
}


class IncidentsFilterAndSearchWidget extends StatelessWidget {
  final MyColorsPalette palette;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final IncidentsStatisticsAndListController controller;

  const IncidentsFilterAndSearchWidget({
    super.key,
    required this.palette,
    required this.controller,
    required this.appIcons,
    required this.appBorders,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TitleAndCountWidget(
            palette: palette,
            title: controller.listTitle,
            totalCount: controller.totalCount.value,
            showCount: true,
          ),
        ),
        Divider(color: getPaletteColor(palette.themeColorsBorderNeutral11), indent: 20, endIndent: 20),
        _quickFilerTabs(context),
        SearchFieldWidget(
          appIcons: appIcons,
          borderRadius: appBorders.xSmall,
          palette: palette,
          hint: searchForIncidentsTextKey.tr,
          maxHeight: textFieldHeight45,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          onSearchList: controller.onSearchTextChanged,
          clearSearch: () => controller.onSearchTextChanged(''),
          controller: controller.searchTextController,
        ),
      ],
    );
  }


  Widget _quickFilerTabs(BuildContext context) {
    return _generalTabs(
      tabBorderRadius: appBorders.xSmall,
      tabPadding:const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      onTap: (tabsList) {
        List<String> selectedItems = controller.incidentTypesList
            .where((e) => tabsList.contains(e.getDisplayName))
            .map((e) => e.getApiKey)
            .toList();
        controller.updateTap(selectedItems);
      },
      tabsList: controller.incidentTypesList
          .map((e) => e.getDisplayName)
          .toList(),
        initialSelectedTabs: controller.incidentTypesList
            .where((e) => controller.incidentTypes.contains(e.getApiKey))
            .map((e) => e.getDisplayName)
            .toList(),
      // initialSelectedTabs: controller.incidentTypesList
      //     .where((e) => controller.incidentTypes.contains(e.getDisplayName))
      //     .map((e) => e.getDisplayName)
      //     .toList(),
    );
    }

  Widget _generalTabs({
    required Function(List<String> tabsList) onTap,
    required List<String> tabsList,
    required List<String> initialSelectedTabs,
    double paddingBetweenTabs=8,
    double? tabBorderRadius,
    EdgeInsets tabPadding= const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16, right: 20, left: 20),
        child: GeneralTabs(
          paddingBetweenTabs: paddingBetweenTabs,
          tabsList: tabsList,
          initialSelectedTabs: initialSelectedTabs,
          firstTabIsAll: true,
          canTapClick: true,
          tabPadding: tabPadding,
          onTap: onTap,
        ),
      );

}
