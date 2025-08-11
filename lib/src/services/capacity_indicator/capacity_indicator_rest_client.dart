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

import '../../../incident_manager.dart';

part 'capacity_indicator_rest_client.g.dart';

@RestApi(baseUrl: '')
abstract class CapacityIndicatorRestClient {
  factory CapacityIndicatorRestClient(Dio dio, {
    String baseUrl,
  }) = _CapacityIndicatorRestClient;

  @GET('$capacityIndicatorsUrl')
  Future<dynamic> getCapacityIndicators({
    @DioOptions() Options? options,
  });
}