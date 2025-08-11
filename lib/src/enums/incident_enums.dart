// import 'package:flutter/material.dart';
// import 'package:blink_component/blink_component.dart';
// import 'package:get/get.dart';
//
// enum SeverityLevel {
//   severe,
//   moderate,
//   low,
// }
//
// extension IncidentSeverityLevel on SeverityLevel {
//   String get getDisplayName {
//     switch (this) {
//       case SeverityLevel.severe:
//         return severeTextKey.tr;
//       case SeverityLevel.moderate:
//         return moderateTextKey.tr;
//       case SeverityLevel.low:
//         return lowTextKey.tr;
//     }
//   }
//
//   IconData getIconData(AppIcons appIcons) {
//     switch (this) {
//       case SeverityLevel.severe:
//         return appIcons.chevronsUp;
//       case SeverityLevel.moderate:
//         return appIcons.equal;
//       case SeverityLevel.low:
//         return appIcons.chevronsDown;
//     }
//   }
//
//   Color getIconColor(MyColorsPalette palette) {
//     switch (this) {
//       case SeverityLevel.severe:
//         return palette.themeColorsDangerDefault;
//       case SeverityLevel.moderate:
//         return palette.themeColorsWarningDefault;
//       case SeverityLevel.low:
//         return palette.componentColorsCheckRadioInactiveIcon;
//     }
//   }
// }
//
// enum IncidentStatus {
//   open,
//   closed,
// }
//
// enum IncidentScopeType {
//   session,
//   venue,
//   attendee,
//   other,
// }
//
// extension IncidentScopeTypeAPI on IncidentScopeType {
//   String get getTypeInRequestType {
//     switch (this) {
//       case IncidentScopeType.session:
//         return IncidentScopeType.session.name;
//       case IncidentScopeType.venue:
//         return IncidentScopeType.venue.name;
//       case IncidentScopeType.attendee:
//         return "user";
//       case IncidentScopeType.other:
//         return "other";
//     }
//   }
// }
//
// enum IncidentSeverity {
//   severe,
//   moderate,
//   low,
// }
//
// extension IncidentSeverityExtension on IncidentSeverity {
//   String get getName {
//     switch (this) {
//       case IncidentSeverity.severe:
//         return severeTextKey.tr;
//       case IncidentSeverity.moderate:
//         return moderateTextKey.tr;
//       case IncidentSeverity.low:
//         return lowTextKey.tr;
//     }
//   }
//
//   IconData getIcon(AppIcons appIcons) {
//     switch (this) {
//       case IncidentSeverity.severe:
//         return appIcons.chevronsUpIcon;
//       case IncidentSeverity.moderate:
//         return appIcons.equalsIcon;
//       case IncidentSeverity.low:
//         return appIcons.chevronsDown;
//     }
//   }
//
//   Color getIconColor(MyColorsPalette palette) {
//     switch (this) {
//       case IncidentSeverity.severe:
//         return palette.themeColorsDangerDefault;
//       case IncidentSeverity.moderate:
//         return palette.themeColorsWarningDefault;
//       case IncidentSeverity.low:
//         return palette.componentColorsCheckRadioInactiveIcon;
//     }
//   }
//
//   Color getFgColor(MyColorsPalette palette) {
//     switch (this) {
//       case IncidentSeverity.severe:
//         return palette.themeColorsDangerCardFg;
//       case IncidentSeverity.moderate:
//         return palette.themeColorsWarningCardFg;
//       case IncidentSeverity.low:
//         return palette.themeColorsNeutralCardFg;
//     }
//   }
//
//   Color getBgColor(MyColorsPalette palette) {
//     switch (this) {
//       case IncidentSeverity.severe:
//         return palette.themeColorsDangerCardBg;
//       case IncidentSeverity.moderate:
//         return palette.themeColorsWarningCardBg;
//       case IncidentSeverity.low:
//         return palette.themeColorsIconSubdued;
//     }
//   }
// }
//
// extension IncidentStatusExtension on IncidentStatus {
//   String get getName {
//     switch (this) {
//       case IncidentStatus.open:
//         return openTextKey.tr;
//       case IncidentStatus.closed:
//         return resolvedTextKey.tr;
//     }
//   }
//
//   IconData getIcon(AppIcons appIcons) {
//     switch (this) {
//       case IncidentStatus.open:
//         return appIcons.spinnerScale;
//       case IncidentStatus.closed:
//         return appIcons.circleCheckIcon;
//     }
//   }
//
//   Color getIconColor(MyColorsPalette palette) {
//     switch (this) {
//       case IncidentStatus.open:
//         return palette.themeColorsWarningDefault;
//       case IncidentStatus.closed:
//         return palette.themeColorsSuccessDefault;
//     }
//   }
//
//   Color getCardBackgroundColor(MyColorsPalette palette) {
//     switch (this) {
//       case IncidentStatus.open:
//         return palette.themeColorsWarningCardBg;
//       case IncidentStatus.closed:
//         return palette.themeColorsSuccessCardBg;
//     }
//   }
//
//   Color getCardForegroundColor(MyColorsPalette palette) {
//     switch (this) {
//       case IncidentStatus.open:
//         return palette.themeColorsWarningCardFg;
//       case IncidentStatus.closed:
//         return palette.themeColorsSuccessCardFg;
//     }
//   }
//
//   Color getTextColor(MyColorsPalette palette) {
//     switch (this) {
//       case IncidentStatus.open:
//         return palette.componentColorsGdGuestCardHigh;
//       case IncidentStatus.closed:
//         return palette.themeColorsTextTitle;
//     }
//   }
//
//   double getTextSize() {
//     switch (this) {
//       case IncidentStatus.open:
//         return 14;
//       case IncidentStatus.closed:
//         return 12;
//     }
//   }
// }
//
// enum IncidentTabsEnum {
//   all,
//   open,
//   resolved,
// }
//
// extension IncidentTabsName on IncidentTabsEnum {
//   String get getDisplayName {
//     switch (this) {
//       case IncidentTabsEnum.all:
//         return allTextKey.tr;
//       case IncidentTabsEnum.open:
//         return openTextKey.tr;
//       case IncidentTabsEnum.resolved:
//         return resolvedTextKey.tr;
//     }
//   }
//
//   String get getApiKey {
//     switch (this) {
//       case IncidentTabsEnum.all:
//         return "all";
//       case IncidentTabsEnum.open:
//         return "open";
//       case IncidentTabsEnum.resolved:
//         return "resolved";
//     }
//   }
// }
//
// // Helper functions
// IncidentStatus getIncidentStatus(String status) {
//   switch (status.toLowerCase()) {
//     case "open":
//       return IncidentStatus.open;
//     case "resolved":
//       return IncidentStatus.closed;
//     default:
//       return IncidentStatus.open;
//   }
// }
//
// IncidentSeverity getIncidentSeverity(String severity) {
//   switch (severity.toLowerCase()) {
//     case "low":
//       return IncidentSeverity.low;
//     case "moderate":
//       return IncidentSeverity.moderate;
//     case "severe":
//       return IncidentSeverity.severe;
//     default:
//       return IncidentSeverity.low;
//   }
// }
//
// fromStringToIncidentScopeType(String type) {
//   switch (type.toLowerCase()) {
//     case 'session':
//       return IncidentScopeType.session;
//     case 'venue':
//       return IncidentScopeType.venue;
//     case 'attendee':
//     case 'user':
//       return IncidentScopeType.attendee;
//     case 'other':
//       return IncidentScopeType.other;
//   }
// }