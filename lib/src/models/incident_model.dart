// import 'package:blink_component/blink_component.dart';
// import 'package:blink_component/models/updates/update_attachment_model.dart';
// import '../enums/incident_enums.dart';
//
// class IncidentModel extends CardModel {
//   final int id;
//   final String title;
//   final String description;
//   final String date;
//   final String time;
//   final String scope;
//   final dynamic scopeDetails;
//   final IncidentSeverity severity;
//   final List<UpdateAttachmentModel> attachmentObjects;
//   final StopModel? location;
//   IncidentStatus status;
//
//   IncidentModel({
//     this.id = 0,
//     this.title = "",
//     this.description = "",
//     this.date = "",
//     this.time = "",
//     this.scope = "",
//     this.attachmentObjects = const [],
//     this.scopeDetails,
//     this.severity = IncidentSeverity.low,
//     this.status = IncidentStatus.open,
//     this.location,
//   }) : super(cardModelType: CardType.incident);
//
//   factory IncidentModel.fromJson(Map<String, dynamic> json) => IncidentModel(
//         id: json['id'] as int? ?? 0,
//         title: json['title'] as String? ?? '',
//         description: json['description'] as String? ?? '',
//         date: json['date'] as String? ?? '',
//         time: json['time'] as String? ?? '',
//         scope: json['incidentable_type'] as String? ?? '',
//         scopeDetails: getIncidentScope(json['incidentable_type'] as String? ?? '',
//             json['incidentable_details'] != null ? json['incidentable_details'] as Map<String, dynamic> : {}),
//         attachmentObjects: json['attachment_objects'] != null
//             ? (json['attachment_objects'] as List<dynamic>)
//                 .map((e) => UpdateAttachmentModel.fromJson(e))
//                 .toList()
//             : [],
//         severity: getIncidentSeverity(json['severity'] as String? ?? ''),
//         status: getIncidentStatus(json['status'] as String? ?? ''),
//         location: json['location'] != null && json['location'] != {}
//             ? StopModel.fromJson(json['location'] as Map<String, dynamic>)
//             : null,
//       );
//
//   String get getDisplayDate {
//     DateTime? dateTime = DateTime.tryParse(date);
//     return dateTime != null ? dateFormatMMMDDYYYY.format(dateTime) : date;
//   }
//
//   String get getDisplayTime {
//     dateFormatHHMMA;
//     DateTime? dateTime = DateTime.tryParse("$date $time");
//     return dateTime != null
//         ? (dateTime.isToday
//             ? dateFormatHHMMA.format(dateTime)
//             : dateFormatMMMDDYYYY.format(dateTime))
//         : date;
//   }
//
//   String get getDisplayOnlyTime {
//     DateTime? dateTime = DateTime.tryParse("$date $time");
//     return dateTime != null ? timeAmPmFormatWithSpace.format(dateTime) : time;
//   }
// }
//
// getIncidentScope(String scope, Map<String, dynamic> json) {
//   switch (scope.toLowerCase()) {
//     case 'session':
//       return Session.fromJson(json);
//     case 'venue':
//       return VenueModel.fromJson(json);
//     case 'attendee':
//     case 'user':
//       return GuestModel.fromJson(json);
//     case 'other':
//       return StopModel.fromJson(json);
//     default:
//       return null;
//   }
// }
//
// class IncidentsCardsGroupModel {
//   final String time;
//   final List<IncidentModel> incidents;
//
//   const IncidentsCardsGroupModel(this.time, this.incidents);
// }