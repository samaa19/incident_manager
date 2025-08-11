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


class BottomSheetContainer extends StatelessWidget {
  final MyColorsPalette palette;
  final Widget child;
  final AppBorders appBorders;
  final AppIcons appIcons;
  final Function() onBack;
  final WillPopCallback? onWillPop;
  final String title;
  final String buttonActionText;
  final bool withActionButton;
  final bool enableActionButton;
  final VoidCallback? buttonAction;

  const BottomSheetContainer({super.key, required this.palette, required this.child, required this.appBorders, required this.appIcons, required this.onBack, this.onWillPop, required this.title,  this.buttonActionText=key_intro_next,  this.withActionButton=false,  this.enableActionButton=false,  this.buttonAction});

  @override
  Widget build(BuildContext context) {
    BottomSheetController bottomSheetController = Get.find<BottomSheetController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: getPaletteColor(palette.themeColorsSurfaceElevationRaised),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(appBorders.large),
        ),
        border: Border(
          top: BorderSide(
            color: getPaletteColor(palette.themeColorsBorderNeutral11), // color of the border
            width: 1.0, // width of the border
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onPanUpdate: (details) =>bottomSheetController.onPanUpdate(details,context),
            onPanEnd: (details) => bottomSheetController.onPanEnd(details,context),
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            height: 6,
                            width: 53,
                            decoration: BoxDecoration(
                              color: getPaletteColor(palette.themeColorsSurfaceNeutralLevel05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.gap,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        CustomInkWell(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(end: 6,top: 6,bottom: 6),
                            child: Icon(appIcons.arrowBack, color: getPaletteColor(palette.themeColorsIconNeutral), size: 16),
                          ),
                          onTap: () {
                            onBack();
                          },
                        ),
                        4.gap,
                        Expanded(
                          child: Text(title,
                            style: TextStyle(
                              fontSize: 16,
                              color: getPaletteColor(palette.themeColorsTextTitle),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        8.gap,
                        CustomInkWell(
                            onTap:buttonAction?? () {},
                            child: Container(
                              color: Colors.transparent,
                              constraints: const BoxConstraints(
                                minWidth: 63,
                                minHeight: 36,
                              ),
                              child:withActionButton? Center(
                                child: Text(buttonActionText.tr,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: enableActionButton
                                            ? palette.themeColorsActionGhostDefaultFg
                                            : palette
                                            .themeColorsActionGhostDisabledFg)),
                              ):null,
                            )),
                      ],
                    ),
                  ),
                  12.gap,
                ],
              ),
            ),
          ),
          WillPopScope(
            onWillPop: onWillPop,
            child:  Expanded(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
