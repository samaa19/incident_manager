/*
#   Copyright 2022 (C) Blink Tech LLC - All Rights Reserved
#
#   This source code is protected under international copyright law.  All rights
#   reserved and protected by the copyright holders.
#   All files are confidential and only available to authorized individuals with the
#   permission of the copyright holders. If you encounter any file and do not have
#   permission, please get in touch with the copyright holders and delete this file.
*/
import 'package:blink_component/utils/map_style.dart';
import 'package:incident_manager/incident_manager.dart';


// abstract class MyAssets {
//   ////////////////////////////// General /////////////////////////
//   String updateImage         = 'assets/images/icon_update.png';
//   String errorImage          = 'assets/images/image_error_image.png';
//   String warningImage        = 'assets/images/warning_image.png';
//   String eventStatusIcon    = "assets/icons/icon_event_status.svg";
//
//   //////////////////////////// Login //////////////////////////////
//   abstract String successImage;
//
//   ////////////////////// Bottom sheets ////////////////////////
//   String flightDeparture   = 'assets/images/flight_departure.png';
//   String flightReturn      = 'assets/images/flight_return.png';
//   String journeyImage      = 'assets/images/transportation_image.png';
//   String reservationImage  = 'assets/images/reservation_image.png';
//   String chatButtonIcon    = 'assets/icons/icon_chat_button.svg';
//   String circleWithFullText    = "assets/icons/circle_with_full_text.png";
//
//   ////////////////////////// Agenda //////////////////
//   String logsIcon           = 'icon_logs.png';
//   String agendaEyeIcon      = 'assets/icons/icon_agenda_eye.svg';
//   String agendaSessionIcon  = 'assets/icons/icon_agenda_session.svg';
//   String agendaHotelIcon    = 'assets/icons/icon_agenda_hotel.svg';
//   String agendaFlightIcon   = 'assets/icons/icon_agenda_flight.svg';
//   String noIcon             = '';
//   String minimizeIcon       = 'assets/icons/minimize.svg';
//   String plusIcon           = 'assets/icons/plus.svg';
//
//   /////////////////////// Profile Screen ////////////////
//   // String profileImage       = 'assets/images/user_placeholder.png';
//
//   ////////////////////// Map //////////////////////////////
//   abstract String googleMapStyle;
//   String locationIcon   = 'assets/icons/icon_location.svg';
//   //Todo we should use it as svg and change it's color
//   abstract String markerLocationIcon;
//   abstract String mapAddressIcon;
//
//   ///////////////////////// see more widget ////////////////////
//   String rideIcon       = 'assets/icons/icon_ride.png';
//
//   //////////////////// Scan screen /////////////////
//   String arrowRightIcon            = 'assets/icons/icon_go.svg';
//   String emptyGuestsIcon           = 'assets/icons/icon_empty_guests.png';
//   String notFoundIcon              = 'assets/icons/icon_not_found.png';
//   String deniedIcon                = 'assets/icons/icon_denied.svg';
//   String missingAlertIcon          = 'assets/icons/icon_missing.svg';
//   String guestPlaceholderImage     = 'assets/images/profile_img.png';
//   String visitorPlaceholderImage   = 'assets/images/visitor_place_holder.png';
//   String swipeIcon                 = "assets/icons/icon_swipe.png";
//   abstract String swipeAnimatedIconIcon;
//   abstract String qrNotFound;
//
//   ////////////////////////// Create ride ////////////////////
//   final mapWideImage               = 'assets/images/image_wide_map.png';
//   final checkBox                   = 'assets/icons/check_box.svg';
//   final uncheckBox                 = 'assets/icons/unchecked_box.svg';
//
//   //////////////////   Map    ////////////////////
//   abstract String mapDestinationIcon;
//   abstract String mapPickupIcon;
//   String driverMarker             = "assets/icons/icon_map_driver_icon.png";
//
//   abstract String packagePlaceHolder;
//
//   /// ------------------------------ Deep Search -------------------------------
//   String deepSearchArrowImage        = 'assets/images/deep_search_arrow.svg';
//   String nothingWasFoundImage        = 'assets/images/nothing_found_image.svg';
//
//
//   /// ----------------------------- Guest details ------------------------------
//   final messageChatIcon              = 'assets/icons/icon_message_chat.svg';
//   final itineraryIcon                = 'assets/icons/icon_itinerary.svg';
//   final reservationBgIcon            = 'assets/icons/icon_agenda_hotel.svg';
//   final agendaCardEye                = "assets/icons/icon_agenda_eye.svg";
//   final agendaCardMatch              = "assets/icons/icon_agenda_session.svg";
//   final agendaCardHotel              = "assets/icons/icon_agenda_hotel.svg";
//   final agendaCardFlight             = "assets/icons/icon_agenda_flight.svg";
//   final agendaCardRide               = "assets/icons/icon_agenda_ride.svg";
//
//
//   // ----------------------------- Home New Screen -----------------------------
//   abstract String emptyUpcomingImage;
//   abstract String emptyGuestsImage;
//
//
//   final eventPlaceHolderIcon         = "assets/icons/event_place_holder_icon.png";
//   final errorBackgroundImage         = "assets/images/error_background_image.svg";
//   final errorSearchImage             = "assets/images/error_search_image.svg";
//   final errorCardsImage              = "assets/images/error_cards_image.svg";
//   final fileImage                    = "assets/images/file_image.svg";
//   final errorAttendeeImage           = "assets/images/error_attendee.svg";
//   final errorRidesImage              = "assets/images/error_rides_image.svg";
//   final filterImage                  = "assets/images/filter.svg";
//   final errorMessageImage            = "assets/images/error_message_image.svg";
//   final safariIcon                   = "assets/icons/safari_icon.png";
//   final chromeIcon                   = "assets/icons/chrome_icon.png";
//   final edgeIcon                     = "assets/icons/edge_icon.png";
//   final operaIcon                    = "assets/icons/opera_icon.png";
//   final noMatchesFoundImage          = "assets/images/no_matches_found.png";
//   final bellImage                    = "assets/images/bell.svg";
//   final qrcodeImage                  = "assets/images/qrcode_image.svg";
//   final searchImage                  = "assets/images/search_image.svg";
//
// }
//
//
//
//
// class DarkAssets extends MyAssets {
//   //////////////////////   LogIn    //////////////////////////
//   @override
//   String successImage = 'assets/images/image_success_dark.png';
//
//   ////////////////////////// Map ////////////////////
//   @override
//   String googleMapStyle         = googleMapStyleDark;
//   @override
//   String markerLocationIcon     = 'assets/icons/icon_marker_location.png';
//   @override
//   String mapAddressIcon         = "assets/images/image_map_dark.png";
//   @override
//   String swipeAnimatedIconIcon  = 'assets/lottie/swipe_dark.json';
//
//   //////////////     map    ///////////////
//   @override
//   String mapDestinationIcon = "assets/icons/icon_map_destination_dark.png";
//   @override
//   String mapPickupIcon      = "assets/icons/icon_map_pickup_dark.png";
//
//   @override
//   String packagePlaceHolder      = "assets/images/package_placeholder_dark.png";
//
//   // ----------------------------- Home New Screen -----------------------------
//   @override
//   String emptyUpcomingImage      = "assets/images/empty_upcoming_dark.svg";
//   @override
//   String emptyGuestsImage        = "assets/images/empty_guests_dark.svg";
//
//
//   @override
//   String qrNotFound                = 'assets/icons/qr_not_found_dark.png';
//
// }
//
// class LightAssets extends MyAssets {
//   //////////////////////   LogIn    //////////////////////////
//   @override
//   String successImage = 'assets/images/image_success_light.png';
//
//   ////////////////////////// Map ////////////////////
//   @override
//   String googleMapStyle          = googleMapStyleLight;
//   @override
//   String markerLocationIcon      = 'assets/icons/icon_marker_location_gray.png';
//   @override
//   String mapAddressIcon          = "assets/images/image_map_light.png";
//   @override
//   String swipeAnimatedIconIcon   = 'assets/lottie/swipe_light.json';
//
//   //////////////     map    ///////////////
//   @override
//   String mapDestinationIcon = "assets/icons/icon_map_destination_light.png";
//   @override
//   String mapPickupIcon      = "assets/icons/icon_map_pickup_light.png";
//
//   @override
//   String packagePlaceHolder      = "assets/images/package_placeholder_light.png";
//
//   // ----------------------------- Home New Screen -----------------------------
//   @override
//   String emptyUpcomingImage      = "assets/images/empty_upcoming_light.svg";
//   @override
//   String emptyGuestsImage        = "assets/images/empty_guests_light.svg";
//
//   @override
//   String qrNotFound                = 'assets/icons/qr_not_found_light.png';
// }



class AppImages {
  static String logoPNGDark          = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/logo_dark.png";
  static String logoPNGLight         = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/logo_light.png";
  static String appIcon              = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/icon.png";
  static String logoPNGLightDesc     = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/logo_description_light.png";
  static String logoPNGDarkDesc      = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/logo_description_dark.png";
  static String poweredByLogo        = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/icon_powered_by.svg";

  static String swipeDark            = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/swipe_dark.json";
  static String swipeLight           = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/swipe_light.json";

  static String backgroundImage      = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/background_image.png";
  static String splashLogoDark       = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/splash_screen_dark.json";
  static String splashLogoLight      = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/splash_screen_light.json";
  static String video                = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/video.mp4";
  static String loadingSpinnerDark   = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/loading_spinner_dark.json";
  static String loadingSpinnerLight  = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/loading_spinner_light.json";
  static String placeholderImage     = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/image_placeholder.jpg";
  static String userPlaceholderLight = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/user_placeholder_light.png";
  static String userPlaceholderDark  = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/user_placeholder_dark.png";

  static String noDataDarkImage      = 'assets/images/no_data_dark.png';
  static String noDataLightImage     = 'assets/images/no_data_light.png';

  static String updateLogo           = "assets/app_images/${incidentsModuleFlavorConfig?.folderName}/icon_update.png";

  static String eventPlaceHolderIcon         = "assets/icons/event_place_holder_icon.png";
  static String errorBackgroundImage         = "assets/images/error_background_image.svg";
  static String errorSearchImage             = "assets/images/error_search_image.svg";
  static String errorCardsImage              = "assets/images/error_cards_image.svg";
  static String fileImage                    = "assets/images/file_image.svg";
  static String errorAttendeeImage           = "assets/images/error_attendee.svg";
  static String errorRidesImage              = "assets/images/error_rides_image.svg";
  static String filterImage                  = "assets/images/filter.svg";
  static String errorMessageImage            = "assets/images/error_message_image.svg";
  static String safariIcon                   = "assets/icons/safari_icon.png";
  static String chromeIcon                   = "assets/icons/chrome_icon.png";
  static String edgeIcon                     = "assets/icons/edge_icon.png";
  static String operaIcon                    = "assets/icons/opera_icon.png";
  static String noMatchesFoundImage          = "assets/images/no_matches_found.png";
  static String bellImage                    = "assets/images/bell.svg";
  static String qrcodeImage                  = "assets/images/qrcode_image.svg";
  static String searchImage                  = "assets/images/search_image.svg";
  static String warningImage                 = 'assets/images/warning_image.png';
  static String errorImage                   = 'assets/images/image_error_image.png';
  static String guestPlaceholderImage        = 'assets/images/profile_img.png';
  static String mapWideImage                 = 'assets/images/image_wide_map.png';
  static String markerLocationIconDark       = "assets/icons/icon_marker_location.png";
  static String markerLocationIconLight      = "assets/icons/icon_marker_location_gray.png";
  static String mapAddressIconDark           = "assets/images/image_map_dark.png";
  static String mapAddressIconLight          = "assets/images/image_map_light.png";
}

