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
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../config/api_constants.dart';

part 'incidents_rest_client.g.dart';

@RestApi()
abstract class IncidentsRestClient {
  factory IncidentsRestClient(Dio dio, {String baseUrl}) = _IncidentsRestClient;

  @GET(incidentsChartDetailsURL)
  Future<OrganizerStatisticsModel> getIncidentsChartDetails();

  @GET(incidentsStatisticsURL)
  Future<dynamic> getIncidentsStatistics();

  @GET(incidentsListURL)
  Future<dynamic> getIncidentsList({
    @Path('version') String version = defaultApiVersion,
    @Query('search') String search = '',
    @Query('offset') int offset = 0,
    @Query('limit') int limit = apiPageSize,
    @Body() required String body,
  });

  @GET('$incidentsListURL/{incidentId}')
  Future<dynamic> getIncidentDetails({
    @Path('incidentId') required int incidentId,
  });
}
