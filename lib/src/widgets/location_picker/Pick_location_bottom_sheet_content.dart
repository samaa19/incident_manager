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
import 'package:blink_component/controllers/location_picker_controller.dart';
import 'package:blink_component/widgets/map_widgets/location_place_item.dart';
import 'package:blink_component/widgets/skeleton_widgets/map_location_skeleton.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../incident_manager.dart';
import '../../controllers/create_incident_controller.dart';
import '../../controllers/incident_scope_controller.dart';
import 'bottom_sheet_container.dart';
import 'destination_marker_widget.dart';
import 'map_buttons.dart';
import 'map_widget.dart';
import 'no_places_found.dart';

class PickLocationBottomSheetContent extends StatefulWidget {
  final bool isDark;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final IncidentScopeController incidentScopeController;
  final CreateIncidentController createIncidentController;
  final MyColorsPalette palette;
  final StopModel? startLocation;
  final Function(StopModel) onPickLocation;

  const PickLocationBottomSheetContent({
    super.key,
    required this.isDark,
    required this.appIcons,
    required this.appBorders,
    required this.incidentScopeController,
    required this.createIncidentController,
    required this.onPickLocation,
    required this.palette,
    this.startLocation,
  });

  @override
  State<PickLocationBottomSheetContent> createState() =>
      _PickLocationBottomSheetContentState();
}

class _PickLocationBottomSheetContentState extends State<PickLocationBottomSheetContent> {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  LocationPickerController locationPickerController = Get.put(LocationPickerController(googleApiWebKey: googleMapsApiWebKey));

  Completer<GoogleMapController> mapController = Completer();

  void _updateMapStyle(GoogleMapController controller) {
      controller.setMapStyle(widget.isDark ? googleMapStyleDark : googleMapStyleLight);
  }

  void onMapCreated(GoogleMapController controller) {
    _updateMapStyle(controller);
    if (!mapController.isCompleted) {
      mapController.complete(controller);
      locationPickerController.setGoogleMapController(controller);
    }
  }

  void initializeCurrentLocation() async {
    locationPickerController.resetControllerValues();
    //await locationPickerController.initializeControllerValues();
    if (widget.incidentScopeController.selectedLocation != null) {
      locationPickerController.updateLocation(
          latitude: double.parse(
              widget.incidentScopeController.selectedLocation!.lat),
          longitude: double.parse(
              widget.incidentScopeController.selectedLocation!.lng));
    } else {
      await locationPickerController.initializeControllerValues();
      // locationPickerController.getMyLocation();
    }
  }

  void confirmDestination() {
    final lng =
        double.tryParse(locationPickerController.destinationLocation.lng);
    if (lng != 0) {
      widget.onPickLocation(locationPickerController.destinationLocation);

    }
  }

  void _onFocusChange() {
    locationPickerController.updateDestinationFocus(
      locationPickerController.whereToFocus.hasFocus,
    );
  }

  @override
  void initState() {
    initializeCurrentLocation();
    locationPickerController.whereToFocus.addListener(_onFocusChange);
    locationPickerController.searchController.clear();

    super.initState();
  }

  @override
  void dispose() {
    locationPickerController.whereToFocus.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IncidentScopeController>(
        builder: (incidentScopeController) {
      return GetBuilder<LocationPickerController>(
          builder: (rideLocationsController) {
        return BottomSheetContainer(
          title: incidentLocationTextKey.tr,
          palette: widget.palette,
          appBorders: widget.appBorders,
          appIcons: widget.appIcons,
          onBack: () {
            if (widget.createIncidentController.isExpanded.value) {
              widget.createIncidentController.isExpanded(false);
            } else {
              Get.back();
            }
          },
          onWillPop: () async {
            if (widget.createIncidentController.isExpanded.value) {
              widget.createIncidentController.isExpanded(false);
              return false;
            } else {
              return true;
            }
          },
          withActionButton:
              locationPickerController.searchController.text.isEmpty,
          enableActionButton: (double.tryParse(
                      locationPickerController.destinationLocation.lng) ??
                  0) !=
              0,
          buttonAction: confirmDestination,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () =>
                    SystemChannels.textInput.invokeMethod('TextInput.'),
                child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                color:
                                    widget.palette.themeColorsBorderNeutral11,
                                height: 1,
                                width: double.infinity,
                              ),
                              SearchFieldWidget(
                                appIcons: widget.appIcons,
                                borderRadius: widget.appBorders.xSmall,
                                palette: widget.palette,
                                hint: searchPlacesTextKey.tr,
                                margin: const EdgeInsets.only(
                                  top: 12,
                                ),
                                onSearchList: (word) =>
                                    locationPickerController.searchForPlace(
                                        searchingText: word,
                                        isCreateRide: false),
                                clearSearch: () =>
                                    locationPickerController.searchForPlace(
                                        searchingText: '', isCreateRide: false),
                                controller:
                                    locationPickerController.searchController,
                                focusNode:
                                    locationPickerController.searchFocusNode,
                              ),
                              if (locationPickerController
                                      .searchController.text.isEmpty &&
                                  locationPickerController
                                      .isInternetConnected.value)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Opacity(
                                      opacity: locationPickerController
                                                  .searchController
                                                  .text
                                                  .isEmpty &&
                                              locationPickerController
                                                  .isInternetConnected
                                                  .value /*&&!locationPickerController.searchFocusNode.hasFocus*/
                                          ? 1
                                          : 0,
                                      child: Stack(
                                        children: [
                                          MapWidget(onMapCreated: onMapCreated),
                                          if (locationPickerController
                                              .locationEnabled)
                                            MyLocationButton(
                                              isDark: widget.isDark,
                                              palette: widget.palette,
                                              appIcons: widget.appIcons,
                                            ),
                                          DestinationMarkerWidget(
                                            address: locationPickerController.whereToController.text,
                                            palette: widget.palette,
                                            appBorders: widget.appBorders,
                                            appIcons: widget.appIcons,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if ((locationPickerController
                                          .searchController.text.isNotEmpty ||
                                      locationPickerController
                                          .searchFocusNode.hasFocus) &&
                                  locationPickerController
                                      .isInternetConnected.value)
                                ConditionalBuilder(
                                    condition:
                                        !locationPickerController.isLoading,
                                    fallback: (_) => Expanded(
                                            child: MapLocationListSkeleton(
                                          palette: widget.palette,
                                          appIcons: widget.appIcons,
                                          appBorders: widget.appBorders,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18, horizontal: 4),
                                        )),
                                    builder: (_) {
                                      return ConditionalBuilder(
                                        condition: !locationPickerController
                                            .notResultsFound.value,
                                        builder: (context) => searchPlacesList(
                                            places: locationPickerController
                                                .placesList,
                                            palette: widget.palette,
                                            currentLocation: locationPickerController
                                                        .currentLocation !=
                                                    null
                                                ? Location(
                                                    lat:
                                                        locationPickerController
                                                            .currentLocation!
                                                            .latitude,
                                                    lng:
                                                        locationPickerController
                                                            .currentLocation!
                                                            .longitude)
                                                : null,
                                            appIcons: widget.appIcons),
                                        fallback: (BuildContext context) =>
                                            Expanded(
                                                child: Center(
                                          child: NoPlacesFoundWidget(
                                            palette: widget.palette,
                                          ),
                                        )),
                                      );
                                    }),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
              //  _destinationsAndAppBarContainer(rideLocationsController),
            ],
          ),
        );
      });
    });
  }

  Widget searchPlacesList(
      {required List<PlacesSearchResult> places,
      required MyColorsPalette palette,
      required AppIcons appIcons,
      required Location? currentLocation}) {
    return Expanded(
        child: ListView.separated(
      itemBuilder: (_, index) => LocationPlaceItem(
        place: places[index],
        currentLocation: currentLocation,
        palette: palette,
        appIcons: appIcons,
        onPlaceClicked: (PlacesSearchResult placeSearchResult) {
          widget.onPickLocation(StopModel(
              lat: placeSearchResult.geometry?.location.lat.toString() ?? '0',
              lng: placeSearchResult.geometry?.location.lng.toString() ?? '0',
              address: placeSearchResult.formattedAddress ?? '',
              stopTitle: placeSearchResult.name));
        },
      ),
      separatorBuilder: (_, index) => 8.gap,
      itemCount: places.length,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
    ));
  }
}
