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
import 'package:blink_component/models/incident/create_incident_scope_names.dart';
import 'package:blink_component/widgets/card_widgets/new_cards_design/select_card_widget.dart';
import 'package:blink_component/widgets/card_widgets/venue_card.dart';
import 'package:blink_component/widgets/error_widgets/statistics_error_widget.dart';
import 'package:blink_component/widgets/skeleton_widgets/text_and_forward_arrow_skeleton.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:incident_manager/incident_manager.dart';
import 'package:incident_manager/src/config/assets.dart';
import '../controllers/create_incident_controller.dart';
import '../controllers/incident_scope_controller.dart';
import '../state_management/scope_names_state_management.dart';
import 'pick_location_bottom_sheet.dart';

void showScopeBottomSheet(
    {required BuildContext context,
    required bool isDark,
    required MyColorsPalette palette,
    required CreateIncidentController createIncidentController}) {
  IncidentScopeController scopeController=Get.find<IncidentScopeController>();
  scopeController.setTempScope();
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.none,
      builder: (context) {
        return BlocProvider<IncidentScopeTypesCubit>(
          create: (context) => IncidentScopeTypesCubit(),
          child: ScopeBottomSheetContent(
            isDark: isDark,
            palette: palette,
            appIcons: incidentsModuleAppIcons,
            appBorders: incidentsModuleAppBorders,
            createIncidentController: createIncidentController,
          ),
        );
      });
}

class ScopeBottomSheetContent extends StatefulWidget {
  final bool isDark;
  final MyColorsPalette palette;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final CreateIncidentController createIncidentController;


  const ScopeBottomSheetContent({
    super.key,
    required this.isDark,
    required this.palette,
    required this.appIcons,
    required this.appBorders,
    required this.createIncidentController,
  });

  @override
  State<ScopeBottomSheetContent> createState() =>
      _ScopeBottomSheetContentState();
}

class _ScopeBottomSheetContentState extends State<ScopeBottomSheetContent> {
  final incidentScopeController = Get.find<IncidentScopeController>();
  final createIncidentController = Get.find<CreateIncidentController>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<IncidentScopeTypesCubit>(context)
        .getIncidentScopeTypes(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!widget.createIncidentController.isExpanded.value) {
        return SelectScopeBottomSheetContent(
          isDark: widget.isDark,
          palette: widget.palette,
          incidentScopeController: incidentScopeController,
          createIncidentController: createIncidentController,
        );
      } else {
        return ScopeListBottomSheetContent(
          isDark: widget.isDark,
          palette: widget.palette,
          appIcons: widget.appIcons,
          appBorders: widget.appBorders,
          incidentScopeController: incidentScopeController,
          createIncidentController: widget.createIncidentController,
        );
      }
    });
  }
}

class SelectScopeBottomSheetContent extends StatelessWidget {
  final bool isDark;
  final MyColorsPalette palette;
  final IncidentScopeController incidentScopeController;
  final CreateIncidentController createIncidentController;

  const SelectScopeBottomSheetContent({
    super.key,
    required this.isDark,
    required this.palette,
    required this.incidentScopeController,
    required this.createIncidentController,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: getPaletteColor(palette.themeColorsSurfaceElevationRaised),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(incidentsModuleAppBorders.large),
        ),
        border: Border(
          top: BorderSide(
            color: getPaletteColor(palette.themeColorsBorderNeutral11),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    height: 6,
                    width: 53,
                    decoration: BoxDecoration(
                      color: getPaletteColor(palette.themeColorsSurfaceNeutralLevel05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.gap,
          Text(
            scopeTextKey.tr,
            style: TextStyle(
              fontSize: 16,
              color: getPaletteColor(palette.themeColorsTextTitle),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            selectScopeCategoryTextKey.tr,
            style: TextStyle(
              color: getPaletteColor(palette.themeColorsTextBody),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          12.gap,
          Divider(
            color: palette.themeColorsBorderNeutral11,
            thickness: 1,
          ),
          12.gap,
          BlocConsumer<IncidentScopeTypesCubit, IncidentScopeTypesState>(
            listener: (cubit, state) async {
              if (state is IncidentScopeTypesError) {
                await Future.delayed(const Duration(milliseconds: 200));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                showCustomSnackBar(
                  context: context,
                  message: state.message,
                  snackBarType: SnackBarType.error,
                );
              }
            },
            builder: (context, state) {
              if (state is IncidentScopeTypesLoading) {
                return TextAndForwardArrowListSkeleton(
                    palette: palette,
                    appBorders: incidentsModuleAppBorders,
                );
              }
              if (state is IncidentScopeTypesLoaded) {
                return Expanded(
                  child: ListView.separated(
                      itemBuilder: (_, index) => scopeOptionWidget(
                          context: context,
                          palette: palette,
                          isDark: isDark,
                          scope: state.scope.scopeTypes[index],
                          appIcons: incidentsModuleAppIcons,
                      ),
                      separatorBuilder: (_, index) => 8.gap,
                      itemCount: state.scope.scopeTypes.length),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  CustomInkWell scopeOptionWidget({
    required BuildContext context,
    required bool isDark,
    required MyColorsPalette palette,
    required String scope,
    required AppIcons appIcons,
  }) {
    // TODO: Use SelectFilterWithCountWidget instead of this (component identification)
    return CustomInkWell(
      onTap: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // bool result = await InternetConnection().hasInternetAccess;
        // if (!result) {
        //   showCustomSnackBar(
        //     context: context,
        //     message: connectionLostPleaseCheckInternetTextKey.tr,
        //     margin: 40,
        //     snackBarType: SnackBarType.error,
        //   );
        //   return;
        // }
        // Todo: Change this
        if (fromStringToIncidentScopeType(scope) == IncidentScopeType.other) {
          incidentScopeController.updateSelectedCategoryType(scope);
          incidentScopeController.selectDeselectScope(
              incidentScopeController.selectedCategoryType.name, null);
          showPickLocationBottomSheet(
              context: context,
              isDark: isDark,
              palette: palette,
              createIncidentController: createIncidentController,
              onPickLocation: (location) {
                incidentScopeController.isLocationBottomSheetExpanded(true);
                incidentScopeController.selectLocation(location);
              });
          // Navigator.pop(context);
          return;
        }
        incidentScopeController.updateSelectedCategoryType(scope);
        createIncidentController.isExpanded(true);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (scopeIcon(scope, appIcons) != null) ...[
              SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: Icon(
                    scopeIcon(scope, appIcons)!,
                    color: getPaletteColor(palette.themeColorsIconNeutral),
                    size: 20,
                  ),
                ),
              ),
              8.gap,
            ],
            Expanded(
              child: Text(scopeText(scope),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: getPaletteColor(palette.themeColorsTextTitle),
                ),
              ),
            ),
            SizedBox(
              height: 24,
              width: 24,
              child: Center(
                child: Icon(
                  incidentsModuleAppIcons.arrowForward,
                  color: getPaletteColor(palette.themeColorsIconNeutral),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData? scopeIcon(String type,AppIcons appIcons) {
    switch (type.toLowerCase()) {
      case 'session':
        return appIcons.tickets;
      case 'venue':
        return appIcons.hotelIcon;
      case 'attendee':
        return appIcons.usersIcon;
      case 'other':
        return appIcons.circleQuestionIcon;
    }
  }

  String scopeText(String type) {
    switch (type.toLowerCase()) {
      case 'session':
        return experienceTextKey.tr;
      case 'venue':
        return venueTextKey.tr;
      case 'attendee':
        return attendeeTextKey.tr;
      case 'other':
        return otherTextKey.tr;
        default:
          return type.capitalizeFirsForAll;
    }
  }
}

class ScopeListBottomSheetContent extends StatelessWidget {
  final MyColorsPalette palette;
  final bool isDark;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final IncidentScopeController incidentScopeController;
  final CreateIncidentController createIncidentController;

  const ScopeListBottomSheetContent({
    super.key,
    required this.isDark,
    required this.palette,
    required this.appIcons,
    required this.appBorders,
    required this.incidentScopeController,
    required this.createIncidentController,
  });

  @override
  Widget build(BuildContext context) {

    return GetBuilder<IncidentScopeController>(
        builder: (incidentScopeController) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.81,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: getPaletteColor(palette.themeColorsSurfaceElevationRaised),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(appBorders.large),
          ),
          border: Border(
            top: BorderSide(
              color: getPaletteColor(palette.themeColorsBorderNeutral11),
              width: 1.0, // width of the border
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      height: 6,
                      width: 53,
                      decoration: BoxDecoration(
                        color: getPaletteColor(
                            palette.themeColorsSurfaceNeutralLevel05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.gap,
            Row(
              children: [
                CustomInkWell(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6,top: 6,bottom:6),
                    child: Icon(appIcons.arrowBack,
                        color: getPaletteColor(palette.themeColorsIconNeutral),
                        size: 16),
                  ),
                  onTap: () {
                    createIncidentController.isExpanded(false);
                  },
                ),
                Expanded(
                  child: Text(
                    incidentScopeController.selectedCategoryTitle.value.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: getPaletteColor(palette.themeColorsTextTitle),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                8.gap,
              ],
            ),
            12.gap,
            Divider(
              color: palette.themeColorsBorderNeutral11,
              thickness: 1,
            ),
            12.gap,
            SearchFieldWidget(
              appIcons: appIcons,
              borderRadius: appBorders.xSmall,
              palette: palette,
              hint: incidentScopeController.selectedCategorySearchHint.value.tr,
              maxHeight: textFieldHeight45,
              onSearchList: incidentScopeController.onSearchTextChanged,
              clearSearch: () =>
                  incidentScopeController.onSearchTextChanged(''),
              controller: incidentScopeController.searchTextController,
            ),
            20.gap,
            WillPopScope(
              onWillPop: () async {
                if (createIncidentController.isExpanded.value) {
                  createIncidentController.isExpanded(false);
                  return false;
                } else {
                  return true;
                }
              },
              child: Expanded(
                child: ListView(
                  controller: incidentScopeController.scrollController,
                  children: [
                    ScopeListDependingOnTheType(
                      palette: palette,
                      isDark: isDark,
                      appIcons: appIcons,
                      appBorders: appBorders,
                      incidentScopeController: incidentScopeController,
                      createIncidentController: createIncidentController,
                    ),
                    if (incidentScopeController.canLoadMore.value)
                      _getLoadMoreSkeleton(palette, appBorders),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _getLoadMoreSkeleton(MyColorsPalette palette, AppBorders appBorders) {
    return SelectCardSkeleton(
        appBorders: incidentsModuleAppBorders,
        palette: palette,
    );
  }
}

class ScopeListDependingOnTheType extends StatelessWidget {
  final MyColorsPalette palette;
  final bool isDark;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final IncidentScopeController incidentScopeController;
  final CreateIncidentController createIncidentController;

  const ScopeListDependingOnTheType({
    super.key,
    required this.palette,
    required this.isDark,
    required this.incidentScopeController,
    required this.appIcons,
    required this.appBorders,
    required this.createIncidentController,
  });

  @override
  Widget build(BuildContext context) {

    switch (incidentScopeController.selectedCategoryType) {
      case IncidentScopeType.session:
        return _sessionsListWidget(
            palette: palette, isDark: isDark, appBorders: appBorders);
      case IncidentScopeType.venue:
        return _venuesListWidget(
            palette: palette, isDark: isDark, context: context,appBorders: appBorders);
      case IncidentScopeType.attendee:
        return _attendeesListWidget(
            palette: palette,
            isDark: isDark,
            createIncidentController: createIncidentController,
            context: context,appBorders: appBorders);
      case IncidentScopeType.other:
        return Container();
    }
  }

  Widget _sessionsListWidget({
    required MyColorsPalette palette,
    required AppBorders appBorders,
    required bool isDark,
  }) {
    return ConditionalBuilder(
      condition: incidentScopeController.showLoading.value,
      builder: (_) => SelectCardListSkeleton( palette: palette,appBorders:appBorders ,padding:const EdgeInsets.only(bottom:20,),),
      fallback: (_) => ConditionalBuilder(
        condition: incidentScopeController.errorMessage.value.isNotEmpty,
        builder: (_) => Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child:
          StatisticsErrorWidget(
            palette: palette,
            cardWidget: EmptyAgendaGradientCard(
              palette: palette,
              borderRadiusMedium: appBorders.medium,
            ),
            errorMessage: incidentScopeController.errorMessage.value,
            onRetry: () {
              incidentScopeController.getListData();
            },
          ),
        )),
        fallback: (_) => ConditionalBuilder(
          condition: incidentScopeController.sessions.isNotEmpty,
          builder: (_) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              final session = incidentScopeController.sessions[index];
              return SelectCardWidget(
                  cardType: session.cardModelType,
                  isSelected: incidentScopeController.tempSelectedSession != null &&
                      session.id == incidentScopeController.tempSelectedSession?.id,
                  title: session.title,
                  info: '${session.from12Format} - ${session.to12Format}',
                  onSelect: () {
                    incidentScopeController.tempSelectDeselectScope(
                        incidentScopeController.selectedCategoryType.name,
                        session);
                    onSelectScopeItem(context, palette);
                    FocusScope.of(Get.context ?? context).unfocus();
                  });
            },
            separatorBuilder: (_, index) => const SizedBox(
              height: 8,
            ),
            itemCount: incidentScopeController.sessions.length,
          ),
          fallback: (_) => incidentScopeController.searchText.value.isNotEmpty ?
          NoResultsFoundWidget(
            searchNotFoundImage: AppImages.errorSearchImage,
            backgroundImage: AppImages.errorBackgroundImage,
          ) : NoExperiencesYetWidget(
              cardImage: AppImages.errorCardsImage,
            backgroundImage: AppImages.errorBackgroundImage,
          ),
        ),
      ),
    );
  }

  void onSelectScopeItem(BuildContext context, MyColorsPalette palette) {
    if (incidentScopeController.isScopeChange.value &&
        incidentScopeController.tempScopeDetails != null) {
      incidentScopeController.selectDeselectScope(
          incidentScopeController.selectedCategoryType.name,
          incidentScopeController.tempScopeDetails);
      if (incidentScopeController.selectedCategoryType ==
          IncidentScopeType.attendee) {
        showPickLocationBottomSheet(
            context: context,
            isDark: isDark,
            palette: palette,
            createIncidentController:
            createIncidentController,
            onPickLocation: (location) {
              incidentScopeController
                  .isLocationBottomSheetExpanded(true);
              incidentScopeController
                  .selectLocation(location);
            });
      } else {
        FocusScope.of(Get.context ?? context).unfocus();
      }
    }
  }

  Widget _venuesListWidget(
      {required MyColorsPalette palette,
      required bool isDark,
      required AppBorders appBorders,
      required BuildContext context}) {
    return ConditionalBuilder(
      condition: incidentScopeController.showLoading.value,
      builder: (_) => SelectCardListSkeleton( palette: palette,appBorders:appBorders ,padding: const EdgeInsets.only( bottom: 20),),

      fallback: (_) => ConditionalBuilder(
        condition: incidentScopeController.errorMessage.value.isNotEmpty,
        builder: (_) => Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: StatisticsErrorWidget(
            palette: palette,
            cardWidget: EmptyAgendaGradientCard(
              palette: palette,
              borderRadiusMedium: appBorders.medium,
            ),
            errorMessage: incidentScopeController.errorMessage.value,
            onRetry: () {
              incidentScopeController.getListData();
            },
          ),
        )),
        fallback: (_) => ConditionalBuilder(
          condition: incidentScopeController.venues.isNotEmpty,
          builder: (_) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only( bottom: 20),
            itemBuilder: (_, index) {
              final venue = incidentScopeController.venues[index];
              return SelectCardWidget(
                  icon: getVenueIcon(appIcons,venue.venueType),
                  cardType: venue.cardModelType,
                  isSelected: incidentScopeController.tempSelectedVenue != null &&
                      venue.id == incidentScopeController.tempSelectedVenue?.id,
                  title: venue.name,
                  info: '${venue.sessionsCount} ${keySessionsText.tr}',
                  onSelect: () {
                    incidentScopeController.tempSelectDeselectScope(
                        incidentScopeController.selectedCategoryType.name,
                        venue);
                    onSelectScopeItem(context, palette);

                    FocusScope.of(Get.context ?? context).unfocus();

                  });
            },
            separatorBuilder: (_, index) => const SizedBox(
              height: 8,
            ),
            itemCount: incidentScopeController.venues.length,
          ),
          fallback: (_) => incidentScopeController.searchText.value.isNotEmpty
              ? NoResultsFoundWidget(
                  searchNotFoundImage: AppImages.errorSearchImage,
                  backgroundImage: AppImages.errorBackgroundImage,
                )
              : NoVenuesYetWidget(
                  cardImage: AppImages.errorCardsImage,
                  backgroundImage: AppImages.errorBackgroundImage,
                ),
        ),
      ),
    );
  }

  Widget _attendeesListWidget(
      {required MyColorsPalette palette,
      required bool isDark,
      required AppBorders appBorders,
      required CreateIncidentController createIncidentController,
      required BuildContext context}) {
    return ConditionalBuilder(
      condition: incidentScopeController.showLoading.value,
      builder: (_) => SelectCardListSkeleton( palette: palette,appBorders:appBorders ,padding: const EdgeInsets.only( bottom: 20),),
      fallback: (_) => ConditionalBuilder(
        condition: incidentScopeController.errorMessage.value.isNotEmpty,
        builder: (_) => Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: StatisticsErrorWidget(
              palette: palette,
              cardWidget: EmptyAgendaGradientCard(
                palette: palette,
                borderRadiusMedium: appBorders.medium,
              ),
              errorMessage: incidentScopeController.errorMessage.value,
              onRetry: () {
                incidentScopeController.getListData();
              },
            ),
          ),
        ),
        fallback: (_) => ConditionalBuilder(
          condition: incidentScopeController.attendees.isNotEmpty,
          builder: (_) => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (_, index) {
              final attendee = incidentScopeController.attendees[index];
              return FilterByGuestWidgetNewDesignV2(
                margin: EdgeInsets.zero,
                firstName: attendee.firstName,
                lastName: attendee.lastName,
                guestImage: attendee.avatar,
                loadingSpinnerFile: isDark
                    ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
                    : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight ?? '',
                userPlaceholderImageFile: AppImages.guestPlaceholderImage,
                loadingSpinner: isDark
                    ? AppImages.loadingSpinnerDark
                    : AppImages.loadingSpinnerLight,
                userPlaceholderImage: AppImages.guestPlaceholderImage,
                withCheckBox: false,
                withCircleIcon: true,
                isSelected: incidentScopeController.tempSelectedAttendee != null &&
                        incidentScopeController.attendees[index].id == incidentScopeController.tempSelectedAttendee?.id
                    ? true
                    : false,
                onTap: () {
                  incidentScopeController.tempSelectDeselectScope(
                      incidentScopeController.selectedCategoryType.name,
                      incidentScopeController.attendees[index]);
                  onSelectScopeItem(context, palette);
                },
              );
            },
            separatorBuilder: (_, index) => const SizedBox(
              height: 8,
            ),
            itemCount: incidentScopeController.attendees.length,
          ),
          fallback: (_) => incidentScopeController.searchText.value.isNotEmpty
              ? NoResultsFoundWidget(
                  searchNotFoundImage: AppImages.errorSearchImage,
                  backgroundImage: AppImages.errorBackgroundImage,
                )
              : NoAttendeesYetWidget(
                  errorAttendeeImage: AppImages.errorAttendeeImage,
                  backgroundImage: AppImages.errorBackgroundImage,
                ),
        ),
      ),
    );
  }
}
