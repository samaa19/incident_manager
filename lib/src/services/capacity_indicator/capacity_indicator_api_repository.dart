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
import 'package:blink_component/models/capacity_indicator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../incident_manager.dart';
import 'capacity_indicator_rest_client.dart';

class CapacityIndicatorApiRepository {
  CapacityIndicatorApiRepository() {
    _restClient = CapacityIndicatorRestClient(IncidentManagerConfig.appDio);
  }

  late final CapacityIndicatorRestClient _restClient;

  Future<Either<String, List<CapacityIndicatorModel>>>
      getCapacityIndicators() async {
    try {
      final result = await _restClient.getCapacityIndicators(options: getCacheOptions());
      return Right((result['capacity_indicators'] as List)
          .map((e) => CapacityIndicatorModel.fromJson(e))
          .toList());
    } on DioException catch (e) {
      ApiErrorHandler.handleError(e);
      return Left(DioExceptions.fromDioError(e).message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
