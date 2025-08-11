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
import 'package:blink_component/models/incident/create_incident_scope_names.dart';
import 'package:blink_component/models/incident/incident_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../incident_manager.dart';

class IncidentsApiRepository {
  late final IncidentsRestClient _restClient;

  IncidentsApiRepository() {
    _restClient = IncidentsRestClient(IncidentManagerConfig.appDio);
  }

  Future<Either<String, OrganizerStatisticsModel>> getIncidentsChartDetails() async {
    try {
      final response = await _restClient.getIncidentsChartDetails();
      return Right(response);
    } catch (e, s) {

      return Left(e.toString() + s.toString());
    }
  }

  Future<Either<String, AgendaSummaryModel>> getIncidentsStatistics() async {
    try {
      final response = await _restClient.getIncidentsStatistics();
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

  Future<Either<String, IncidentModel>> getIncidentDetails({
    required int incidentId,
  }) async {
    try {
      final result = await _restClient.getIncidentDetails(
        incidentId: incidentId,
      );

      return Right(
        IncidentModel.fromJson(result),
      );
    } on DioException catch (e) {
      final result = ApiErrorHandler.handleError(e);
      return Left(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, dynamic>> updateIncidentStatus({
    required int incidentId,
    required String incidentStatus,
  }) async {
    try {
      return Right(
        await _restClient.updateIncidentStatus(
          incidentId: incidentId,
          body: jsonEncode({
            'status': incidentStatus,
          }),

        ),
      );
    } on DioException catch (e) {
      final result = ApiErrorHandler.handleError(e);
      return Left(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, CreateIncidentScopeNamesModel>> getScopeNames() async {
    try {
      return Right(
        await _restClient.getScopeNames(),
      );
    } on DioException catch (e) {
      final result = ApiErrorHandler.handleError(e);
      return Left(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, PagedDataResponseModel>> getSelectedScopeRecords({
    String search = '',
    int offset = 0,
    int limit = pageSize,
    required String scopeName,
  }) async {
    try {
      return Right(
        await _restClient.getSelectedScopeRecords(
          scopeName: scopeName,
          search: search,
          offset: offset,
          limit: limit,
        ),
      );
    } on DioException catch (e) {
      final result = ApiErrorHandler.handleError(e);
      return Left(result);
    } catch (e) {
      return Left(e.toString());
    }
  }


  Future<Either<String, dynamic>> createIncident({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _restClient.createIncident(
        body: jsonEncode(body),
      );
      return Right(response);
    } on DioException catch (e) {
      final result = ApiErrorHandler.handleError(e);
      return Left(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, dynamic>> updateIncident({
    required int incidentId,
    required dynamic body,
  }) async {
    try {

      return Right(
        await _restClient.updateIncident(
          incidentId: incidentId,
          body: jsonEncode(body),
        ),
      );
    } on DioException catch (e) {
      final result = ApiErrorHandler.handleError(e);
      return Left(result);
    } catch (e) {
      return Left(e.toString());
    }
  }


  Future<Either<String, dynamic>> deleteIncident({
    required int incidentId,
  }) async {
    try {
      return Right(
        await _restClient.deleteIncident(
          incidentId: incidentId,
        ),
      );
    } on DioException catch (e) {
      final result = ApiErrorHandler.handleError(e);
      return Left(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
