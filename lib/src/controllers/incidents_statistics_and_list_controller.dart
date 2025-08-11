// /*
// #   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
// #
// #   This source code is protected under international copyright law.  All rights
// #   reserved and protected by the copyright holders.
// #   All files are confidential and only available to authorized individuals with the
// #   permission of the copyright holders. If you encounter any file and do not have
// #   permission, please get in touch with the copyright holders and delete this file.
// */
// import 'dart:developer';
//
// import 'package:blink_component/blink_component.dart';
// import 'package:blink_component/models/incident/incident_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../services/incidents_api_repository.dart';
//
// /// IncidentsStatisticsAndListController
// class IncidentsStatisticsAndListController extends GetxController {
//   /// Constructor
//   IncidentsStatisticsAndListController();
//
//   final IncidentsApiRepository _apiRepository = IncidentsApiRepository();
//
//   final int pageLimit = 10;
//
//   /// agendaSummary
//   late AgendaSummaryModel agendaSummary;
//
//   final isScreenLoading = true.obs;
//
//   /// canClear
//   final canFilterClear = true.obs;
//   final isQuickFilterApplied = false.obs;
//
//   /// Filter
//   /// canGuestTypesClear
//   final canGuestTypesClear = false.obs;
//
//   /// selectedFiltersCount
//   final selectedFiltersCount = 0.obs;
//
//   final headerHeight = 0.0.obs;
//   int page = 0;
//   final filterChanged = false.obs;
//
//   List<String> incidentTypes = [];
//
//   /// incidentTypesList
//   final incidentTypesList = <IncidentTabsEnum>[].obs;
//
//   List<IncidentModel> incidents = [];
//   final incidentsGroups = <IncidentsCardsGroupModel>[];
//
//   /// Total Count
//   final totalCount = 0.obs;
//
//   /// dateError
//   final dateError = ''.obs;
//   final canLoadMore = false.obs;
//   final showLoading = false.obs;
//   final showLoadingNewPage = false.obs;
//
//   /// loadingData flag
//   bool loadingData = false;
//
//   @override
//   bool get isLoadingData => loadingData;
//
//   final currentTabIndex = 0.obs;
//   final emptyList = false.obs;
//   final searchCount = 0.obs;
//   final statisticsHeaderKey = "header_key".obs;
//
//   final ScrollController scrollController = ScrollController();
//   final isScrollAtTop = true.obs;
//
//   /// initIncidentsControllerData
//   void initIncidentsControllerData({
//     AgendaSummaryModel? agendaSummary,
//   }) {
//     emptyList(agendaSummary?.total == 0);
//     page = 0;
//     canFilterClear(false);
//     _generateTabsTypesList();
//     if (agendaSummary != null) {
//       this.agendaSummary = agendaSummary;
//     }
//     getDataAfterTabChanged();
//
//     headerHeight(agendaSummaryHeight);
//   }
//
//   /// _generateTabsTypesList
//   void _generateTabsTypesList() {
//     incidentTypesList.clear();
//     incidentTypesList.add(IncidentTabsEnum.all);
//     incidentTypesList.add(IncidentTabsEnum.open);
//     incidentTypesList.add(IncidentTabsEnum.resolved);
//     incidentTypes = [IncidentTabsEnum.all.getApiKey];
//   }
//
//   /// getDataAfterTabChanged
//   void getDataAfterTabChanged() {
//     _resetAndLoadData();
//   }
//
//   /// _resetAndLoadData
//   void _resetAndLoadData() {
//     page = 0;
//     incidents.clear();
//     incidentsGroups.clear();
//     dateError('');
//     showLoading(true);
//     canLoadMore(true);
//     _loadIncidentsList();
//   }
//
//   /// _loadIncidentsList
//   Future<void> _loadIncidentsList() async {
//     if (!canLoadMore.value) return;
//
//     if (page == 0) {
//       showLoading(true);
//       dateError('');
//     } else {
//       showLoadingNewPage(true);
//     }
//     loadingData = true;
//     update();
//
//     final result = await _apiRepository.getIncidentsList(
//       types: incidentTypes.length == 1 && incidentTypes.contains("all") ? [] : incidentTypes,
//       limit: pageLimit,
//       search: searchText.value,
//       offset: page * pageLimit,
//     );
//
//     result.fold(
//       (error) {
//         showLoading(false);
//         showLoadingNewPage(false);
//         loadingData = false;
//         if (page == 0) {
//           dateError(error);
//           canLoadMore(false);
//         }
//         update();
//       },
//       (response) {
//         page = page + 1;
//         final List<IncidentModel> newItems = ((response.data as List<dynamic>)
//             .map((n) => IncidentModel.fromJson(n))
//             .toList());
//
//         if (searchText.value.isNotEmpty) {
//           searchCount(response.count);
//         } else {
//           searchCount(0);
//         }
//
//         incidents.addAll(newItems);
//         totalCount(response.count?? 0);
//         _getIncidentsGroups();
//         canLoadMore(!(newItems.length < pageLimit || response.isLastOffset));
//         showLoading(false);
//         showLoadingNewPage(false);
//         loadingData = false;
//         dateError('');
//         update();
//       },
//     );
//   }
//
//   /// _getIncidentsGroups
//   void _getIncidentsGroups() {
//     incidentsGroups.clear();
//     List<IncidentModel> list = [];
//     String? lastDate;
//
//     for (var element in incidents) {
//       lastDate ??= element.date.split('T').first;
//       if (element.date.split('T').first != lastDate) {
//         incidentsGroups.add(IncidentsCardsGroupModel(lastDate, list));
//         lastDate = element.date.split('T').first;
//         list = [];
//       }
//       list.add(element);
//     }
//
//     if (lastDate != null) {
//       incidentsGroups.add(IncidentsCardsGroupModel(lastDate, list));
//     }
//   }
//
//   /// onTabChanged
//   void onTabChanged(int index) {
//     if (index == currentTabIndex.value) return;
//
//     currentTabIndex(index);
//     incidentTypes = [IncidentTabsEnum.values[index].getApiKey];
//
//     _resetAndLoadData();
//   }
//
//   /// onSearchTextChanged
//   void onSearchTextChanged(String query) {
//     searchText(query);
//     _resetAndLoadData();
//   }
//
//   /// refreshData
//   void refreshData() async {
//     await _loadStatistics();
//   }
//
//   /// loadMoreData
//   void loadMoreData() {
//     if (canLoadMore.value && !loadingData) {
//       _loadIncidentsList();
//     }
//   }
//
//   /// updateItemStatusInIncident
//   void updateItemStatusInIncident(int incidentId) {
//     int index = incidents.indexWhere((element) => element.id == incidentId);
//     if (index != -1) {
//       IncidentModel incident = incidents[index];
//       incident.status = incident.status == IncidentStatus.open ? IncidentStatus.resolved : IncidentStatus.open;
//       incidents[index] = incident;
//
//       if (incidentTypes.length == 1 &&
//           ((incident.status == IncidentStatus.open && incidentTypes.contains("resolved")) ||
//            (incident.status == IncidentStatus.resolved && incidentTypes.contains("open")))) {
//         incidents.removeAt(index);
//       }
//
//       _getIncidentsGroups();
//       update();
//     }
//   }
//
//   /// Filter management methods
//   void onClearAllClicked() {
//     canFilterClear(false);
//     update();
//   }
//
//   void onApplyFilterClicked({required BuildContext context, required bool goBack}) {
//     // Apply filter logic here
//     update();
//   }
//
//   /// Header management
//   double get getHeaderHeight => venueSummaryHeight; // Use venueSummaryHeight for incidents
//
//   String get screenTitle => incidentsTextKey.tr;
//   String get listTitle => incidentsTextKey.tr;
//
//   // Search and filters
//   final searchText = ''.obs;
//
//   // Statistics data
//   final isStatisticsLoading = true.obs;
//   final statisticsError = ''.obs;
//
//   /// _loadStatistics
//   Future<void> _loadStatistics() async {
//     isStatisticsLoading(true);
//     statisticsError('');
//
//     final result = await _apiRepository.getIncidentsStatistics();
//
//     result.fold(
//       (error) {
//         statisticsError(error);
//         isStatisticsLoading(false);
//       },
//       (statistics) {
//         // Convert OrganizerStatisticsModel to AgendaSummaryModel for incidents
//         agendaSummary = AgendaSummaryModel(
//           total: statistics.total,
//           open: statistics.open ?? 0,
//           resolved: statistics.resolved ?? 0,
//         );
//         isStatisticsLoading(false);
//         _loadIncidentsList();
//       },
//     );
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     _generateTabsTypesList();
//     _loadStatistics();
//   }
// }

/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'dart:developer';

import 'package:blink_component/blink_component.dart';
import 'package:blink_component/models/incident/incident_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/incidents_api_repository.dart';

/// IncidentsStatisticsAndListController
class IncidentsStatisticsAndListController extends GetxController {
  /// Constructor
  IncidentsStatisticsAndListController();

  final IncidentsApiRepository _apiRepository = IncidentsApiRepository();

  // ---- Pagination & request control ----
  final int pageLimit = 10;
  int page = 0;
  int requestLocalId = 0;
  bool _verifyRequestIsStillValid(int originalRequestLocalId) =>
      originalRequestLocalId != requestLocalId;

  // ---- Summary & header ----
  late AgendaSummaryModel agendaSummary;
  final isScreenLoading = true.obs;
  final headerHeight = 0.0.obs;
  final statisticsHeaderKey = "header_key".obs;

  // ---- Filters / Tabs ----
  final canFilterClear = false.obs;
  final isQuickFilterApplied = false.obs;
  final canGuestTypesClear = false.obs; // kept for parity with base
  final selectedFiltersCount = 0.obs;
  final filterChanged = false.obs;

  List<String> incidentTypes = [];
  final incidentTypesList = <IncidentTabsEnum>[].obs;

  // ---- Data ----
  List<IncidentModel> incidents = [];
  final incidentsGroups = <IncidentsCardsGroupModel>[];

  // ---- Counts & state ----
  final totalCount = 0.obs;
  final dateError = ''.obs;
  final canLoadMore = false.obs;
  final showLoading = false.obs;
  final showLoadingNewPage = false.obs;

  bool loadingData = false;
  @override
  bool get isLoadingData => loadingData;

  final currentTabIndex = 0.obs;
  final emptyList = false.obs;
  final searchCount = 0.obs;
  final isInternetConnected = true.obs;

  // ---- UI helpers ----
  final ScrollController scrollController = ScrollController();
  final isScrollAtTop = true.obs;

  // ---- Search & stats flags ----
  final searchTextController = TextEditingController();
  final searchText = ''.obs;
  final isStatisticsLoading = true.obs;
  final statisticsError = ''.obs;

  // --------------------------- Init ----------------------------
  /// initIncidentsControllerData
  void initIncidentsControllerData({AgendaSummaryModel? agendaSummary}) {
    emptyList(agendaSummary?.total == 0);
    page = 0;
    canFilterClear(false);
    _generateTabsTypesList();

    if (agendaSummary != null) {
      this.agendaSummary = agendaSummary;
    }

    // incidents use venueSummaryHeight in the main controller
    headerHeight(venueSummaryHeight);
    statisticsHeaderKey('statistics_${DateTime.now().millisecondsSinceEpoch}');

    getDataAfterTabChanged();
  }

  @override
  void onInit() {
    super.onInit();
    _generateTabsTypesList();
    scrollController.addListener(_onScroll);
    // allow first load even if initIncidentsControllerData() not called
    canLoadMore(true);
    isScreenLoading(true);

    _loadStatistics();
  }

  void _onScroll() {
    isScrollAtTop(scrollController.position.pixels <= 0);

    if (!loadingData &&
        canLoadMore.value &&
        scrollController.position.extentAfter < 400) {
      loadMoreData();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  // --------------------------- Tabs & Filters ----------------------------
  void _generateTabsTypesList() {
    incidentTypesList.clear();
    incidentTypesList.addAll(IncidentTabsEnum.values);
    incidentTypes = [IncidentTabsEnum.all.getApiKey];
    _updateFilterFlag();
  }

  void checkIfTheQuickFilterIsApplied() {
    final quickApplied = !(incidentTypes.length == 1 &&
        incidentTypes.first == IncidentTabsEnum.all.getApiKey);
    isQuickFilterApplied(quickApplied);
    _updateFilterFlag();
  }

  void onSearchTextChanged(String query) {
    searchText(query);
    _updateFilterFlag();
    _resetAndLoadData();
  }

  void updateTap(List<String> selectedTabs) {
    incidentTypes = selectedTabs;
    checkIfTheQuickFilterIsApplied();
    getDataAfterTabChanged();
  }

  void _updateFilterFlag() {
    canFilterClear(isQuickFilterApplied.value || searchText.isNotEmpty);
    update();
  }

  /// getDataAfterTabChanged
  void getDataAfterTabChanged() {
    _resetAndLoadData();
  }

  /// onTabChanged
  void onTabChanged(int index) {
    if (index == currentTabIndex.value) return;

    currentTabIndex(index);
    incidentTypes = [IncidentTabsEnum.values[index].getApiKey];
    checkIfTheQuickFilterIsApplied();

    _resetAndLoadData();
  }

  /// Filter management methods (kept for parity)
  void onClearAllClicked() {
    canFilterClear(false);
    update();
  }

  void onApplyFilterClicked({required BuildContext context, required bool goBack}) {
    update();
    if (goBack) Navigator.of(context).maybePop();
  }

  // --------------------------- Refresh ----------------------------
  Future<void> refreshScreen() async {
    await refreshData();
    await _refreshStatistics(loading: false);
  }

  Future<void> refreshData() async {
    page = 0;
    incidents = [];
    dateError('');
    showLoading(true);
    canLoadMore(true);
    await _loadIncidentsList();
  }

  // --------------------------- Loading helpers ----------------------------
  void _resetAndLoadData() {
    page = 0;
    incidents.clear();
    incidentsGroups.clear();
    dateError('');
    showLoading(true);
    canLoadMore(true);
    _loadIncidentsList();
  }

  void loadMoreData() {
    if (canLoadMore.value && !loadingData) {
      _loadIncidentsList();
    }
  }

  // --------------------------- API: list ----------------------------
  Future<void> _loadIncidentsList() async {
    if (!canLoadMore.value) return;

    if (page == 0) {
      showLoading(true);
      dateError('');
    } else {
      showLoadingNewPage(true);
    }

    loadingData = true;
    update();

    // request-cancellation guard
    requestLocalId++;
    final originalRequestLocalId = requestLocalId;

    // connectivity (same as main controller incidents branch)
    // final connected = await InternetConnection().hasInternetAccess;
    // isInternetConnected(connected);
    // if (!connected) {
    //   showLoading(false);
    //   showLoadingNewPage(false);
    //   loadingData = false;
    //
    //   // stop global loader if first page failed
    //   isScreenLoading(false);
    //
    //   if (page == 0) {
    //     dateError(connectionLostPleaseCheckInternetTextKey);
    //     canLoadMore(false);
    //   }
    //   update();
    //   return;
    // }

    final selectedTypes = (incidentTypes.length == 1 &&
        (incidentTypes.contains("all") || incidentTypes.contains("All")))
        ? <String>[]
        : incidentTypes;

    final result = await _apiRepository.getIncidentsList(
      types: selectedTypes,
      limit: pageLimit,
      search: searchText.value,
      offset: page * pageLimit,
    );

    if (_verifyRequestIsStillValid(originalRequestLocalId)) {
      showLoadingNewPage(false);
      loadingData = false;
      return;
    }
    result.fold(
          (l) {
        showLoading(false);
        showLoadingNewPage(false);
        loadingData = false;

        // stop global loader if first page failed
        isScreenLoading(false);

        if (page == 0) {
          dateError(l);
          canLoadMore(false);
        }
        update();
      },
          (r) {
        page = page + 1;

        final List<IncidentModel> newItems = ((r.data as List<dynamic>)
            .map((n) => IncidentModel.fromJson(n))
            .toList());

        if (searchText.value.isNotEmpty) {
          searchCount(r.count);
        } else {
          searchCount(0);
        }

        incidents.addAll(newItems);
        totalCount(r.count ?? 0);
        _getIncidentsGroups();

        canLoadMore(!(newItems.length < pageLimit || r.isLastOffset));
        showLoading(false);
        showLoadingNewPage(false);
        loadingData = false;
        dateError('');

        // first page done -> stop global loader
        if (page > 0) isScreenLoading(false);

        update();
      },
    );
  }

  // --------------------------- API: statistics ----------------------------
  Future<void> _loadStatistics() async {
    isStatisticsLoading(true);
    statisticsError('');

    final result = await _apiRepository.getIncidentsStatistics();

    result.fold(
          (error) {
        statisticsError(error);
        isStatisticsLoading(false);
        isScreenLoading(false);
        update();
      },
          (statistics) async {
        // Convert to AgendaSummaryModel (same as before)
        agendaSummary = AgendaSummaryModel(
          total: statistics.total,
          open: statistics.open ?? 0,
          resolved: statistics.resolved ?? 0,
        );

        // Keep original behavior: totalCount depends on active tab
        if (incidentTypes.length == 1 && incidentTypes.contains('resolved')) {
          totalCount(agendaSummary.resolved);
        } else if (incidentTypes.length == 1 && incidentTypes.contains('open')) {
          totalCount(agendaSummary.open);
        } else {
          totalCount(agendaSummary.total);
        }

        statisticsHeaderKey('statistics_${DateTime.now().millisecondsSinceEpoch}');
        isStatisticsLoading(false);

        // ensure list can load on first time
        canLoadMore(true);

        // await first page, then close global loader
        await _loadIncidentsList();

        isScreenLoading(false);
        update();
      },
    );
  }

  Future<void> _refreshStatistics({bool loading = true}) async {
    if (loading) isScreenLoading(true);

    final result = await _apiRepository.getIncidentsStatistics();

    result.fold(
          (l) {
        // no-op on error (parity with main refreshStatistics)
      },
          (r) {
        agendaSummary = AgendaSummaryModel(
          total: r.total,
          open: r.open ?? 0,
          resolved: r.resolved ?? 0,
        );

        if (incidentTypes.length == 1 && incidentTypes.contains('resolved')) {
          totalCount(agendaSummary.resolved);
        } else if (incidentTypes.length == 1 && incidentTypes.contains('open')) {
          totalCount(agendaSummary.open);
        } else {
          totalCount(agendaSummary.total);
        }

        emptyList(agendaSummary.total == 0);
        statisticsHeaderKey('statistics_${DateTime.now().millisecondsSinceEpoch}');
      },
    );

    if (loading) isScreenLoading(false);
    update();
  }

  // --------------------------- Groups & item updates ----------------------------
  void _getIncidentsGroups() {
    incidentsGroups.clear();
    List<IncidentModel> list = [];
    String? lastDate;

    for (var element in incidents) {
      final day = element.date.split('T').first;
      lastDate ??= day;
      if (day != lastDate) {
        incidentsGroups.add(IncidentsCardsGroupModel(lastDate, list));
        lastDate = day;
        list = [];
      }
      list.add(element);
    }

    if (lastDate != null) {
      incidentsGroups.add(IncidentsCardsGroupModel(lastDate, list));
    }
  }

  void updateItemStatusInIncident(int incidentId) {
    final index = incidents.indexWhere((e) => e.id == incidentId);
    if (index == -1) return;

    final incident = incidents[index];
    final newStatus =
    incident.status == IncidentStatus.open ? IncidentStatus.resolved : IncidentStatus.open;
    // incidents[index] = incident.copyWith(status: newStatus);

    if (incidentTypes.length == 1 &&
        ((newStatus == IncidentStatus.open && incidentTypes.contains("resolved")) ||
            (newStatus == IncidentStatus.resolved && incidentTypes.contains("open")))) {
      incidents.removeAt(index);
    }

    _getIncidentsGroups();
    update();
  }

  // --------------------------- Header & titles ----------------------------
  double get getHeaderHeight => venueSummaryHeight; // incidents use venueSummaryHeight
  String get screenTitle => incidentsTextKey.tr;
  String get listTitle => incidentsTextKey.tr;
}
