/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'package:blink_component/controllers/location_picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:incident_manager/incident_manager.dart';


class MapWidget extends StatelessWidget {
  const MapWidget({
    required this.onMapCreated,
    super.key,
  });

  final ValueChanged<GoogleMapController> onMapCreated;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned.fill(
      right: 0,
      left: 0,
      top: 0,
      bottom: 0,
      child: GetBuilder<LocationPickerController>(builder: (locationPickerController) {
        return SizedBox(
          height: size.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(incidentsModuleAppBorders.large),
            child: GoogleMap(
                zoomGesturesEnabled     : true,
                myLocationButtonEnabled : false,
                zoomControlsEnabled     : false,
                initialCameraPosition: locationPickerController.cameraPosition,
                myLocationEnabled: true,
                mapType: MapType.normal,
                onMapCreated: onMapCreated,
                onCameraMove: (CameraPosition cameraPosition) {
                  locationPickerController.updateCameraPosition(
                      cameraPosition.target,
                      context: context,
                      withAnimation: false);
                },
                onCameraIdle: () => locationPickerController.onCameraIdle()),
          ),
        );
      }),
    );
  }
}
