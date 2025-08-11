import 'package:blink_component/blink_component.dart';
import 'package:blink_component/enum/incident_enums.dart';
import 'package:flutter/material.dart';

import '../../incident_manager.dart';
import '../controllers/create_incident_controller.dart';

class SeverityLevelBottomSheetBody extends StatelessWidget {
  final MyColorsPalette palette;
  final CreateIncidentController controller;

  const SeverityLevelBottomSheetBody({
    super.key,
    required this.controller,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final AppIcons appIcons = incidentsModuleAppIcons;
    final AppBorders appBorders = incidentsModuleAppBorders;

    return ListView.separated(
      itemBuilder: (_, index) {
        final severityLevel = SeverityLevel.values[index];
        return CustomInkWell(
          onTap: () async {
            controller.updateSeverity(severityLevel.getDisplayName);
            Navigator.pop(context);
            FocusScope.of(context).unfocus();
            // showScopeBottomSheet(
            //     context: context,
            //     palette: palette,
            //     createIncidentController: controller);
          },
          child: SeverityBottomSheetComponent(
            title: severityLevel.getDisplayName,
            icon: severityLevel.getIconData(appIcons),
            iconColor: severityLevel.getIconColor(palette),
            palette: palette,
            isSelected: severityLevel.name == controller.selectedSeverity?.name,
            smallBorderRadius: appBorders.small,
            appIcons: appIcons,
          ),
        );
      },
      separatorBuilder: (_, index) => 12.gap,
      itemCount: SeverityLevel.values.length,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}



class SeverityBottomSheetComponent extends StatelessWidget {
  final MyColorsPalette palette;
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final double smallBorderRadius;
  final AppIcons appIcons;
  const SeverityBottomSheetComponent({super.key, required this.title, required this.icon, required this.palette, required this.iconColor, required this.isSelected, required this.smallBorderRadius, required this.appIcons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallBorderRadius),
        color:isSelected?palette.themeColorsNeutralCardBg:Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: getPaletteColor(palette.themeColorsTextTitle), fontSize: 14,fontWeight: FontWeight.w400),),
          if(isSelected)...[
            12.gap,
            Icon(appIcons.circleDot, color: palette.themeColorsActionPrimaryDefaultBg, size: 16,),
          ]

        ],
      ),
    );
  }
}
