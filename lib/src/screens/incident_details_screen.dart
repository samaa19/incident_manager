import 'package:blink_component/blink_component.dart';
import 'package:blink_component/controllers/pdf_bottom_sheet_controller.dart';
import 'package:blink_component/models/capacity_indicator.dart';
import 'package:blink_component/models/incident/create_incident_scope_names.dart';
import 'package:blink_component/models/incident/incident_model.dart';
import 'package:blink_component/models/role_access_model.dart';
import 'package:blink_component/widgets/card_widgets/incident_card/incident_card.dart';
import 'package:blink_component/widgets/map_widgets/location_map_widget.dart';
import 'package:blink_component/widgets/skeleton_widgets/view_details_screen_skeleton.dart';
import 'package:blink_component/widgets/updates/update_attachment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:incident_manager/incident_manager.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/assets.dart';
import '../controllers/incident_details_controller.dart';
import '../utils/helpers_functions.dart';
import 'create_incident_screen.dart';

class IncidentDetailsScreen extends StatefulWidget {
  final MyColorsPalette palette;
  final bool isDark;
  final bool isCreationFlow;

  const IncidentDetailsScreen({
    super.key,
    required this.palette,
    required this.isDark,
    this.isCreationFlow = false,
  });

  @override
  State<IncidentDetailsScreen> createState() => _IncidentDetailsScreenState();
}

class _IncidentDetailsScreenState extends State<IncidentDetailsScreen> with SingleTickerProviderStateMixin  {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    Get.find<PDFBottomSheetController>().init(this);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final hasFullAccess = Get.find<RolesAccessController>().hasRoleAccess(roleKey: RoleAccessKey.incidentsAccess, minimumLevel: AccessLevel.fullAccess);

    return Scaffold(
      backgroundColor: palette.themeColorsSurfaceElevationSurface,
      body: GetBuilder<IncidentDetailsController>(
          builder: (incidentController) {
            return Obx(() {
              if(incidentController.showLoading.isTrue){
                return ViewIncidentDetailsSkeleton(
                  palette: palette,
                  appBorders: incidentsModuleAppBorders,
                  appIcons: incidentsModuleAppIcons,
                  onBack:  ()  {
                    if(widget.isCreationFlow) {
                      Get.back();
                    }
                    Get.back();
                  },
                );
              }
              return Stack(
                children: [
                  Column(
                    children: [
                      CustomAppBarNewDesignV2(
                        scrollController: scrollController,
                        title: incidentDetailsTextKey,
                        palette: palette,
                        appIcons: incidentsModuleAppIcons,
                        borderRadius: incidentsModuleAppBorders.plus,
                        onBack: () async {
                          if(widget.isCreationFlow) {
                            Get.back();
                          }
                          Get.back();
                        },
                        actions:Obx(
                              () => !incidentController.showLoading.value && incidentController.incidentModel != null
                              ? PullDownButton(
                            itemBuilder: (context) => [
                              PullDownMenuItem(
                                title: incidentController.incidentModel!.status == IncidentStatus.open
                                    ? keyEditText.tr
                                    : keyReopen.tr,
                                enabled: hasFullAccess,
                                onTap: () {
                                  incidentController.incidentModel!.status == IncidentStatus.open
                                      // ? Get.toNamed(createIncidentRouteText, arguments: [widget.tagOfController, incidentController.incidentModel])
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CreateIncidentScreen(
                                                palette: palette,
                                                isDark: widget.isDark,
                                                incidentModel: incidentController.incidentModel,
                                              ),
                                            ),
                                          )
                                        : updateIncidentStatus(
                                      context: context,
                                      palette: palette,
                                      isDark: widget.isDark,
                                      controller: incidentController,
                                      incidentId: incidentController.incidentModel!.id,
                                      incidentStatus: incidentController.incidentModel!.status,
                                      onUpdateIncidentStatus: () {
                                        Navigator.of(context).pop();
                                        incidentController.incidentModel!.status = IncidentStatus.open;
                                        incidentController.update();
                                        incidentController.updateStatisticsMainScreenData(context);
                                      });
                                },
                                iconWidget: Icon(
                                  incidentController.incidentModel!.status == IncidentStatus.open
                                      ? incidentsModuleAppIcons.editIcon
                                      : incidentsModuleAppIcons.undoIcon,
                                  size: 20,
                                  color: hasFullAccess ? getPaletteColor(palette.themeColorsIconNeutral) : getPaletteColor(palette.themeColorsIconNeutral) .withOpacity(.5),
                                ),
                                itemTheme: PullDownMenuItemTheme(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: hasFullAccess ? getPaletteColor(palette.themeColorsTextTitle) : getPaletteColor(palette.themeColorsTextTitle) .withOpacity(.5),
                                  ),
                                ),
                              ),
                              PullDownMenuItem(
                                title: deleteTextKey.tr,
                                enabled: hasFullAccess,
                                onTap: () {
                                  deleteIncident(
                                    context: context,
                                    palette: palette,
                                    isDark: widget.isDark,
                                    deleteIncident: () {
                                        incidentController.deleteIncident(
                                          isDark: widget.isDark,
                                          incidentId: incidentController.incidentModel!.id,
                                          palette: palette,
                                          context: context,
                                          loadingSpinner: widget.isDark ? AppImages.loadingSpinnerDark :AppImages.loadingSpinnerLight,
                                          loadingLottieFile: widget.isDark
                                              ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
                                              : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight ?? '',
                                        );
                                      },
                                  );
                                },
                                iconWidget: Icon(
                                  incidentsModuleAppIcons.deleteIcon,
                                  size: 20,
                                  color: hasFullAccess ? getPaletteColor(palette.themeColorsDangerDefault) : getPaletteColor(palette.themeColorsDangerDefault) .withOpacity(.5),
                                ),
                                itemTheme: PullDownMenuItemTheme(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: hasFullAccess ? getPaletteColor(palette.themeColorsDangerDefault) : getPaletteColor(palette.themeColorsDangerDefault) .withOpacity(.5),
                                  ),
                                ),
                              ),
                            ],
                            buttonBuilder: (context, showMenu) => IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: showMenu.call,
                              icon: Icon(
                                incidentsModuleAppIcons.ellipsisVerticalIconData,
                                color: getPaletteColor(palette.themeColorsActionGhostDefaultFg),
                                size: 20,
                              ),
                            ),
                          )
                              : const SizedBox(),
                        ),
                      ),
                      4.gap,

                      if(incidentController.incidentModel != null) ...{
                        Expanded(
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            children: [
                              info(
                                label: titleTextKey.tr,
                                palette: palette,
                                dataWidget: ReadMoreText(
                                  '${incidentController.incidentModel!.title}    ',
                                  trimLines: 3,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: readMoreTextKey.tr,
                                  trimExpandedText: readLessTextKey.tr,
                                  delimiter: " ... ",
                                  style: TextStyle(
                                    color: getPaletteColor(
                                        palette.themeColorsTextBody),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  moreStyle: TextStyle(
                                    color: getPaletteColor(
                                        palette.themeColorsTextBody),
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  lessStyle: TextStyle(
                                    color: getPaletteColor(
                                        palette.themeColorsTextBody),
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (incidentController.incidentModel!.description.isNotEmpty) ...[
                                20.gap,
                                info(
                                  label: key_body.tr,
                                  dataWidget: ReadMoreText(
                                    '${incidentController.incidentModel!.description}    ',
                                    trimLines: 3,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: readMoreTextKey.tr,
                                    trimExpandedText: readLessTextKey.tr,
                                    delimiter: " ... ",
                                    style: TextStyle(
                                      color: getPaletteColor(palette.themeColorsTextBody),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                    moreStyle: TextStyle(
                                      color: getPaletteColor(palette.themeColorsTextBody),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                    lessStyle: TextStyle(
                                      color: getPaletteColor(palette.themeColorsTextBody),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  isLink: true,
                                  palette: palette,
                                ),
                              ],

                              // SendUpdateHeadLineTitle(text: incidentController.incidentModel!.title, palette: palette),
                              20.gap,
                              divider(palette),
                              20.gap,
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: info(
                                        label: statusTextKey.tr,
                                        dataWidget: IncidentStatusWidget(
                                          incidentModel: incidentController.incidentModel!,
                                          appIcons: incidentsModuleAppIcons,
                                          appBorders: incidentsModuleAppBorders,
                                          palette: palette,
                                        ),
                                        palette: palette,
                                      ),
                                    ),
                                    Flexible(
                                      child: info(
                                        label: severityTextKey.tr,
                                        palette: palette,
                                        dataWidget: IncidentSeverityWidget(
                                          incidentModel: incidentController.incidentModel!,
                                          // flavorConfig: appConfigController.flavorConfig,
                                          appIcons: incidentsModuleAppIcons,
                                          appBorders: incidentsModuleAppBorders,
                                          palette: palette,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if ((incidentController.incidentModel!.date.isNotEmpty) ||
                                  (incidentController.incidentModel!.time.isNotEmpty)) ...[
                                20.gap,
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (incidentController.incidentModel!.date.isNotEmpty)
                                        Expanded(
                                          child: info(
                                            label: dateTextKey,
                                            dataText: incidentController.incidentModel!.getDisplayDate,
                                            palette: palette,
                                          ),
                                        ),
                                      if (incidentController.incidentModel!.time.isNotEmpty)
                                        Expanded(
                                          child: info(
                                            label: timeTextKey,
                                            palette: palette,
                                            dataText: incidentController.incidentModel!.getDisplayOnlyTime,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],

                              if (incidentController.incidentModel!.scope.isNotEmpty||incidentController.incidentModel!.scopeDetails != null) ...[
                                20.gap,
                                divider(palette),
                                20.gap,
                                info(
                                  label: scopeTextKey.tr,
                                  palette: palette,
                                  dataWidget: ScopeWidget(
                                    palette: palette,
                                    appIcons: incidentsModuleAppIcons,
                                    appBorders: incidentsModuleAppBorders,
                                    isDark: widget.isDark,
                                    incidentModel: incidentController.incidentModel!,
                                    capacityIndicators: capacityIndicators,                                    ),
                                )
                              ],
                              if(incidentController.incidentModel!.attachmentObjects.isNotEmpty) ...{
                                20.gap,
                                divider(palette),
                                20.gap,
                                info(
                                  label: attachmentsTextKey,
                                  palette: palette,
                                  dataWidget: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListView.separated(itemBuilder: (_,index)=> UpdateAttachmentWidget(
                                        palette: palette,
                                        withBackground:true,
                                        updateAttachmentModel: incidentController.incidentModel!.attachmentObjects[index],
                                        appBorders: incidentsModuleAppBorders,
                                        loadingSpinner: widget.isDark ? AppImages.loadingSpinnerDark : AppImages.loadingSpinnerLight,
                                        loadingSpinnerFile: widget.isDark
                                            ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
                                            : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight ?? '',
                                        appIcons: incidentsModuleAppIcons,
                                        withDownloadIcon:true,

                                        onDeleteClick: () {},
                                      ), separatorBuilder: (_,index)=> 4.gap, itemCount: incidentController.incidentModel!.attachmentObjects.length,padding: EdgeInsets.zero,physics: const NeverScrollableScrollPhysics(),shrinkWrap: true,),
                                    ],
                                  ),
                                ),
                              },
                              100.gap,
                            ],
                          ),
                        ),
                      }
                    ],
                  ),

                  // --Button Shadow
                  if(incidentController.incidentModel != null && incidentController.incidentModel!.status == IncidentStatus.open)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                getPaletteColor(palette.themeColorsSurfaceNeutralLevel00).withOpacity(0),
                                getPaletteColor(palette.themeColorsSurfaceNeutralLevel00),
                                getPaletteColor(palette.themeColorsSurfaceNeutralLevel00),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  //TODO: needs to be replaced with a button of ours - component identification
                  // --Bottom Button
                  if(incidentController.incidentModel != null && incidentController.incidentModel!.status == IncidentStatus.open)
                    Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: RoleRestrictedWidget(
                            roleKey: RoleAccessKey.incidentsAccess,
                            requiredLevel: AccessLevel.fullAccess,
                            disableOnlyInLimitedAccess: true,
                            disable: true,
                            child: PrimaryButtonWithIcon(
                              title: resolveIncidentTextKey.tr,
                              icon: incidentsModuleAppIcons.circleCheckIcon,
                              titleFontSize: 15,
                              onTap: () {
                                updateIncidentStatus(
                                  context: context,
                                  palette: palette,
                                  isDark: widget.isDark,
                                  controller: incidentController,
                                  incidentId: incidentController.incidentModel!.id,
                                  incidentStatus: incidentController.incidentModel!.status,
                                  onUpdateIncidentStatus: () {
                                    Navigator.of(context).pop();
                                    incidentController.incidentModel!.status = IncidentStatus.resolved;
                                    incidentController.update();
                                    incidentController.updateStatisticsMainScreenData(context);
                                  },
                                );
                              },
                            )
                        )
                    ),
                ],
              );
            });
          }
      ),
    );
  }

  Widget divider(MyColorsPalette palette)=>SizedBox(
    width: double.infinity,
    height: 16,
    child: Center(
      child: Container(
        width: double.infinity,
        height: 1,
        color:palette.themeColorsBorderNeutral11,
      ),
    ),
  );


}

Widget infoLabel(
    {required String label,
      required MyColorsPalette palette,
      Widget? leadingIcon}) =>
    Row(
      children: [
        Expanded(
          child: Text(
            label.tr,
            style: TextStyle(
                color: palette.themeColorsTextTitle,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
        ),
        if (leadingIcon != null) ...[4.gap, leadingIcon],
      ],
    );

Widget infoData({
  required String data,
  IconData? icon,
  required MyColorsPalette palette,
  bool isLink = false,
  int? maxLines,
}) =>
    Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: palette.themeColorsTextBody),
          5.gap,
        ],
        if (!isLink)
          Expanded(
              child: Text(
                data.tr,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: palette.themeColorsTextBody,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              )),
        if (isLink)
          Expanded(
              child: Linkify(
                onOpen: (link) async {
                  if (!await launchUrl(Uri.parse(link.url))) {
                    //  throw Exception('Could not launch ${link.url}');
                  }
                },
                text: data,
                style: TextStyle(
                    color: palette.themeColorsTextBody,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
                linkStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              )),
      ],
    );

Widget info({
  required String label,
  String? dataText,
  required MyColorsPalette palette,
  Widget? dataWidget,
  Widget? leadingIcon,
  bool isLink = false,
  int? dataMaxLines,
  double widgetTopSpace = 8,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        infoLabel(label: label, palette: palette, leadingIcon: leadingIcon),
        if (dataText != null) ...[
          8.gap,
          infoData(
              data: dataText,
              palette: palette,
              isLink: isLink,
              maxLines: dataMaxLines)
        ],
        if (dataWidget != null) ...[
          widgetTopSpace.gap,
          dataWidget,
        ],
      ],
    );

class ScopeWidget extends StatelessWidget {
  final MyColorsPalette palette;
  final AppIcons appIcons;
  final AppBorders appBorders;
  final bool isDark;
  final IncidentModel incidentModel;
  final List<CapacityIndicatorModel> capacityIndicators;

  const ScopeWidget({
    super.key,
    required this.palette,
    required this.appIcons,
    required this.appBorders,
    required this.incidentModel,
    required this.isDark,
    required this.capacityIndicators,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _getScopeWidget(context),

        // --Location if The scope is -other- or -attendee-
        /*
        venueModel.lat.isNotEmpty && venueModel.lng.isNotEmpty
        */
        if (fromStringToIncidentScopeType(incidentModel.scope) == IncidentScopeType.attendee ||
            fromStringToIncidentScopeType(incidentModel.scope) == IncidentScopeType.other) ...{
          // -- Location if it's already picked
          _location(lat: incidentModel.location?.lat ?? '', lng: incidentModel.location?.lng ?? '', address: incidentModel.location?.address??'', locationDetails: incidentModel.location?.locationDetails??''),
        },
        if (fromStringToIncidentScopeType(incidentModel.scope) == IncidentScopeType.venue ) ...{
          // -- Location if it's already picked
          _location(lat: (incidentModel.scopeDetails as VenueModel).lat , lng: (incidentModel.scopeDetails as VenueModel).lng, address: (incidentModel.scopeDetails as VenueModel).address, locationDetails:''),
        },
        if (fromStringToIncidentScopeType(incidentModel.scope) == IncidentScopeType.session ) ...{
          // -- Location if it's already picked
          _location(lat: (incidentModel.scopeDetails as Session).lat , lng: (incidentModel.scopeDetails as Session).lng, address: (incidentModel.scopeDetails as Session).address, locationDetails:''),
        }
      ],
    );
  }

  _location({required String lat,required String lng,required String address,required String locationDetails,}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lat.trim().isNotEmpty) ...{
          20.gap,
          LocationMapWidget(
            palette: palette,
            //temporary till the address got fixed in synced open sessions
            address: address,
            lat: lat,
            lng: lng,
            appBorders: appBorders,
            mapAddressIcon: isDark ? AppImages.markerLocationIconDark : AppImages.markerLocationIconLight,
            isDark: isDark,
            mapHeight: Get.width * 200 / 375,
            zoom: 16,
          ),
          if (locationDetails.isNotEmpty) ...{
            20.gap,
            info(
              label: locationDetailsTextKey.tr,
              palette: palette,
              dataText: locationDetails,
              dataMaxLines: 3,
            ),
          }
        }
      ],
    );
  }

  _getScopeWidget(BuildContext context) {

    if (fromStringToIncidentScopeType(incidentModel.scope) == IncidentScopeType.session && incidentModel.scopeDetails != null) {
      Session session = incidentModel.scopeDetails as Session;
      return Column(
        children: [
          NewCardDesign(
            appBorders: appBorders,
            appIcons: appIcons,
            palette: palette,
            onTap: () {
              // Todo: issue - navigate to session details
            },
            cardModel: session,
            capacityIndicators: capacityIndicators,
            isDark: isDark,
          ),
        ],
      );
    }
    else if (fromStringToIncidentScopeType(incidentModel.scope) == IncidentScopeType.venue && incidentModel.scopeDetails != null) {
      VenueModel venue = incidentModel.scopeDetails as VenueModel;
      return Column(
        children: [
          NewCardDesign(
            appBorders: appBorders,
            appIcons: appIcons,
            palette: palette,
            onTap: () {
              // navigateToStatisticsView(statisticsModel:  venue, statisticsType: StatisticsTypeEnum.venues, context: context);
            },
            cardModel: venue,
            capacityIndicators: [],
            isDark: isDark,
          ),
        ],
      );
    }
    else if (fromStringToIncidentScopeType(incidentModel.scope) == IncidentScopeType.attendee && incidentModel.scopeDetails != null) {
      GuestModel attendee = incidentModel.scopeDetails as GuestModel;
      return Column(
        children: [
          SimpleUserCardWithTitle(
            palette: palette,
            firstName: attendee.firstName,
            lastName: attendee.lastName,
            image: attendee.avatar,
            title: '',
            imageHeight: 32,
            imageWidth: 32,
            imageBorderColor: getPaletteColor(palette.themeColorsBorderNeutral11),
            nameTextStyle: defaultTextStyle(16, color: palette.themeColorsTextTitle, context: context),
            loadingSpinner: isDark ? AppImages.loadingSpinnerDark :AppImages.loadingSpinnerLight,
            userPlaceHolderImage: AppImages.guestPlaceholderImage,
            loadingSpinnerFile: isDark
                ? incidentsModuleFlavorConfig?.flavorAssets.loadingLottieDark ?? ''
                : incidentsModuleFlavorConfig?.flavorAssets.loadingLottieLight ?? '',
            userPlaceholderImageFile: AppImages.guestPlaceholderImage,
          ),
        ],
      );
    }
    else if (fromStringToIncidentScopeType(incidentModel.scope) == IncidentScopeType.other) {
      return Text(key_other.tr, style: TextStyle(color: getPaletteColor(palette.themeColorsTextBody)));
    }
    else {
      return Container();
    }
  }
}