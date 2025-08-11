/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'package:blink_component/models/incident/create_incident_scope_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../incident_manager.dart';
import '../controllers/incident_scope_controller.dart';

class IncidentScopeTypesCubit extends Cubit<IncidentScopeTypesState> {

  IncidentScopeTypesCubit() : super(const IncidentScopeTypesInitial());

  static IncidentScopeTypesCubit get(context) => BlocProvider.of(context);

  Future<void> getIncidentScopeTypes(BuildContext context) async {
    emit(const IncidentScopeTypesLoading());

    final result = await IncidentsApiRepository().getScopeNames();
    result.fold(
      (l) {
        emit(IncidentScopeTypesError(message: l));
      },
      (r) {
        emit(IncidentScopeTypesLoaded(r));
        Get.find<IncidentScopeController>().addScopeTypes(r.scopeTypes);
      },
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////

abstract class IncidentScopeTypesState {
  const IncidentScopeTypesState();
}

class IncidentScopeTypesInitial extends IncidentScopeTypesState {
  const IncidentScopeTypesInitial();
}

class IncidentScopeTypesLoading extends IncidentScopeTypesState {
  const IncidentScopeTypesLoading();
}

class IncidentScopeTypesError extends IncidentScopeTypesState {
  final String message;
  const IncidentScopeTypesError({required this.message});
}

class IncidentScopeTypesLoaded extends IncidentScopeTypesState {
  CreateIncidentScopeNamesModel scope;
  IncidentScopeTypesLoaded(this.scope);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IncidentScopeTypesLoaded &&
              runtimeType == other.runtimeType &&
              scope == other.scope;

  @override
  int get hashCode => scope.hashCode;
}
