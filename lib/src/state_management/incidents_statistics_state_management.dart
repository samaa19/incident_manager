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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/incidents_api_repository.dart';

// Events
abstract class IncidentsStatisticsEvent {}

class GetIncidentsStatisticsEvent extends IncidentsStatisticsEvent {
  final BuildContext context;
  GetIncidentsStatisticsEvent(this.context);
}

// States
abstract class IncidentsStatisticsState {}

class IncidentsStatisticsInitial extends IncidentsStatisticsState {}

class IncidentsStatisticsLoading extends IncidentsStatisticsState {}

class IncidentsStatisticsLoaded extends IncidentsStatisticsState {
  final OrganizerStatisticsModel incidentsStatistics;
  IncidentsStatisticsLoaded(this.incidentsStatistics);
}

class IncidentsStatisticsError extends IncidentsStatisticsState {
  final String message;
  IncidentsStatisticsError(this.message);
}

// Cubit
class IncidentsStatisticsCubit extends Cubit<IncidentsStatisticsState> {
  final IncidentsApiRepository _repository = IncidentsApiRepository();

  IncidentsStatisticsCubit() : super(IncidentsStatisticsInitial());

  Future<void> getIncidentsStatistics(BuildContext context) async {
    emit(IncidentsStatisticsLoading());

    final result = await _repository.getIncidentsStatistics();

    result.fold(
      (error) => emit(IncidentsStatisticsError(error)),
      (statistics) => emit(IncidentsStatisticsLoaded(statistics)),
    );
  }
} 