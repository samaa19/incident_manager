// class CreateIncidentScopeNamesModel {
//   CreateIncidentScopeNamesModel({
//     this.error = '',
//     required this.scopeTypes,
//   });
//
//   final String error;
//   List<String> scopeTypes;
//
//   factory CreateIncidentScopeNamesModel.fromJson(dynamic json) {
//     return CreateIncidentScopeNamesModel(
//       error     : json['error'] ?? "",
//       scopeTypes: [json['session'] ?? '',json['venue'] ?? '',  json['attendee'] ?? '', json['other'] ?? ''],
//     );
//   }
//
// }