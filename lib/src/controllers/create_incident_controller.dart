/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/

import 'dart:io';

import 'package:blink_component/blink_component.dart';
import 'package:blink_component/models/capacity_indicator.dart';
import 'package:blink_component/models/incident/create_incident_scope_names.dart';
import 'package:blink_component/models/incident/incident_model.dart';
import 'package:blink_component/models/updates/update_attachment_model.dart';
import 'package:blink_component/utils.dart';
import 'package:blink_component/utils/upload_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../incident_manager.dart';
import '../config/assets.dart';
import '../utils/helpers_functions.dart';
import 'incident_details_controller.dart';
import 'incident_scope_controller.dart';

class CreateIncidentController extends GetxController {

  final incidentScopeController = Get.find<IncidentScopeController>();

  // -- Text Controllers
  final TextEditingController titleTextController = TextEditingController(text: '');
  final TextEditingController descriptionTextController = TextEditingController(text: '');
  final FocusNode descriptionFocusNode = FocusNode();

  // -- Button Controllers
  final RoundedLoadingButtonController createButtonController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController cancelButtonController = RoundedLoadingButtonController();

  // -- Incident Data
  String severity = '';
  IncidentSeverity? selectedSeverity;

  // -- Scope Bottom Sheet
  final isExpanded = false.obs;

  // -- Attachments
  final selectedAttachments = <UpdateAttachmentModel>[].obs;


  // -- Loading
  final showLoading = false.obs;
  final errorMessage = ''.obs;

  // -- Edit Incident Logic
  final isEditing = false.obs;
  IncidentModel? incidentModel;


  // -- Arguments
  String? statisticsControllerTag;



  late ScrollController createFlowScrollController;
  late ScrollController editFlowScrollController;

  @override
  void onInit() {
    super.onInit();
    createFlowScrollController = ScrollController();
    editFlowScrollController = ScrollController();
    // if(Get.arguments?[0] != null && Get.arguments[0] is String) {
    //   statisticsControllerTag = Get.arguments[0];
    // }
    // if(Get.arguments?[1] != null && Get.arguments[1] is IncidentModel) {
    //   isEditing(true);
    //   setEditIncidentData(Get.arguments[1] as IncidentModel);
    // }
    // if(Get.arguments!=null&&Get.arguments!.length>=3&&Get.arguments?[2] != null && Get.arguments[2] is bool) {
    //   _openFromHome=Get.arguments[2];
    // }else{
    //   _openFromHome=false;
    // }
  }

  @override
  void onClose() {
    titleTextController.dispose();
    descriptionTextController.dispose();
    descriptionFocusNode.dispose();
    createFlowScrollController.dispose();
    editFlowScrollController.dispose();
    super.onClose();
  }

  // -- Check Required Data
  bool get checkRequiredData {
    return titleTextController.text.isNotEmpty && severity.isNotEmpty && ((descriptionTextController.text.isNotEmpty && descriptionTextController.text.length > 3)|| descriptionTextController.text.isEmpty) && incidentScopeController.scopeIsSelected.value;
  }

  // -- Check if there is any change (for cancel)
  bool get checkAnyDataChanged {
    return titleTextController.text.isNotEmpty ||  severity.isNotEmpty || descriptionTextController.text.isNotEmpty || incidentScopeController.scopeIsSelected.value || selectedAttachments.isNotEmpty || incidentScopeController.scopeIsSelected.value;
  }

  // -- Check if the attachment button is enabled
  bool get selectAttachmentButtonStatus {
    return selectedAttachments.length >= 5;
  }

  // -- Get Severity Level
  updateSeverity(String value) {
    severity = value;
    selectedSeverity = getIncidentSeverity(severity);
    update();
  }

  // -- Edit Incident Logic
  setEditIncidentData(IncidentModel incident) {
    incidentModel = incident;
    titleTextController.text = incident.title;
    descriptionTextController.text = incident.description;
    severity = incident.severity.name.capitalizeFirsForAll;
    selectedSeverity = getIncidentSeverity(severity);
    if(fromStringToIncidentScopeType(incidentModel?.scope ?? '') == IncidentScopeType.venue) {
      incidentScopeController.scopeIsSelected(true);
      incidentScopeController.selectedVenue = incidentModel?.scopeDetails;
      incidentScopeController.selectedCategoryType = IncidentScopeType.venue;
    } else if (fromStringToIncidentScopeType(incidentModel?.scope ?? '') == IncidentScopeType.session) {
      incidentScopeController.scopeIsSelected(true);
      incidentScopeController.selectedSession = incidentModel?.scopeDetails;
      incidentScopeController.selectedCategoryType = IncidentScopeType.session;
    } else if (fromStringToIncidentScopeType(incidentModel?.scope ?? '') == IncidentScopeType.attendee) {
      incidentScopeController.scopeIsSelected(true);
      incidentScopeController.selectedAttendee = incidentModel?.scopeDetails;
      incidentScopeController.selectedCategoryType = IncidentScopeType.attendee;
      incidentScopeController.confirmedLocation(incidentModel?.location);
      incidentScopeController.confirmedAddressDetailsTextController.text=incidentModel?.location?.locationDetails??"";
    } else if (fromStringToIncidentScopeType(incidentModel?.scope ?? '') == IncidentScopeType.other) {
      incidentScopeController.scopeIsSelected(true);
      incidentScopeController.confirmedLocation(incidentModel?.location);
      incidentScopeController.confirmedAddressDetailsTextController.text=incidentModel?.location?.locationDetails??"";
      //  incidentScopeController.confirmedLocation = incidentModel?.scopeDetails;
      incidentScopeController.selectedCategoryType = IncidentScopeType.other;
    }
    if(incident.attachmentObjects.isNotEmpty) {
      selectedAttachments.addAll(incident.attachmentObjects);
    }
    update();
  }

  setCreateIncidentData() {
    incidentModel = null;
    titleTextController.text = '';
    descriptionTextController.text = '';
    severity = '';
    selectedSeverity = getIncidentSeverity(severity);
    selectedAttachments.clear();
    isExpanded(false);
    incidentScopeController.scopeIsSelected(false);
    incidentScopeController.tempScopeDetails = null;
    incidentScopeController.selectedScopeDetails = null;
    incidentScopeController.tempSelectedAttendee = null;
    incidentScopeController.tempSelectedSession = null;
    incidentScopeController.tempSelectedVenue = null;
    incidentScopeController.selectedSession = null;
    incidentScopeController.selectedVenue = null;
    incidentScopeController.selectedAttendee = null;
    update();
  }

  // -- Attachments Handling
  addAttachment({required BuildContext context, required MyColorsPalette palette, required File file})async{
    if(file.lengthSync()>(1024*1024*5)){
     showCustomSnackBar(
        context: context,
        margin: snackBarPaddingAboveButtons,
        message: maxUploadFileSizeTextKey.tr,
        snackBarType: SnackBarType.error,
      );
      return;
    }
    selectedAttachments.add(UpdateAttachmentModel(name: file.path.split('/').last, path: file.path, size: convertBytes(file.lengthSync()), type: AttachmentType.local));
    update();
  }

  void deleteAttachment(int index){
    selectedAttachments.removeAt(index);
    update();
  }

  // -- Validations before API Calls
  allFieldsValidation(BuildContext context) {
    if(titleTextController.text.isEmpty) {
      showCustomSnackBar(
        context: context,
        message: titleIsRequiredTextKey.tr,
        snackBarType: SnackBarType.error,
        margin: snackBarDefaultMargin,
      );
      return false;
    }

    if(severity.isEmpty) {
      showCustomSnackBar(
        context: context,
        message: severityIsRequiredTextKey.tr,
        snackBarType: SnackBarType.error,
        margin: snackBarDefaultMargin,
      );
      return false;
    }

    if(descriptionTextController.text.isNotEmpty && descriptionTextController.text.length <= 3) {
      showCustomSnackBar(
        context: context,
        message: 'Description must be more than 3 characters',
        snackBarType: SnackBarType.error,
        margin: snackBarDefaultMargin,
      );
      return false;
    }

    if(!incidentScopeController.scopeIsSelected.value) {
      showCustomSnackBar(
        context: context,
        message: scopeIsRequiredTextKey.tr,
        snackBarType: SnackBarType.error,
        margin: snackBarDefaultMargin,
      );
      return false;
    }

    return true;
  }

  // -- Scope Handling
  int recordId = 0;
  getScopeValidation(BuildContext context) {
    if(incidentScopeController.selectedVenue != null) {
      recordId = incidentScopeController.selectedVenue!.id;
    } else if (incidentScopeController.selectedSession != null) {
      recordId = incidentScopeController.selectedSession!.id;
    } else if (incidentScopeController.selectedAttendee != null) {
      recordId = incidentScopeController.selectedAttendee!.id;
    } else if (incidentScopeController.selectedCategoryType == IncidentScopeType.other) {
      recordId = 0;
    }
    else {
      showCustomSnackBar(
        context: context,
        message: scopeIsRequiredTextKey.tr,
        snackBarType: SnackBarType.error,
        margin: snackBarDefaultMargin,
      );
      showLoading(false);
      update();
      return;
    }
  }

  getLocationData() {
    if(incidentScopeController.confirmedLocation.value.lat.isNotEmpty && incidentScopeController.confirmedLocation.value.lng.isNotEmpty) {
      return incidentScopeController.confirmedLocation.value;
    } else {
      return {};
    }
  }

  // -- Update main screen data
  updateStatisticsMainScreenData() async {
    await Get.find<IncidentsStatisticsAndListController>().refreshScreen();
    await BlocProvider.of<IncidentsStatisticsCubit>(Get.context!)
        .getIncidentsStatistics(Get.context!);
  }

  // -- API Calls
  Future<List<Map<String, dynamic>>> updatedAttachments() async {
    List<Map<String,dynamic>> attachments = [];
    if(selectedAttachments.isNotEmpty) {
      for (UpdateAttachmentModel attachment in selectedAttachments) {
        String imageUrl = attachment.type == AttachmentType.remote ? attachment.path : await uploadImageToCloudinary(attachment.path);
        attachments.add({
          "path": attachment.path,
          "file_name": attachment.name,
          "url": imageUrl,
          "file_size": attachment.size,
        });
      }
    }
    return attachments;
  }

  Future<void> createIncident({
    required BuildContext context,
    required MyColorsPalette palette,
    required bool isDark,
  }) async {
    if (showLoading.isTrue) {
      return;
    }
    showLoading(true);
    errorMessage('');
    update();

    // bool isConnected = await InternetConnection().hasInternetAccess;
    // if(!isConnected){
    //   showLoading(false);
    //   errorMessage('');
    //   update();
    //   ShowDialog.showErrorDialogNewDesignV2(
    //     width: double.infinity,
    //     title: failedCreateIncidentTextKey.tr,
    //     description: "${unableCreateIncidentTextKey.tr} ${checkConnectionAndTryAgainTextKey.tr}",
    //     cancelButtonText: key_dismiss.tr,
    //     confirmButtonText: tryAgainTextKey.tr,
    //     context: Get.context!,
    //     confirmFunction: (){
    //       createIncident(context: context, palette: palette, isDark: isDark, assets: assets);
    //       Get.back();
    //     },
    //     cancelFunction: () {
    //     },
    //     errorImageIcon: assets.errorImage,
    //   );
    //   return ;
    // }
    getScopeValidation(context);
    if(!allFieldsValidation(context)) {
      showLoading(false);
      return;
    }

    try{
      List<Map<String,dynamic>> attachments = await updatedAttachments();

      final result = await IncidentsApiRepository().createIncident(
        body: {
          "title": titleTextController.text,
          "description": descriptionTextController.text,
          "severity": severity.toLowerCase(),
          "incidentable_type" : incidentScopeController.selectedCategoryType.getTypeInRequestType.capitalizeFirst,
          "incidentable_id" : recordId,
          "location" : getLocationData(),
          "attachment_objects": attachments
        }
      );

      result.fold(
        (l) {
          errorMessage(l);
          showLoading(false);
          MyLogger("createIncident error $l");
          ShowDialog.showErrorDialogNewDesignV2(
            width: double.infinity,
            title: failedCreateIncidentTextKey.tr,
            description: unableCreateIncidentTryAgainTextKey.tr,
            cancelButtonText: key_dismiss.tr,
            confirmButtonText: tryAgainTextKey.tr,
            context: Get.context!,
            confirmFunction: (){
              createIncident(
                context: context,
                palette: palette,
                isDark: isDark,
              );
              Get.back();
            },
            cancelFunction: () {
            },
            errorImageIcon: AppImages.errorImage,
          );
        },
        (r) async {
          errorMessage('');
          updateStatisticsMainScreenData();
          showCustomSnackBar(
            context: context,
            margin: snackBarPaddingAboveButtons,
            message: incidentCreatedSuccessfullyTextKey.tr,
            snackBarType: SnackBarType.success,
          );

          navigateToIncidentDetails(
            palette: palette,
            isDark: isDark,
            context: context,
            incidentId: r['data'],
            isCreationFlow: true,
          );
        },
      );
    } catch(error,s) {
      errorMessage(DioExceptions.fromDioError(error as DioException).message);
      MyLogger('message in create update $error $s \n ${DioExceptions.fromDioError(error).message}');

      ShowDialog.showErrorDialogNewDesignV2(
        width: double.infinity,
        title: failedCreateIncidentTextKey.tr,
        description: unableCreateIncidentTryAgainTextKey.tr,
        cancelButtonText: key_dismiss.tr,
        confirmButtonText: tryAgainTextKey.tr,
        context: Get.context!,
        confirmFunction: (){
          createIncident(
            context: context,
            palette: palette,
            isDark: isDark,
          );
          Get.back();
        },
        cancelFunction: () {
        },
        errorImageIcon: AppImages.errorImage,
      );
    }
    showLoading(false);
    createButtonController.reset();
    update();
  }

  Future<void> updateIncident({
    required BuildContext context,
    required MyColorsPalette palette,
    required String errorImage,
  }) async {
    if (showLoading.isTrue) {
      return;
    }
    showLoading(true);
    errorMessage('');
    update();
    // bool isConnected = await InternetConnection().hasInternetAccess;
    // if(!isConnected){
    //
    //   showLoading(false);
    //   errorMessage('');
    //   update();
    //   ShowDialog.showErrorDialogNewDesignV2(
    //     width: double.infinity,
    //     errorImageIcon: assets.errorImage,
    //     title: failedEditIncidentTextKey.tr,
    //     description: "${unableEditIncidentTextKey.tr} ${checkConnectionAndTryAgainTextKey.tr}",
    //     cancelButtonText: key_dismiss.tr,
    //     confirmButtonText: tryAgainTextKey.tr,
    //     context: Get.context!,
    //     confirmFunction: (){
    //       updateIncident(context: context, palette: palette, assets: assets);
    //       Get.back();
    //     },
    //     cancelFunction: () {},
    //   );
    //   return ;
    // }


    getScopeValidation(context);
    if(!allFieldsValidation(context)) {
      showLoading(false);
      return;
    }

    try{

     if(incidentModel == null) {
       showCustomSnackBar(
         context: context,
         message: errorHappenTextKey.tr,
         snackBarType: SnackBarType.error,
         margin: snackBarDefaultMargin,
       );
       Get.back();
       return;
     }

     List<Map<String,dynamic>> attachments = await updatedAttachments();

     final result = await IncidentsApiRepository().updateIncident(
        incidentId: incidentModel!.id,
        body: {
          'title': titleTextController.text,
          'description': descriptionTextController.text,
          'severity': severity.toLowerCase(),
          "incidentable_type" : incidentScopeController.selectedCategoryType.getTypeInRequestType.capitalizeFirst,
          'incidentable_id': recordId,
          "location" : getLocationData(),
          "attachment_objects": attachments
        },
      );

      result.fold(
        (l) {
          errorMessage(l);
          showLoading(false);
          MyLogger("update Incident error $l");
          ShowDialog.showErrorDialogNewDesignV2(
            width: double.infinity,
            errorImageIcon: errorImage,
            title: failedEditIncidentTextKey.tr,
            description: unableEditIncidentTryAgainTextKey.tr,
            cancelButtonText: key_dismiss.tr,
            confirmButtonText: tryAgainTextKey.tr,
            context: Get.context!,
            confirmFunction: (){
              updateIncident(context: context, palette: palette, errorImage: errorImage);
              Get.back();
            },
            cancelFunction: () {},
          );
        },
        (r) async {
          errorMessage('');
          updateStatisticsMainScreenData();

          showCustomSnackBar(
            context: context,
            margin: snackBarPaddingAboveButtons,
            message: incidentUpdatedSuccessfullyTextKey.tr,
            snackBarType: SnackBarType.success,
          );

          Get.find<IncidentDetailsController>().getIncidentDetails(incidentId: r['data'], context: context, palette: palette);
          Get.back();
        },
      );
    } catch(error,s) {
      errorMessage(DioExceptions.fromDioError(error as DioException).message);
      MyLogger('message in update incident $error $s \n ${DioExceptions.fromDioError(error).message}');
      ShowDialog.showErrorDialogNewDesignV2(
        width: double.infinity,
        errorImageIcon: errorImage,
        title: failedEditIncidentTextKey.tr,
        description: unableEditIncidentTryAgainTextKey.tr,
        cancelButtonText: key_dismiss.tr,
        confirmButtonText: tryAgainTextKey.tr,
        context: Get.context!,
        confirmFunction: (){
          updateIncident(context: context, palette: palette, errorImage: errorImage);
          Get.back();
        },
        cancelFunction: () {
        },
      );
    }
    showLoading(false);
    createButtonController.reset();
    update();
  }

}
