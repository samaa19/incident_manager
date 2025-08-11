/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'dart:async';

import 'package:blink_component/blink_component.dart';
import 'package:blink_component/models/incident/create_incident_scope_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:incident_manager/incident_manager.dart';



class IncidentScopeController extends GetxController {

  // -- Scope Types
  late List<IncidentScopeType> scopeTypes = [];

  // -- Selected Category Type
  late IncidentScopeType selectedCategoryType;

  // -- Changeable Selected Category Widget Data (depends on selectedCategoryType)
  final selectedCategoryTitle = ''.obs;
  final selectedCategorySearchHint = ''.obs;

  // -- Data Lists
  final List<VenueModel> venues    = [];
  final List<Session> sessions     = [];
  final List<GuestModel> attendees = [];

  // -- Selected Scope
  final scopeIsSelected = false.obs;
  Session? selectedSession;
  VenueModel? selectedVenue;
  GuestModel? selectedAttendee;

  Session? tempSelectedSession;
  VenueModel? tempSelectedVenue;
  GuestModel? tempSelectedAttendee;
  dynamic tempScopeDetails;
  dynamic selectedScopeDetails;
  String? selectedScope;

  //StopModel? confirmedLocation;
  final confirmedLocation=StopModel(lat: '', lng: '', address: '', stopTitle: '').obs;
  StopModel? selectedLocation;

  // -- Address
  late TextEditingController addressDetailsTextController;
  late TextEditingController confirmedAddressDetailsTextController;
  String confirmedAddressDetails='';
  // -- Search
  Timer? _debounce;
  late TextEditingController searchTextController;
  final searchText = ''.obs;

  // -- Pagination and Loading
  final scrollController = ScrollController();
  final errorMessage = ''.obs;
  final canLoadMore = false.obs;
  final showLoading = false.obs;
  int page = 0;
  final pageLimit = 10;
  final isLocationBottomSheetExpanded = false.obs;
  final isScopeChange=false.obs;


  @override
  onInit() {
    super.onInit();
    selectedCategoryType         = IncidentScopeType.venue;
    searchTextController         = TextEditingController(text: '');
    addressDetailsTextController = TextEditingController();
    confirmedAddressDetailsTextController = TextEditingController(text:confirmedAddressDetails);

    // -- Get Selected Category Title and Search Hint
    getSelectedCategoryTitle();
    getSelectedCategorySearchHint();

    // -- Scroll Listener for Pagination
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        final isBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
        if (isBottom && canLoadMore.value) {
          fetchListDependingOnSelectedScope();
        }
      }
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    addressDetailsTextController.dispose();
    confirmedAddressDetailsTextController.dispose();
    super.dispose();
  }


  // -- Search
  void onSearchTextChanged(String query) {
    showLoading(true);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: debounceDurationTime), () {
      searchText(query);
      getListData();
    });
  }

  // -- Scope Types
  void addScopeTypes(List<String> types) {
    scopeTypes.clear();
    for (String element in types) {
      final normalizedElement = element.toLowerCase();
      scopeTypes.add(fromStringToIncidentScopeType(normalizedElement));
    }
  }

  // -- Update All Data when Selected Category Type Change
  updateSelectedCategoryType(String type) {
    setTempScope();
    selectedCategoryType = fromStringToIncidentScopeType(type);
    update();
    searchTextController.clear();
    searchText('');
    getSelectedCategoryTitle();
    getSelectedCategorySearchHint();
    getListData();
  }

  getSelectedCategoryTitle() {
    switch (selectedCategoryType) {
      case IncidentScopeType.session:
        return selectedCategoryTitle.value = experiencesTextKey;
      case IncidentScopeType.venue:
        return selectedCategoryTitle.value = venuesTextKey;
      case IncidentScopeType.attendee:
        return selectedCategoryTitle.value = attendeesTextKey;
        case IncidentScopeType.other:
        return selectedCategoryTitle.value = '';
    }
  }

  getSelectedCategorySearchHint() {
    switch (selectedCategoryType) {
      case IncidentScopeType.session:
        return selectedCategorySearchHint.value = searchSmallExperiencesTextKey;
      case IncidentScopeType.venue:
        return selectedCategorySearchHint.value = searchVenuesTextKey;
      case IncidentScopeType.attendee:
        return selectedCategorySearchHint.value = searchSmallAttendeesTextKey;
      case IncidentScopeType.other:
        return selectedCategorySearchHint.value = '';
    }
  }

  selectLocation(StopModel location){
    addressDetailsTextController.clear();
    confirmedAddressDetails = '';
    selectedLocation = location;
    update();
  }

  confirmSelectedLocation(){
    confirmedLocation(selectedLocation);
    confirmedAddressDetails = addressDetailsTextController.text;
    confirmedAddressDetailsTextController.text = addressDetailsTextController.text;
    confirmedLocation.value.locationDetails = confirmedAddressDetailsTextController.text;
    update();
  }

  // -- Select/Deselect for scope
  tempSelectDeselectScope(String scope, dynamic scopeDetails,{bool scopeChange=true}) {
    isScopeChange(scopeChange);
     final scopeType = fromStringToIncidentScopeType(scope);
    tempScopeDetails=scopeDetails;
    switch(scopeType) {
      case IncidentScopeType.session:
        tempSelectedSession = scopeDetails;
        update();
      case IncidentScopeType.venue:
        tempSelectedVenue = scopeDetails;
        update();
      case IncidentScopeType.attendee:
        tempSelectedAttendee = scopeDetails;
        update();
      case IncidentScopeType.other:
        selectedSession = null;
        selectedVenue = null;
        selectedAttendee = null;
        isLocationBottomSheetExpanded(false);
       // confirmedLocation = scopeDetails;
        scopeIsSelected(true);
        update();
    }
  }
  selectDeselectScope(String scope, dynamic scopeDetails) {
    scopeIsSelected(false);
    selectedLocation=null;
    confirmedLocation(StopModel(lat: '', lng: '', address: '', stopTitle: ''));
    addressDetailsTextController.clear();
    final scopeType = fromStringToIncidentScopeType(scope);
    selectedScope=scope;
    selectedScopeDetails=scopeDetails;
    switch(scopeType) {
      case IncidentScopeType.session:
        selectedVenue = null;
        selectedAttendee = null;
        selectedSession = scopeDetails;
        scopeIsSelected(true);
        update();
        Get.back();
      case IncidentScopeType.venue:
        selectedSession = null;
        selectedAttendee = null;
        selectedVenue = scopeDetails;
        scopeIsSelected(true);
        update();
        Get.back();
      case IncidentScopeType.attendee:
        selectedSession = null;
        selectedVenue = null;
        selectedAttendee = scopeDetails;
        isLocationBottomSheetExpanded(false);
        scopeIsSelected(true);
        update();
        Get.back();
      case IncidentScopeType.other:
        selectedSession = null;
        selectedVenue = null;
        selectedAttendee = null;
        isLocationBottomSheetExpanded(false);
       // confirmedLocation = scopeDetails;
        scopeIsSelected(true);
        update();
        Get.back();
    }
  }
  setTempScope(){
    tempSelectedSession=null;
    tempSelectedVenue=null;
    tempSelectedAttendee=null;
    if(selectedScope!=null) {
      tempSelectDeselectScope(selectedScope!, selectedScopeDetails,scopeChange:false);
    }
  }
  // -- Get Lists Data
  refreshData() {
    page = 0;
    canLoadMore(true);
    errorMessage('');
    sessions.clear();
    venues.clear();
    attendees.clear();
  }

  getListData() {
    refreshData();
    fetchListDependingOnSelectedScope();
  }

  // -- API Calls
  fetchListDependingOnSelectedScope() async {
    // Fetch Sessions
    if (!canLoadMore.value) {
      return;
    }
    if (page == 0) {
      showLoading(true);
      errorMessage('');
      refresh();
    } else {
      errorMessage('');
      refresh();
    }

    final result = await IncidentsApiRepository().getSelectedScopeRecords(
      offset: page * pageLimit,
      search: searchText.value,
      limit: pageLimit,
      scopeName: selectedCategoryType.getTypeInRequestType,
    );

    result.fold(
      (l) {
        showLoading(false);
        if (page == 0) {
          canLoadMore(false);
          errorMessage(l);
          refresh();
        }
      },
      (r) {
        page = page + 1;
        if(selectedCategoryType == IncidentScopeType.session) {
          final List<Session> newItems = ((r.data as List<dynamic>).map((n) => Session.fromJson(n)).toList());
          sessions.addAll(newItems);
          canLoadMore(!(newItems.length < pageSize || r.isLastOffset));
        } else if(selectedCategoryType == IncidentScopeType.venue) {
          final List<VenueModel> newItems = ((r.data as List<dynamic>).map((n) => VenueModel.fromJson(n)).toList());
          venues.addAll(newItems);
          canLoadMore(!(newItems.length < pageSize || r.isLastOffset));
        } else {
          final List<GuestModel> newItems = ((r.data as List<dynamic>).map((n) => GuestModel.fromJson(n)).toList());
          attendees.addAll(newItems);
          canLoadMore(!(newItems.length < pageSize || r.isLastOffset));
        }
        showLoading(false);
        refresh();
        update();
      },
    );
  }

}