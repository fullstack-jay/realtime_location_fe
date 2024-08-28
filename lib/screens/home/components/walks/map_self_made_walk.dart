import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/self_made_walks_controller.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_application_1/screens/movements/map/widgets/marker_custom.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
//import '../../../../utils/keys.dart';
import '../../../movements/map/widgets/warn_dialog.dart';
import '../../../movements/widgets/app_bar_2.dart';
import 'package:flutter_application_1/models/self_made_walk.dart';
import 'save_walk_dialog.dart';

enum SelfMadeWalkMapMode { idle, walk }

// Custom class to replace backend dependency
class SelfMadeWalkMap extends StatefulWidget {
  const SelfMadeWalkMap({
    super.key,
    required this.points,
    required this.mode,
    required this.startedAt,
    this.walk,
  });

  final Map<String, LatLng> points;
  final SelfMadeWalkMapMode mode;
  final DateTime startedAt;
  final SelfMadeWalk? walk;

  @override
  State<SelfMadeWalkMap> createState() => _SelfMadeWalkMapState();
}

class _SelfMadeWalkMapState extends State<SelfMadeWalkMap> {
  final walkController = Get.put(WalksController());
  final profile = AuthService().getAuth();

  late LatLng origin;
  late LatLng destination;
  LatLng? currentLocation;

  double zoomLevel = 17;
  Map<String, Marker> markers = {};
  GoogleMapController? googleMapController;

  List<LatLng> polylineDestinationCoordinates = [];
  List<LatLng> polylineCurrentLocationCoordinates = [];

  @override
  void initState() {
    origin = widget.points["origin"]!;
    destination = widget.points["destination"]!;
    //getRoutePolylines();

    if (widget.mode == SelfMadeWalkMapMode.walk) {
      polylineCurrentLocationCoordinates = [origin];
      getLocation();
    } else {
      polylineCurrentLocationCoordinates = widget.walk!.coordinates;
    }
    super.initState();
  }

  void getRoutePolylines() async {
    try {
      // Dummy polyline points
      List<PointLatLng> dummyPoints = [
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(origin.latitude + 0.01, origin.longitude + 0.01),
        PointLatLng(destination.latitude, destination.longitude),
      ];

      for (PointLatLng point in dummyPoints) {
        polylineDestinationCoordinates
            .add(LatLng(point.latitude, point.longitude));
      }

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  void getLocation() async {
    Location location = Location();
    final locationData = await location.getLocation();
    setState(() {
      currentLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
    });
    if (!mounted) return;
    location.onLocationChanged.listen((newLoc) async {
      if (!mounted) return;
      setState(() {
        currentLocation = LatLng(
          newLoc.latitude!,
          newLoc.longitude!,
        );
      });

      if (googleMapController != null) {
        await addMarker(
          "lokasi saat ini",
          currentLocation!,
          "Reza, Lokasi saat ini",
          "Ini adalah lokasi kamu saat ini",
        );
        googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: zoomLevel,
              target:
                  LatLng(currentLocation!.latitude, currentLocation!.longitude),
            ),
          ),
        );
        if (!mounted) return;
        setState(() {
          polylineCurrentLocationCoordinates.add(currentLocation!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.mode == SelfMadeWalkMapMode.idle) {
          return true;
        }
        final leave = await showDialog<bool>(
          context: context,
          barrierColor: Colors.black26,
          builder: (context) {
            return const WarnDialogWidget(
              title: "Berhenti Bepergian",
              subtitle:
                  "Perubahan yang dilakukan pada halaman ini tidak akan disimpan. Apakah Anda yakin ingin menutupnya?",
              okButtonText: "Keluar",
            );
          },
        );
        if (leave == true) {
          return true;
        }
        return false;
      },
      child: Container(
        color: primary,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: primary,
              elevation: 0.0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              flexibleSpace: Hero(
                tag: "appbar-hero-custom-1",
                child: Material(
                  color: Colors.transparent,
                  child: AnotherCustomAppBar(
                    title: widget.walk == null
                        ? "Self-made Walk"
                        : cfl(widget.walk!.title),
                  ),
                ),
              ),
              toolbarHeight: 100.h,
            ),
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                Container(
                  color: Colors.grey.shade300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: origin,
                      zoom: zoomLevel,
                    ),
                    mapType: MapType.hybrid,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("destination-route"),
                        points: polylineDestinationCoordinates,
                        color: lightPrimary,
                      ),
                      Polyline(
                        polylineId: const PolylineId("current-route"),
                        points: polylineCurrentLocationCoordinates,
                        color: Colors.green.shade400,
                        width: 8,
                        zIndex: 1,
                      ),
                    },
                    myLocationButtonEnabled: false,
                    onCameraMove: (position) {
                      if (widget.mode == SelfMadeWalkMapMode.walk) {
                        if (!mounted) return;
                        setState(() {
                          zoomLevel = position.zoom;
                        });
                      }
                    },
                    onMapCreated: (controller) {
                      googleMapController = controller;
                      addMarker(
                        "origin",
                        origin,
                        "Origin",
                        "The origin location",
                      );
                      addMarker(
                        "destination",
                        destination,
                        "Destination",
                        "The destination location",
                      );
                      if (widget.mode == SelfMadeWalkMapMode.idle &&
                          widget.walk != null) {
                        addMarker(
                          "final-made-destination",
                          widget.walk!.coordinates.last,
                          "Where I stopped",
                          "This travel took ${getTimer(widget.walk!.createdAt, widget.walk!.endedAt)}",
                        );
                      }
                    },
                    markers: markers.values.toSet(),
                  ),
                ),
                if (widget.mode == SelfMadeWalkMapMode.walk)
                  Positioned(
                    bottom: 20.h,
                    right: 20.w,
                    left: 20.w,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (currentLocation == null) return;
                        final name = await showGeneralDialog<String>(
                          context: context,
                          barrierLabel: "save-walk",
                          barrierColor: Colors.black26,
                          barrierDismissible: true,
                          transitionDuration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final tween = Tween(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            );
                            return SlideTransition(
                              position: tween.animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: child,
                            );
                          },
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const SaveWalkDialog();
                          },
                        );
                        if (name == null) return;
                        await Future.delayed(const Duration(milliseconds: 400));
                        final walk = SelfMadeWalk(
                          id: 1,
                          initialPosition: origin,
                          coordinates: polylineCurrentLocationCoordinates,
                          destinationPosition: destination,
                          title: name,
                          createdAt: widget.startedAt,
                          creatorId: AuthService().getAuth()?.userId ?? "unknown-user",
                          endedAt: DateTime.now(),
                        );
                        // Logic to handle saved walk locally
                        await walkController.addWalk(walk);
                        if (!mounted) return;
                        popPage(context);
                      },
                      child: const Text("Stop"),
                    ),
                  )
              ],
            ),
            floatingActionButton: googleMapController == null ||
                    widget.mode != SelfMadeWalkMapMode.idle
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      googleMapController
                          ?.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          zoom: zoomLevel,
                          target: polylineCurrentLocationCoordinates[
                              polylineCurrentLocationCoordinates.length - 1],
                        ),
                      ));
                    },
                    backgroundColor: primary,
                    child: Icon(
                      Icons.share_location,
                      size: 28.sp,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  addMarker(String id, LatLng location, String title, String desc) async {
    Marker marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: title,
        snippet: desc,
      ),
    );

    if (id == "final-made-destination" || id == "currentLocation") {
      marker = await customMarker(
        MoveUser(
          user: User(
            id: id,
            imgUrl: "your_profile_pic_url", // Placeholder for user profile pic
            username: "You",
            joinedAt: "your_joined_date", // Placeholder for joined date
          ),
          location: location,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      markers[id] = marker;
    });
  }
}
