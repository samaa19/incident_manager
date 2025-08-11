/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/

import 'package:blink_component/models/capacity_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/capacity_indicator/capacity_indicator_api_repository.dart';

const _defaultCapacityIndicators = [
  CapacityIndicatorModel(
      id: 1,
      name: 'Empty',
      description: 'No attendees have checked in yet. All spotsare available.',
      sortIndex: 0,
      percent: 0,
      fontColor: '#353535',
      backgroundColor: '#EFEFEF'),
  CapacityIndicatorModel(
      id: 2,
      name: 'Still Room',
      description:
          'Plenty of space available. Attendees can join without concern.',
      sortIndex: 1,
      percent: 33,
      fontColor: '#215135',
      backgroundColor: '#BBF0CC'),
  CapacityIndicatorModel(
      id: 3,
      name: 'Filling Up',
      description: 'Attendance is increasing. Space is becoming limited.',
      sortIndex: 2,
      percent: 60,
      fontColor: '#594417',
      backgroundColor: '#FDDFAB'),
  CapacityIndicatorModel(
      id: 4,
      name: 'Almost Full',
      description: 'Few spots remain. Availability is very limited.',
      sortIndex: 3,
      percent: 99,
      fontColor: '#5B3D2A',
      backgroundColor: '#FFD7BF'),
  CapacityIndicatorModel(
      id: 5,
      name: 'Full',
      description:
          'The experience has reached maximum capacity. There is no available space for additional attendees.',
      sortIndex: 4,
      percent: 100,
      fontColor: '#552823',
      backgroundColor: '#F9BEB5'),
];

class CapacityIndicatorsGlobal {
  CapacityIndicatorsGlobal._();
  static final CapacityIndicatorsGlobal instance = CapacityIndicatorsGlobal._();

  final CapacityIndicatorsCubit cubit = CapacityIndicatorsCubit();

  Future<void> init() async => cubit.getCapacityIndicators();

  List<CapacityIndicatorModel> get current => cubit.capacityIndicators;
}


class CapacityIndicatorsCubit extends Cubit<CapacityIndicatorsState> {
  CapacityIndicatorsCubit() : super(CapacityIndicatorsInitial());

  List<CapacityIndicatorModel> capacityIndicators = [];
  Future<void> getCapacityIndicators() async {
    final result = await CapacityIndicatorApiRepository().getCapacityIndicators();
    result.fold(
          (l) {
        // capacityIndicators
        //   ..clear()
        //   ..addAll(_defaultCapacityIndicators); // if you want defaults
        emit(CapacityIndicatorsLoaded(List.unmodifiable(capacityIndicators)));
      },
          (r) {
        capacityIndicators
          ..clear()
          ..addAll(r); // mutate existing list instead of reassigning
        emit(CapacityIndicatorsLoaded(List.unmodifiable(capacityIndicators)));
      },
    );
  }

  // Future<void> getCapacityIndicators() async {
  //   try {
  //     final result =
  //         await CapacityIndicatorApiRepository().getCapacityIndicators();
  //     result.fold(
  //       (l) {
  //         // capacityIndicators = _defaultCapacityIndicators;
  //         emit(CapacityIndicatorsLoaded(capacityIndicators));
  //       },
  //       (r) {
  //         capacityIndicators = r;
  //         print('IncidentManagerConfig CapacityIndicatorsLoaded capacityIndicators are ${capacityIndicators}');
  //         emit(CapacityIndicatorsLoaded(capacityIndicators));
  //       },
  //     );
  //   } catch (e) {
  //     // capacityIndicators = _defaultCapacityIndicators;
  //     emit(CapacityIndicatorsLoaded(capacityIndicators));
  //   }
  // }
}

// ----------------------- States -----------------------------
class CapacityIndicatorsState {}

class CapacityIndicatorsInitial extends CapacityIndicatorsState {}

class CapacityIndicatorsLoading extends CapacityIndicatorsState {}

class CapacityIndicatorsError extends CapacityIndicatorsState {}

class CapacityIndicatorsLoaded extends CapacityIndicatorsState {
  final List<CapacityIndicatorModel> capacityIndicators;

  CapacityIndicatorsLoaded(this.capacityIndicators);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CapacityIndicatorsLoaded &&
          runtimeType == other.runtimeType &&
          capacityIndicators == other.capacityIndicators;

  @override
  int get hashCode => capacityIndicators.hashCode;
}
