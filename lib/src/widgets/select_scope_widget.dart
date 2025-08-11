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
import 'package:blink_component/models/capacity_indicator.dart';
import 'package:blink_component/models/incident/create_incident_scope_names.dart';
import 'package:blink_component/models/role_access_model.dart';
import 'package:blink_component/widgets/map_widgets/choose_location_widget_v2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incident_manager/incident_manager.dart';
import 'package:incident_manager/src/widgets/scope_bottom_sheet.dart';
import '../config/assets.dart';
import '../controllers/create_incident_controller.dart';
import '../controllers/incident_scope_controller.dart';
import '../screens/incident_details_screen.dart';
import 'pick_location_bottom_sheet.dart';

class SelectScopeWidget extends StatelessWidget {
  final bool isDark;
  final MyColorsPalette palette;
  final AppBorders appBorders;
  final AppIcons appIcons;
  final CreateIncidentController createIncidentController;
  final List<CapacityIndicatorModel> capacityIndicators;

  const SelectScopeWidget({
    super.key,
    required this.isDark,
    required this.palette,
    required this.appBorders,
    required this.appIcons,
    required this.createIncidentController,
    required this.capacityIndicators,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetBuilder<IncidentScopeController>(
          builder: (incidentScopeController) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleWithMandatoryWidget(
                  title: scopeTextKey.tr,
                  palette: palette,
                ),
                if(incidentScopeController.scopeIsSelected.value)
                CustomInkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    incidentScopeController.updateSelectedCategoryType(
                        incidentScopeController.selectedCategoryType.name);
                    showScopeBottomSheet(
                      context: context,
                      palette: palette,
                      createIncidentController: createIncidentController,
                      isDark: isDark,
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 5),
                      child: Icon(incidentsModuleAppIcons.editIcon, size: 18, color: palette.themeColorsActionGhostDefaultFg),
                    ),
                  ),
              ],
            );
          }
        ),
        8.gap,
        SelectedScopeWidget(
          isDark: isDark,
          palette: palette,
          appBorders: appBorders,
          appIcons: appIcons,
          capacityIndicators: capacityIndicators,
          createIncidentController: createIncidentController,
        ),
      ],
    );
  }
}

class SelectedScopeWidget extends StatelessWidget {
  final bool isDark;
  final MyColorsPalette palette;
  final AppBorders appBorders;
  final AppIcons appIcons;
  final CreateIncidentController createIncidentController;
  final List<CapacityIndicatorModel> capacityIndicators;

  const SelectedScopeWidget({
    super.key,
    required this.isDark,
    required this.palette,
    required this.appBorders,
    required this.appIcons,
    required this.createIncidentController,
    required this.capacityIndicators,
  });

  @override
  Widget build(BuildContext context) {
    final incidentScopeController = Get.find<IncidentScopeController>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getScopeWidget(incidentScopeController: incidentScopeController, context: context, isDark: isDark, capacityIndicators: capacityIndicators),
          // --Location if The scope is -other- or -attendee-
          if (incidentScopeController.selectedAttendee != null || incidentScopeController.selectedCategoryType == IncidentScopeType.other) ...{
            // -- Location if it's already picked
            if (incidentScopeController.confirmedLocation.value.lat != "" && incidentScopeController.confirmedLocation.value.lng != "") ...{
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: info(
                  label: locationTextKey.tr,
                  palette: palette,
                  dataWidget: LocationDetailsWithMapAndIcon(
                    palette: palette,
                    appBorders: incidentsModuleAppBorders,
                    mapImage: isDark ? AppImages.mapAddressIconDark : AppImages.mapAddressIconLight,
                    icon:appIcons.editPenIcon,
                    borderColor: palette.themeColorsBorderNeutral11,
                    margin: EdgeInsets.zero,
                    title: incidentScopeController.confirmedLocation.value.stopTitle,
                    address: incidentScopeController.confirmedLocation.value.address,
                    lat: incidentScopeController.confirmedLocation.value.lat,
                    lng: incidentScopeController.confirmedLocation.value.lng,
                    onIconTapped: () async {
                      incidentScopeController.isLocationBottomSheetExpanded(true);
                      incidentScopeController.selectedLocation=incidentScopeController.confirmedLocation.value;
                      incidentScopeController.addressDetailsTextController.text=incidentScopeController.confirmedAddressDetailsTextController.text;
                      showPickLocationBottomSheet(
                        context: context,
                        isDark: isDark,
                        palette: palette,
                        createIncidentController: createIncidentController,
                        onPickLocation: (location) {
                          incidentScopeController.isLocationBottomSheetExpanded(true);
                          incidentScopeController.selectLocation(location);
                        },
                      );
                    },
                  ),
                ),
              ),
              if(incidentScopeController.confirmedAddressDetailsTextController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: info(
                  label: locationDetailsTextKey.tr,
                  palette: palette,
                  dataText: incidentScopeController.confirmedAddressDetailsTextController.text,
                  dataMaxLines: 3,
                ),
              ),
            }

            // -- Location if it's not picked yet
            else ...{
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: info(
                  label: locationTextKey.tr,
                  palette: palette,
                  dataWidget: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(incidentsModuleAppBorders.xSmall),
                      border: Border.all(color: palette.themeColorsActionTertiaryDefaultBorder),
                    ),
                    child: CustomInkWell(
                      borderRadius: BorderRadius.circular(incidentsModuleAppBorders.xSmall),
                      onTap: () async {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        // bool result = await InternetConnection().hasInternetAccess;
                        // if(!result){
                        //   showCustomSnackBar(
                        //     context: context,
                        //     message: connectionLostPleaseCheckInternetTextKey.tr,
                        //     snackBarType: SnackBarType.error,
                        //   );
                        //   return;
                        // }
                          showPickLocationBottomSheet(
                            context: context,
                            isDark: isDark,
                            palette: palette,
                            createIncidentController: createIncidentController,
                            onPickLocation: (location) {
                              incidentScopeController
                                  .isLocationBottomSheetExpanded(true);
                              incidentScopeController.selectLocation(location);
                            },
                          );
                        },
                      child: ChooseLocationWidgetV2(
                        palette: palette,
                        appBorders: incidentsModuleAppBorders,
                        appIcons: appIcons,
                        mapWideImage: AppImages.mapWideImage,
                      )
                    ),
                  ),
                ),
              ),
            }
          }
        ],
      );
    });
  }

  _getScopeWidget({
    required IncidentScopeController incidentScopeController,
    required BuildContext context,
    required bool isDark,
    required List<CapacityIndicatorModel> capacityIndicators,
  }) {
    final roleAccessController = Get.find<RolesAccessController>();

    if (incidentScopeController.scopeIsSelected.value && incidentScopeController.selectedCategoryType == IncidentScopeType.session && incidentScopeController.selectedSession != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: NewCardDesign(
          appBorders: appBorders,
          appIcons: appIcons,
          palette: palette,
          onTap: () {
            createIncidentController.isExpanded(true);
            FocusScope.of(context).unfocus();
          },
          cardModel: incidentScopeController.selectedSession!,
          capacityIndicators: capacityIndicators,
          isDark: isDark,
        ),
      );
    }
    else if (incidentScopeController.scopeIsSelected.value && incidentScopeController.selectedCategoryType == IncidentScopeType.venue && incidentScopeController.selectedVenue != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: NewCardDesign(
            appBorders: appBorders,
            appIcons: appIcons,
            palette: palette,
            onTap: () {
              createIncidentController.isExpanded(true);
              FocusScope.of(context).unfocus();
              // navigateToStatisticsView(statisticsModel:  incidentScopeController.selectedVenue!, statisticsType: StatisticsTypeEnum.venues, context: context);
            },
            cardModel: incidentScopeController.selectedVenue!,
            capacityIndicators: capacityIndicators,
            isDark: isDark,
        ),
      );
    }
    else if (incidentScopeController.scopeIsSelected.value && incidentScopeController.selectedCategoryType == IncidentScopeType.attendee && incidentScopeController.selectedAttendee != null&&roleAccessController.hasRoleAccess(roleKey:  RoleAccessKey.attendeesAccess,)) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appBorders.xSmall),
          border: Border.all(color: palette.themeColorsBorderNeutral11),
          color: palette.themeColorsSurfaceElevationRaised,
        ),
        child: SimpleUserCardWithTitle(
          palette: palette,
          firstName: incidentScopeController.selectedAttendee!.firstName,
          lastName: incidentScopeController.selectedAttendee!.lastName,
          image: incidentScopeController.selectedAttendee!.avatar,
          title: '',
          imageHeight: 32,
          imageWidth: 32,
          nameTextStyle: defaultTextStyle(14, color: palette.themeColorsTextTitle, context: context),
          loadingSpinner: isDark ? AppImages.loadingSpinnerDark : AppImages.loadingSpinnerLight,
          userPlaceHolderImage: AppImages.guestPlaceholderImage,
          loadingSpinnerFile: isDark
              ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
              : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight,
          userPlaceholderImageFile: AppImages.placeholderImage,
        ),
      );
    }
    else if (incidentScopeController.scopeIsSelected.value && incidentScopeController.selectedCategoryType == IncidentScopeType.other) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          padding:const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(appBorders.xSmall),
            border: Border.all(color: palette.themeColorsBorderNeutral11,width: 1),
            color:palette.themeColorsSurfaceElevationRaised,
          ),
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width:24,height:24,child: Center(child: Icon(incidentsModuleAppIcons.circleQuestionIcon,color: palette.themeColorsTextBody,size:18))),
              8.gap,
              Text(key_other.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: palette.themeColorsTextBody),overflow: TextOverflow.ellipsis,),
            ],
          ),
        )
      );
    }
    else {
      return ButtonWithOptionalLeadingAndTrailingWidgets(
        text: selectItemTextKey.tr,
        trailing: ButtonTrailingIconWidget(icon: appIcons.plusIcon),
        onTap: () {
          if(incidentScopeController.venues.isEmpty && incidentScopeController.sessions.isEmpty && incidentScopeController.attendees.isEmpty) {
            createIncidentController.isExpanded(false);
          }
          FocusScope.of(context).unfocus();
          showScopeBottomSheet(context: context, palette: palette, createIncidentController: createIncidentController, isDark: isDark);
        },
      );
    }
  }
}
