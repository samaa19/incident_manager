import 'package:blink_component/blink_component.dart';
import 'package:blink_component/models/capacity_indicator.dart';
import 'package:blink_component/models/incident/incident_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../incident_manager.dart' show IncidentsStatisticsAndListController;
import '../config/assets.dart';
import '../screens/incidents_statistics_and_list_screen.dart';
import '../services/incidents_api_repository.dart';
import '../state_management/incidents_statistics_state_management.dart';

class IncidentDetailsController extends GetxController{

  final showUpdateStatusLoading = false.obs;
  final errorMessage = ''.obs;

  // --get incident details
  final showLoading = false.obs;
  IncidentModel? incidentModel;

  updateStatisticsMainScreenData(BuildContext context) async {
    await Get.find<IncidentsStatisticsAndListController>().refreshScreen();
  }

  Future<void> getIncidentDetails({required int incidentId, required MyColorsPalette palette, required BuildContext context}) async {
    showLoading(true);

    try {
      final result = await IncidentsApiRepository().getIncidentDetails(incidentId: incidentId);

      result.fold(
            (l) {
          MyLogger("get Incident details error $l");
          ShowDialog.showErrorDialogNewDesignV2(
            width: double.infinity,
            errorImageIcon: AppImages.warningImage,
            title: incidentNotFoundTextKey.tr,
            description: tryToAccessNonExistingIncidentTextKey.tr,
            cancelButtonText: key_close.tr,
            confirmButtonText: leaveTextKey.tr,
            withOnlyCancel: true,
            context: Get.context!,
            cancelFunction: () {
              Get.back();
            },
          );
        },
            (r) {
          incidentModel = r;
          showLoading(false);
        },
      );
    } catch (error) {
      showCustomSnackBar(
        context: context,
        message: errorHappenTextKey,
        snackBarType: SnackBarType.error,
        margin: snackBarDefaultMargin,
      );
    }

  }

  Future<void> updateIncidentStatus({
    required int incidentId,
    required IncidentStatus incidentStatus,
    required MyColorsPalette palette,
    required Function() onUpdateIncidentStatus,
    required BuildContext context,
    required String loadingLottieFile,
    required String loadingSpinner,
  }) async {
    if (showUpdateStatusLoading.isTrue) {
      return;
    }

    // bool isConnected = await InternetConnection().hasInternetAccess;

    // if(!isConnected){
    //   showCustomSnackBar(
    //     context: context,
    //     margin: snackBarAboveFloatingButtonMargin,
    //     message: '${incidentStatus == IncidentStatus.open ?unableResolveIncidentTextKey.tr:unableReopenIncidentTextKey.tr} ${checkConnectionAndTryAgainTextKey.tr}',
    //     snackBarType: SnackBarType.error,
    //   );
    //   return ;
    // }

    showUpdateStatusLoading(true);
    errorMessage('');
    update();

    ShowDialog.showNewLoadingDialog(
      context: context,
      palette: palette,
      canDismiss: false,
      loadingSpinner: loadingSpinner,
      loadingLottieFile: loadingLottieFile,
    );

    try {
      final result = await IncidentsApiRepository().updateIncidentStatus(
        incidentId: incidentId,
        incidentStatus: incidentStatus == IncidentStatus.resolved ? 'open' : 'resolved',
      );

      result.fold(
            (l) {
          errorMessage(l);
          showUpdateStatusLoading(false);
          MyLogger("update Incident error $l");
          Get.back();
          showCustomSnackBar(
            context: context,
            margin: snackBarAboveFloatingButtonMargin,
            message: '${incidentStatus == IncidentStatus.open ?unableResolveIncidentTextKey.tr:unableReopenIncidentTextKey.tr} ${pleaseTryAgainLaterTextKey.tr}',
            snackBarType: SnackBarType.error,
          );
        },
            (r) async {
          errorMessage('');
          onUpdateIncidentStatus();
          showCustomSnackBar(
            margin: snackBarAboveFloatingButtonMargin,
            context: context,
            message: incidentStatus == IncidentStatus.open ? incidentResolvedSuccessfullyTextKey.tr : incidentReopenedSuccessfullyTextKey.tr,
            snackBarType: SnackBarType.success,
          );
        },
      );
    } catch (error, s) {
      errorMessage(errorHappenTextKey);
      Get.back();
      showCustomSnackBar(
        context: context,
        margin:  snackBarAboveFloatingButtonMargin,
        message: '${incidentStatus == IncidentStatus.open ?unableResolveIncidentTextKey.tr:unableReopenIncidentTextKey.tr} ${pleaseTryAgainLaterTextKey.tr}',
        snackBarType: SnackBarType.error,
      );
    }
    showUpdateStatusLoading(false);
    update();
  }

  Future<void> deleteIncident({
    required int incidentId,
    required MyColorsPalette palette,
    required bool isDark,
    required BuildContext context,
    required String loadingLottieFile,
    required String loadingSpinner,
  }) async {
    if(showLoading.isTrue){
      return;
    }

    ShowDialog.showNewLoadingDialog(
      context: context,
      palette: palette,
      canDismiss: false,
      loadingSpinner: loadingSpinner,
      loadingLottieFile: loadingLottieFile,
    );
    final result = await IncidentsApiRepository().deleteIncident(
      incidentId: incidentId,
    );

    result.fold(
          (l) {
        Get.back();
        showCustomSnackBar(
          context: context,
          message: '${unableDeleteIncidentTextKey.tr} ${pleaseTryAgainLaterTextKey.tr}',
          snackBarType: SnackBarType.error,
        );
      },
      (r) async {
        Navigator.of(context).pop();
        await updateStatisticsMainScreenData(context);
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        showCustomSnackBar(
          context: context,
          message: incidentDeletedSuccessfullyTextKey.tr,
          snackBarType: SnackBarType.success,
        );
      },
    );
  }
}