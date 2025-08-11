import 'package:blink_component/blink_component.dart';
import 'package:blink_component/models/capacity_indicator.dart';
import 'package:blink_component/models/incident/incident_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incident_manager/src/controllers/incident_details_controller.dart';

import '../../incident_manager.dart';
import '../config/assets.dart';
import '../screens/incident_details_screen.dart';

void updateIncidentStatus(
    {required BuildContext context,
      required MyColorsPalette palette,
      required bool isDark,required IncidentDetailsController controller,required int incidentId,required IncidentStatus incidentStatus,required Function() onUpdateIncidentStatus}) {
  ShowDialog.showNewQuestionDialog(
    context: context,
    title: incidentStatus == IncidentStatus.resolved ? confirmReopeningTextKey : confirmResolutionTextKey,
    text: incidentStatus == IncidentStatus.resolved ? sureReopenIncidentTextKey.tr : sureMarkIncidentResolvedTextKey.tr,
    insetPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    buttonFunction: () async {
      Navigator.pop(context);
      controller.updateIncidentStatus(
          incidentId: incidentId,
          incidentStatus: incidentStatus,
          palette: palette,
          onUpdateIncidentStatus: onUpdateIncidentStatus,
          context: context,
        loadingSpinner: isDark ? AppImages.loadingSpinnerDark :AppImages.loadingSpinnerLight,
        loadingLottieFile: isDark
            ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
            : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight ?? '',
      );
    },
    buttonText:incidentStatus==IncidentStatus.resolved? keyReopen.tr:resolveTextKey.tr,
    buttonColor:palette.themeColorsActionPrimaryDefaultBg ,
    buttonTextColor:palette.themeColorsActionPrimaryDefaultFg ,
    cancelButtonText: cancelTextKey.tr,
    longText: true,
    textAlign: TextAlign.center,
    alignment: Alignment.center,
  );
}


void deleteIncident({required BuildContext context , required MyColorsPalette palette, required bool isDark, required Function() deleteIncident}) {
  ShowDialog.showNewQuestionDialog(
    context: context,
    title:confirmDeletionTextKey,
    text: sureDeleteIncidentTextKey.tr,
    insetPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
    buttonFunction: () async {
      Navigator.pop(context);
      deleteIncident();
    },
    buttonText: deleteTextKey.tr,
    buttonColor: palette.themeColorsActionDangerDefaultBg ,
    buttonTextColor:palette.themeColorsActionDangerDefaultFg ,
    cancelButtonText: cancelTextKey.tr,
    longText: true,
    textAlign: TextAlign.center,
    alignment: Alignment.center,
  );

}


void navigateToIncidentDetails({
  required MyColorsPalette palette,
  required bool isDark,
  required BuildContext context,
  required int incidentId,
  isCreationFlow = false,
}) {
  Get.find<IncidentDetailsController>().getIncidentDetails(
    palette: palette,
    incidentId: incidentId,
    context: context,
  );
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => IncidentDetailsScreen(
        isDark: isDark,
        palette: palette,
        isCreationFlow: isCreationFlow,
      ),
    ),
  );
}