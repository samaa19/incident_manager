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
import 'package:blink_component/controllers/pdf_bottom_sheet_controller.dart';
import 'package:blink_component/models/incident/incident_model.dart';
import 'package:blink_component/widgets/full_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../incident_manager.dart';
import '../config/assets.dart';
import '../controllers/create_incident_controller.dart';
import '../widgets/add_attachement_widget.dart';
import '../widgets/choose_severity_widget.dart';
import '../widgets/select_scope_widget.dart';


class CreateIncidentScreen extends StatefulWidget {
  final IncidentModel? incidentModel;
  final MyColorsPalette palette;
  final bool isDark;

  const CreateIncidentScreen({
    super.key,
    required this.palette,
    required this.isDark,
    this.incidentModel,
  });

  @override
  State<CreateIncidentScreen> createState() => _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends State<CreateIncidentScreen> with TickerProviderStateMixin  {
  final createIncidentController = Get.find<CreateIncidentController>();

  @override
  void initState() {
    Get.find<BottomSheetController>().init(this);
    Get.find<PDFBottomSheetController>().init(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.incidentModel != null) {
        createIncidentController.isEditing(true);
        createIncidentController.setEditIncidentData(widget.incidentModel!);
      } else {
        createIncidentController.isEditing(false);
        createIncidentController.setCreateIncidentData();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyColorsPalette palette = widget.palette;
    final bool isDark = widget.isDark;
    final AppBorders appBorders = incidentsModuleAppBorders;
    final AppIcons appIcons = incidentsModuleAppIcons;
    return GetBuilder<CreateIncidentController>(
      builder: (createIncidentController) {
        return WillPopScope(
          onWillPop: () async {
            if (createIncidentController.checkAnyDataChanged) {
              cancelEnteringData(context: context, palette: palette, isDark: isDark);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            backgroundColor: palette.themeColorsSurfaceElevationSurface,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Scaffold(
                  backgroundColor: palette.themeColorsSurfaceElevationSurface,
                  body: Column(
                    children: [
                    CustomAppBarNewDesignV2(
                      scrollController: createIncidentController.isEditing.value
                          ? createIncidentController.editFlowScrollController
                          : createIncidentController.createFlowScrollController,
                      title: createIncidentController.isEditing.value
                          ? editIncidentTextKey.tr
                          : newIncidentTextKey.tr,
                      palette: palette,
                      appIcons: appIcons,
                      borderRadius: appBorders.plus,
                      onBack: () =>
                      createIncidentController.checkAnyDataChanged
                          ? cancelEnteringData(
                              context: context,
                              palette: palette,
                              isDark: isDark)
                          : Navigator.pop(context),
                    ),
                    Expanded(
                        child: CustomScrollView(
                          physics:const AlwaysScrollableScrollPhysics(),
                          controller: createIncidentController.isEditing.value
                              ? createIncidentController.editFlowScrollController
                              : createIncidentController.createFlowScrollController,
                         // padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100,top: 24),
                              child: Column(
                                children: [
                                  // --Title TextField
                                  TitledTextField(
                                    controller: createIncidentController.titleTextController,
                                    appIcons: appIcons,
                                    updateObscurePassword: () {},
                                    obscurePassword: false,
                                    isPassword: false,
                                    onChange: (value) {},
                                    borderRadiusXsmall: appBorders.xSmall,
                                    hint: 'Power Outage in Main Hall',
                                    title: key_title.tr,
                                    palette: palette,
                                    isMandatory: true,
                                    autofocus: false,
                                    maxLength: 80,
                                    minLines: 1,
                                    maxLines: 3,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) async {
                                      FocusScope.of(context).unfocus();
                                      showNewAppBottomSheet(
                                          title: severityTextKey.tr,
                                          subtitle: selectSeverityLevelTextKey.tr,
                                          context: context,
                                          child: SeverityLevelBottomSheetBody(
                                            palette: palette,
                                            controller: createIncidentController,
                                          ));
                                    },
                                  ),

                                  // --Severity Level Picker
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: TitleWithMandatoryWidget(
                                          title: severityTextKey.tr,
                                          palette: palette,
                                        ),
                                      ),
                                      CustomInkWell(
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          showNewAppBottomSheet(
                                              title: severityTextKey.tr,
                                              subtitle: selectSeverityLevelTextKey.tr,
                                              context: context,
                                              child: SeverityLevelBottomSheetBody(
                                                palette: palette,
                                                controller: createIncidentController,
                                              ));
                                        },
                                        child: PickerWidget(
                                          appBorders: appBorders,
                                          palette: palette,
                                          icon: '',
                                          customWidget: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              12.gap,
                                              Expanded(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      createIncidentController.severity.isNotEmpty
                                                          ? createIncidentController.severity
                                                          : selectSeverityTextKey.tr,
                                                      style: TextStyle(
                                                        color: createIncidentController.severity.isNotEmpty
                                                            ? getPaletteColor(palette.componentColorsFieldDefaultInputText)
                                                            : getPaletteColor(palette.componentColorsFieldDefaultInputPlaceholder),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    8.gap,
                                                    if (createIncidentController.severity.isNotEmpty &&
                                                        createIncidentController.selectedSeverity != null)
                                                      Icon(
                                                        createIncidentController.selectedSeverity!.getIcon(appIcons),
                                                        color: createIncidentController.selectedSeverity!.getIconColor(palette),
                                                        size: 12,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                appIcons.downwardArrowIcon,
                                                color: getPaletteColor(palette.componentColorsFieldDefaultInputBorder),
                                                size: 18,
                                              ),
                                              12.gap,
                                            ],
                                          ),
                                          text: createIncidentController.severity.isNotEmpty
                                              ? createIncidentController.severity
                                              : selectTextKey.tr,
                                          textColor: createIncidentController.severity.isNotEmpty
                                              ? getPaletteColor(palette.componentColorsFieldDefaultInputText)
                                              : getPaletteColor(palette.componentColorsFieldDefaultInputPlaceholder),
                                          appIcons: appIcons,
                                        ),
                                      ),
                                    ],
                                  ),
                                  20.gap,

                                  //--Scope Picker
                                  SelectScopeWidget(
                                    isDark: isDark,
                                    palette: palette,
                                    appBorders: appBorders,
                                    appIcons: appIcons,
                                    capacityIndicators: capacityIndicators,
                                    createIncidentController: createIncidentController,
                                  ),
                                  20.gap,

                                  // -- Add Attachments
                                  AddIncidentAttachmentsWidget(
                                    controller: createIncidentController,
                                    palette: palette,
                                    isDark: isDark,
                                  ),

                                  // --Description TextField
                                  20.gap,
                                  TitledTextField(
                                    controller: createIncidentController.descriptionTextController,
                                    focusNode: createIncidentController.descriptionFocusNode,
                                    appIcons: appIcons,
                                    updateObscurePassword: () {},
                                    obscurePassword: false,
                                    autofocus: false,
                                    isPassword: false,
                                    onChange: (value) {},
                                    borderRadiusXsmall: appBorders.xSmall,
                                    onFieldSubmitted: (v){
                                      FocusScope.of(context).unfocus();

                                      Future.delayed(const Duration(milliseconds: 100), () {
                                        FocusScope.of(context).unfocus();
                                      });
                                    },
                                    hint: typeDetailsTextKey.tr,
                                    title: key_description.tr,
                                    palette: palette,
                                    minLines: 3,
                                    maxLines: 4,
                                    maxLength: 500,
                                    minCharacters: 3,
                                  ),

                                  48.gap,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                ),


                // --Buttons Shadow
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            getPaletteColor(palette.themeColorsSurfaceNeutralLevel00).withOpacity(0),
                            getPaletteColor(palette.themeColorsSurfaceNeutralLevel00),
                            getPaletteColor(palette.themeColorsSurfaceNeutralLevel00),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // --Bottom Buttons
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: TertiaryAndPrimaryLoadingButtons(
                  tertiaryButtonTitle: cancelTextKey.tr,
                  primaryButtonTitle: createIncidentController.isEditing.value
                      ? key_update.tr
                      : saveTextKey.tr,
                  primaryButtonController: createIncidentController.createButtonController,
                  fontSize: 15,
                  onTertiaryButtonTapped: () {
                    FocusScope.of(context).unfocus();
                    createIncidentController.checkAnyDataChanged ? cancelEnteringData(context: context, palette: palette, isDark: isDark) : Navigator.pop(context);
                  },
                  onPrimaryButtonTapped:
                      createIncidentController.checkRequiredData
                          ? () {
                              FocusScope.of(context).unfocus();
                              if (createIncidentController.isEditing.value) {
                                createIncidentController.updateIncident(
                                    context: context,
                                    palette: palette,
                                    errorImage: AppImages.errorImage,
                                );
                              } else {
                                createIncidentController.createIncident(
                                  context: context,
                                  palette: palette,
                                  isDark: isDark,
                                );
                              }
                            }
                          : null,
                ),
              ),

              if(createIncidentController.showLoading.value)
                  Positioned.fill(
                  child: FullLoadingWidget(
                    palette: palette,
                    loadingSpinner: isDark ? AppImages.loadingSpinnerDark : AppImages.loadingSpinnerLight,
                    loadingLottieFile: widget.isDark
                        ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
                        : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight ?? '',                    spinnerWidth: incidentsModuleFlavorConfig?.spinnerWidth ?? 70,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}


void cancelEnteringData({
  required BuildContext context,
  required MyColorsPalette palette,
  required bool isDark,
}) {
  ShowDialog.showErrorDialogNewDesignV2(
    width: double.infinity,
    context: Get.context ?? context,
    title: leaveThisPageTextKey.tr,
    description: progressWillLostTextKey.tr,
    cancelButtonText: cancelTextKey.tr,
    confirmButtonText: leaveTextKey.tr,
    isConfirmButtonDanger: true,
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
    errorImageIcon: AppImages.errorImage,
    cancelFunction: () {},
    confirmFunction: () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
}
