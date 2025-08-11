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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:incident_manager/incident_manager.dart';

import '../controllers/create_incident_controller.dart';
import '../controllers/incident_scope_controller.dart';
import 'location_picker/Pick_location_bottom_sheet_content.dart';
import 'location_picker/location_details_view.dart';

void showPickLocationBottomSheet({
  required BuildContext context,
  required bool isDark,
  required MyColorsPalette palette,
  required CreateIncidentController createIncidentController,
  required Function(StopModel) onPickLocation,
}) {
  BottomSheetController bottomSheetController = Get.find<BottomSheetController>();
  bottomSheetController.controller.forward();
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.none,
      elevation: 0,
      enableDrag: false,    // Disable drag to dismiss
      builder: (context) {
        return AnimatedBuilder(
          animation: bottomSheetController.animation,
          child: GetBuilder<IncidentScopeController>(
              builder: (_) {
                return PickLocationSheetContent(
                  isDark: isDark,
                  palette: palette,
                  appIcons: incidentsModuleAppIcons,
                  appBorders: incidentsModuleAppBorders,
                  onPickLocation:onPickLocation,
                  createIncidentController: createIncidentController,
                  // scrollController: scrollController,
                );
              }
          ),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - bottomSheetController.animation.value) * MediaQuery.of(context).size.height),
              child: child,
            );
          }
        );
      }
  );
}


class PickLocationSheetContent extends StatefulWidget {
  final bool isDark;
  final MyColorsPalette palette;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final CreateIncidentController createIncidentController;
  final Function(StopModel) onPickLocation;

  const PickLocationSheetContent({
    super.key,
    required this.isDark,
    required this.appIcons,
    required this.appBorders,
    required this.createIncidentController,
    required this.onPickLocation, required this.palette,
  });

  @override
  State<PickLocationSheetContent> createState() => _ScopeBottomSheetContentState();
}

class _ScopeBottomSheetContentState extends State<PickLocationSheetContent> {
  final incidentScopeController = Get.find<IncidentScopeController>();
  final createIncidentController = Get.find<CreateIncidentController>();

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      if(!incidentScopeController.isLocationBottomSheetExpanded.value) {
        return PickLocationBottomSheetContent(
          isDark: widget.isDark,
          appIcons: widget.appIcons,
          appBorders: widget.appBorders,
          incidentScopeController: incidentScopeController,
          createIncidentController: widget.createIncidentController,
          onPickLocation: widget.onPickLocation,
          palette: widget.palette,
          startLocation: incidentScopeController.selectedLocation,
        );
      }
      else {
        return EnterLocationDetailsView(
          isDark: widget.isDark,
          appIcons: widget.appIcons,
          appBorders: widget.appBorders,
          createIncidentController: widget.createIncidentController,
          incidentScopeController: incidentScopeController,
          palette: widget.palette,
        );
      }
    });
  }
}





