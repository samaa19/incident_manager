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
import 'package:get/get.dart';
import '../../incident_manager.dart';

class IncidentsStatisticsAndListController extends GetxController {
  final IncidentsApiRepository _apiRepository = IncidentsApiRepository();

  // Statistics data
  OrganizerStatisticsModel? statisticsData;
  final isStatisticsLoading = true.obs;
  final statisticsError = ''.obs;

  // List data
  List<IncidentModel> incidents = [];
  final incidentsGroups = <IncidentsCardsGroupModel>[];
  
  // Pagination
  int page = 0;
  final int pageLimit = 10;
  final canLoadMore = true.obs;
  final showLoading = true.obs;
  final showLoadingNewPage = false.obs;
  final loadingData = false.obs;
  
  // Search and filters
  final searchText = ''.obs;
  final searchCount = 0.obs;
  List<String> incidentTypes = [];
  final currentTabIndex = 0.obs;
  
  // UI state
  final emptyList = false.obs;
  final dateError = ''.obs;
  final totalCount = 0.obs;

  // Tabs
  final incidentTypesList = <IncidentTabsEnum>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateTabsTypesList();
    _loadStatistics();
  }

  void _generateTabsTypesList() {
    incidentTypesList.clear();
    incidentTypesList.add(IncidentTabsEnum.all);
    incidentTypesList.add(IncidentTabsEnum.open);
    incidentTypesList.add(IncidentTabsEnum.resolved);
    incidentTypes = [IncidentTabsEnum.all.getApiKey];
  }

  Future<void> _loadStatistics() async {
    isStatisticsLoading(true);
    statisticsError('');

    final result = await _apiRepository.getIncidentsStatistics();

    result.fold(
      (error) {
        statisticsError(error);
        isStatisticsLoading(false);
      },
      (statistics) {
        statisticsData = statistics;
        isStatisticsLoading(false);
        _loadIncidentsList();
      },
    );
  }

  Future<void> _loadIncidentsList() async {
    if (!canLoadMore.value) return;

    if (page == 0) {
      showLoading(true);
      dateError('');
    } else {
      showLoadingNewPage(true);
    }
    loadingData(true);
    update();

    final result = await _apiRepository.getIncidentsList(
      types: incidentTypes.length == 1 && incidentTypes.contains("all") ? [] : incidentTypes,
      limit: pageLimit,
      search: searchText.value,
      offset: page * pageLimit,
    );

    result.fold(
      (error) {
        showLoading(false);
        showLoadingNewPage(false);
        loadingData(false);
        if (page == 0) {
          dateError(error);
          canLoadMore(false);
        }
        update();
      },
      (response) {
        page = page + 1;
        final List<IncidentModel> newItems = ((response.data as List<dynamic>)
            .map((n) => IncidentModel.fromJson(n))
            .toList());
        
        if (searchText.value.isNotEmpty) {
          searchCount(response.count ?? 0);
        } else {
          searchCount(0);
        }
        
        incidents.addAll(newItems);
        totalCount(response.count ?? 0);
        _getIncidentsGroups();
        canLoadMore(!(newItems.length < pageLimit || response.isLastOffset));
        showLoading(false);
        showLoadingNewPage(false);
        loadingData(false);
        dateError('');
        update();
      },
    );
  }

  void _getIncidentsGroups() {
    incidentsGroups.clear();
    List<IncidentModel> list = [];
    String? lastDate;
    
    for (var element in incidents) {
      lastDate ??= element.date.split('T').first;
      if (element.date.split('T').first != lastDate) {
        incidentsGroups.add(IncidentsCardsGroupModel(lastDate, list));
        lastDate = element.date.split('T').first;
        list = [];
      }
      list.add(element);
    }
    
    if (lastDate != null) {
      incidentsGroups.add(IncidentsCardsGroupModel(lastDate, list));
    }
  }

  void onTabChanged(int index) {
    if (index == currentTabIndex.value) return;
    
    currentTabIndex(index);
    incidentTypes = [IncidentTabsEnum.values[index].getApiKey];
    
    _resetAndLoadData();
  }

  void _resetAndLoadData() {
    page = 0;
    incidents.clear();
    incidentsGroups.clear();
    dateError('');
    showLoading(true);
    canLoadMore(true);
    _loadIncidentsList();
  }

  void onSearchTextChanged(String query) {
    searchText(query);
    _resetAndLoadData();
  }

  void refreshData() async {
    await _loadStatistics();
  }

  void loadMoreData() {
    if (canLoadMore.value && !loadingData.value) {
      _loadIncidentsList();
    }
  }

  void updateItemStatusInIncident(int incidentId) {
    int index = incidents.indexWhere((element) => element.id == incidentId);
    if (index != -1) {
      IncidentModel incident = incidents[index];
      incident.status = incident.status == IncidentStatus.open ? IncidentStatus.closed : IncidentStatus.open;
      incidents[index] = incident;
      
      if (incidentTypes.length == 1 && 
          ((incident.status == IncidentStatus.open && incidentTypes.contains("resolved")) ||
           (incident.status == IncidentStatus.closed && incidentTypes.contains("open")))) {
        incidents.removeAt(index);
      }
      
      _getIncidentsGroups();
      update();
    }
  }

  String get screenTitle => incidentsTextKey.tr;
  String get listTitle => incidentsTextKey.tr;
}
