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
import 'package:flutter/material.dart';

class DestinationMarkerWidget extends StatelessWidget {
  final String address;
  final MyColorsPalette palette;
  final AppBorders appBorders;
  final AppIcons appIcons;
  const DestinationMarkerWidget({super.key, required this.address, required this.palette, required this.appBorders, required this.appIcons});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Icon(appIcons.locationIcon,color: palette.themeColorsActionPrimaryDefaultBg,size: 30,),
          ),
          if(address.isNotEmpty)...[
            20.gap,
            LocationMarkerAddress(address: address, palette: palette, appBorders: appBorders),
          ],
        ],
      ),
    );
  }
}
class LocationMarkerAddress extends StatelessWidget {
  final String address;
  final MyColorsPalette palette;
  final AppBorders appBorders;
  const LocationMarkerAddress({super.key, required this.address, required this.palette, required this.appBorders});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
      decoration: BoxDecoration(
        color: palette.themeColorsSurfaceElevationFloating,
        borderRadius: BorderRadius.circular(appBorders.large),
        border: Border.all(
          color: palette.themeColorsBorderNeutral11,
          width: 1,
        ),
      ),
      child: Text(address,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: palette.themeColorsTextTitle),),
    );
  }
}