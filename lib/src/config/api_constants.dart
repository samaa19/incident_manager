/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'package:dio/dio.dart';
import 'package:dio_http_cache_lts/dio_http_cache_lts.dart';


// Home Statistics URLs
const incidentsChartDetailsURL  = '/api/v3/mobile-logistics/home/statistics';
const incidentsStatisticsURL    = '/api/v3/mobile-logistics/home/incidents/stats';
const incidentsListURL          = '/api/v3/mobile-logistics/home/incidents';

// Network Helpers
Options getCacheOptions({Duration? maxAgeDuration}) {
  return buildCacheOptions(
    maxAgeDuration ?? const Duration(days: 2),
    forceRefresh: false,
  );
}
