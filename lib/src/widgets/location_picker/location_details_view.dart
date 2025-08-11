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
import 'package:blink_component/controllers/bottom_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/assets.dart';
import '../../controllers/create_incident_controller.dart';
import '../../controllers/incident_scope_controller.dart';
import 'bottom_sheet_container.dart';

class EnterLocationDetailsView extends StatelessWidget {
  final bool isDark;
  final AppBorders appBorders;
  final AppIcons appIcons;
  final IncidentScopeController incidentScopeController;
  final CreateIncidentController createIncidentController;
  final MyColorsPalette palette;

  const EnterLocationDetailsView({
    super.key,
    required this.isDark,
    required this.appBorders,
    required this.incidentScopeController,
    required this.palette,
    required this.appIcons,
    required this.createIncidentController,
  });

  @override
  Widget build(BuildContext context) {
    BottomSheetController bottomSheetController = Get.find<BottomSheetController>();

    return GetBuilder<IncidentScopeController>(
        builder: (incidentScopeController) {
          return BottomSheetContainer(title:incidentLocationTextKey.tr,palette: palette, appBorders: appBorders, appIcons: appIcons, onBack: (){
            if (incidentScopeController.isLocationBottomSheetExpanded.value) {
              incidentScopeController.isLocationBottomSheetExpanded(false);
            } else {
              Get.back();
            }
          },onWillPop: () async {
            if (incidentScopeController.isLocationBottomSheetExpanded.value) {
              incidentScopeController.isLocationBottomSheetExpanded(false);
              return false;
            } else {
              return true;
            }
          },
            withActionButton: true,
            buttonActionText: saveTextKey,
            enableActionButton: true,
            buttonAction: (){
              incidentScopeController.confirmSelectedLocation();
              Get.back();
              FocusScope.of(Get.context ?? context).unfocus();

              // FocusScope.of(Get.context??context).requestFocus(createIncidentController.descriptionFocusNode);
            },
            child:  GestureDetector(
            onPanUpdate: (details) =>bottomSheetController.onPanUpdate(details,context),
            onPanEnd: (details) => bottomSheetController.onPanEnd(details,context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(color:palette.themeColorsBorderNeutral09,height: 1,width: double.infinity,),
                  16.gap,
                  Text(locationTextKey.tr,style: TextStyle(color: palette.themeColorsTextTitle,fontWeight: FontWeight.w700,fontSize: 16),),
                  10.gap,

                  LocationDetailsWithMapAndIcon(
                    palette: palette,
                    appBorders: appBorders,
                    mapImage: isDark ? AppImages.mapAddressIconDark : AppImages.mapAddressIconLight,
                    margin: EdgeInsets.zero,
                    title: incidentScopeController.selectedLocation?.stopTitle ?? '',
                    address: incidentScopeController.selectedLocation?.address ?? '',
                    lat: incidentScopeController.selectedLocation?.lat ?? '',
                    lng: incidentScopeController.selectedLocation?.lng ?? '',
                    icon:appIcons.editPenIcon,
                    borderColor: palette.themeColorsBorderNeutral11,
                    onIconTapped: () async {
                      incidentScopeController.isLocationBottomSheetExpanded(false);
                    },

                  ),
                  16.gap,
                  TitledTextField(
                    controller: incidentScopeController.addressDetailsTextController,
                    appIcons: appIcons,
                    updateObscurePassword: () {},
                    obscurePassword: false,
                    isPassword: false,
                    onChange: (value) {
                      incidentScopeController.addressDetailsTextController.text = value;
                    },
                    borderRadiusXsmall:
                    appBorders.xSmall,//Location Details
                    hint: typeDetailsTextKey.tr,
                    title: locationDetailsTextKey.tr,
                    minLines: 3,
                    palette: palette,
                    maxLines: 3,
                    maxLength: 120,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            ),
          ),
          );
        }
    );

  }
}
