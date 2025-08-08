/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'dart:convert';

import 'package:blink_component/blink_component.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../incident_manager.dart';
import '../config/incident_manager_config.dart';
import 'incidents_rest_client.dart';

class IncidentsApiRepository {
  late final IncidentsRestClient _restClient;

  IncidentsApiRepository() {
    _restClient = IncidentsRestClient(IncidentManagerConfig.appDio);
  }

  Future<Either<String, OrganizerStatisticsModel>> getIncidentsStatistics() async {
    try {
      final response = await _restClient.getIncidentsChartDetails();
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, PagedDataResponseModel>> getIncidentsList({
    required List<String> types,
    required String search,
    required int offset,
    required int limit,
  }) async {
    try {
      final result = await _restClient.getIncidentsList(
        search: search,
        offset: offset,
        limit: limit,
        body: jsonEncode({"status": types}),
      );

      return Right(
        PagedDataResponseModel.fromJson(result),
      );
    } on DioException catch (e) {
      final result = ApiErrorHandler.handleError(e);
      return Left(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
