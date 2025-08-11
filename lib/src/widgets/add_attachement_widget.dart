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
import 'package:blink_component/utils.dart';
import 'package:blink_component/widgets/add_attachment_bottom_sheet.dart';
import 'package:blink_component/widgets/updates/update_attachment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:incident_manager/incident_manager.dart';

import '../config/assets.dart';
import '../controllers/create_incident_controller.dart';

class AddIncidentAttachmentsWidget extends StatefulWidget {
  final MyColorsPalette palette;
  final bool isDark;
  final CreateIncidentController controller;

  const AddIncidentAttachmentsWidget({
    super.key,
    required this.controller,
    required this.palette,
    required this.isDark,
  });

  @override
  State<AddIncidentAttachmentsWidget> createState() => _AddIncidentAttachmentsWidgetState();
}

class _AddIncidentAttachmentsWidgetState extends State<AddIncidentAttachmentsWidget> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final AppBorders appBorders = incidentsModuleAppBorders;
    final AppIcons appIcons = incidentsModuleAppIcons;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          addAttachmentTextKey.tr,
          style: TextStyle(
            fontSize: 16,
            color: palette.componentColorsFieldDefaultLabelText,
            fontWeight: FontWeight.w700,
          ),
        ),

        8.gap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonWithOptionalLeadingAndTrailingWidgets(
                onTap: () async {
                if (widget.controller.selectAttachmentButtonStatus) {
                  showCustomSnackBar(
                    margin: snackBarPaddingAboveButtons,
                    context: context,
                    message: maximumUploadLimitReachedTextKey.tr,
                    snackBarType: SnackBarType.error,
                  );
                  return;
                }
                Future.delayed(const Duration(milliseconds: 100), () {
                    FocusScope.of(context).unfocus();
                  });
                  showNewAppBottomSheet(
                    title: addAttachmentTextKey.tr,
                    subtitle: attachmentsTypesText,
                    context: context,
                    child: AddAttachmentBottomSheetBody(
                      context: context,
                      appBorders: appBorders,
                      appIcons: appIcons,
                      addAttachmentFromGallery: () async {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          FocusScope.of(context).unfocus();
                        });
                        XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          File file = File(image.path);
                          widget.controller.addAttachment(file: file, context: context, palette: palette);
                        }
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).unfocus();
                            if(image != null){
                              widget.controller.createFlowScrollController.animateTo(widget.controller.createFlowScrollController.position.maxScrollExtent - 100,curve: Curves.linear, duration: const Duration(milliseconds: 500),);
                            }
                          });

                        }
                      },
                      addAttachmentFromCamera: () async {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          FocusScope.of(context).unfocus();
                        });
                        XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          File file = File(image.path);
                          widget.controller.addAttachment(file: file, context: context, palette: palette);
                        }
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).unfocus();
                            if(image != null){
                              widget.controller.createFlowScrollController.animateTo(widget.controller.createFlowScrollController.position.maxScrollExtent - 100,curve: Curves.linear, duration: const Duration(milliseconds: 500),);
                            }
                          });
                        }
                      },
                      addAttachmentFromFiles: () {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          FocusScope.of(context).unfocus();
                        });
                        var pickedFile ;
                        pickFile(
                            onPickFile: (file){
                              pickedFile = file ;
                              widget.controller.addAttachment(file: file, context: context, palette: palette);
                            },
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).unfocus();
                            if(pickedFile != null){
                              widget.controller.createFlowScrollController.animateTo(widget.controller.createFlowScrollController.position.maxScrollExtent - 100,curve: Curves.linear, duration: const Duration(milliseconds: 500),);
                            }
                          });
                        }
                      },
                    ),
                  );
                },
                isDisabled: widget.controller.selectAttachmentButtonStatus,
              text: addAttachmentTextKey.tr,
              trailing: ButtonTrailingIconWidget(
                  icon: appIcons.plusIcon,
                  color: widget.controller.selectAttachmentButtonStatus ? palette.themeColorsTextDisabled : palette.themeColorsActionGhostDefaultFg,
              ),
              leading: ButtonLeadingIconWidget(
                  icon: appIcons.documentsIcon,
                  color: widget.controller.selectAttachmentButtonStatus ? palette.themeColorsTextDisabled : palette.themeColorsTextBody,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child:Text(attachmentsValidationText, style: TextStyle(color: getPaletteColor(palette.componentColorsFieldDefaultDescription),fontWeight: FontWeight.w400,fontSize: 14),),
            )
          ],
        ),
        if (widget.controller.selectedAttachments.isNotEmpty)
          ListView.separated(
            padding: const EdgeInsets.only(top: 12),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => UpdateAttachmentWidget(
              palette: palette,
              updateAttachmentModel: widget.controller.selectedAttachments[index],
              appBorders: appBorders,
              loadingSpinner: widget.isDark ? AppImages.loadingSpinnerDark :AppImages.loadingSpinnerLight,
              loadingSpinnerFile: widget.isDark
                  ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
                  : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight ?? '',
              withDelete: true,
              appIcons: appIcons,
              onDeleteClick: () => deleteAttachment(
                  context: context,
                  palette: palette,
                  isDark: widget.isDark,
                  controller: widget.controller,
                  index: index),
                errorWidget: UnableToOpenAttachmentWidget(
                  fileImage: AppImages.fileImage,
                  backgroundImage: AppImages.errorBackgroundImage,
                ),
            ),
            separatorBuilder: (_, index) => 12.gap,
            itemCount: widget.controller.selectedAttachments.length,
          ),
      ],
    );
  }
}


void deleteAttachment({required BuildContext context, required MyColorsPalette palette, required bool isDark, required CreateIncidentController controller, required int index}) {
  ShowDialog.showNewQuestionDialog(
    context: context,
    longText: true,
    textAlign: TextAlign.center,
    alignment: Alignment.center,
    buttonText: deleteTextKey.tr,
    cancelButtonText: cancelTextKey.tr,
    text: sureDeleteAttachmentTextKey.tr,
    insetPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
    buttonFunction: () async {
      Navigator.pop(context);
      controller.deleteAttachment(index);
    },
  );
}