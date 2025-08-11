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
import 'package:blink_component/controllers/location_picker_controller.dart';
import 'package:blink_component/widgets/full_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../incident_manager.dart';
import '../../config/assets.dart';


class MyLocationButton extends StatelessWidget {
  final bool isDark;
  final AppIcons appIcons;
  final MyColorsPalette palette;

  const MyLocationButton({
    super.key,
    required this.isDark,
    required this.palette,
    required this.appIcons,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(
      bottom: 20,
      right: 20,
      child: GetBuilder<LocationPickerController>(
          builder: (rideLocationsController) {
            return Material(
              shape: const CircleBorder(),
              elevation: 1,
              color: getPaletteColor(palette.themeColorsActionTertiaryDefaultBg),
              child: CustomInkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  rideLocationsController.getMyLocation();
                },
                child: SizedBox(
                  height: 48,
                  width: 48,
                  //  padding: const EdgeInsets.all(15.0),
                  child: rideLocationsController.gettingLocationLoading
                  ? Padding(
                    padding: EdgeInsets.all(15.0),
                    child: FullLoadingWidget(
                      palette: palette,
                      loadingSpinner: isDark ? AppImages.loadingSpinnerDark : AppImages.loadingSpinnerLight,
                      loadingLottieFile: isDark
                          ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
                          : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight ?? '',
                      spinnerWidth: incidentsModuleFlavorConfig?.spinnerWidth ?? 70,
                    ),
                  ) : Center(child: Icon(appIcons.userLocationIosIcon,color: palette.themeColorsActionTertiaryDefaultFg,size: 25,)),
                ),
              ),
            );
          }),
    );
  }
}

class ConfirmButtonWidget extends StatelessWidget {
  const ConfirmButtonWidget({
    super.key,
    required this.btnController,
    required this.confirmPickUp,
    required this.buttonTitle,
    required this.palette,
    required this.appBorders,
  });

  final VoidCallback confirmPickUp;
  final MyColorsPalette palette;
  final RoundedLoadingButtonController btnController;
  final String buttonTitle;
  final AppBorders appBorders;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 33,
      left: 20,
      right: 20,
      child: GetBuilder<LocationPickerController>(
          builder: (rideLocationsController) {
            final lng =
            double.tryParse(rideLocationsController.destinationLocation.lng);
            return PrimaryRoundedLoadingButton(
              text: buttonTitle,
              height: buttonHeight50,
              controller: btnController,
              onPressed: () => lng != 0 ? confirmPickUp() : null,
            );
          }),
    );
  }
}