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
import 'package:google_api_availability/google_api_availability.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/keys.dart';
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
  Location location = Location();

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

    getRoutePolylines();
    _checkGoogleServicesAvailability();

    if (widget.mode == SelfMadeWalkMapMode.walk) {
      polylineCurrentLocationCoordinates = [origin];
      getLocation();
    } else {
      polylineCurrentLocationCoordinates = widget.walk!.coordinates;
    }
    super.initState();
  }

  Future<void> _checkGoogleServicesAvailability() async {
    GooglePlayServicesAvailability availability = await GoogleApiAvailability
        .instance
        .checkGooglePlayServicesAvailability();

    if (availability == GooglePlayServicesAvailability.success) {
      _setupLocationTracking();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Layanan Google Tidak Tersedia"),
          content: const Text(
              "Google Play Services tidak tersedia di perangkat ini. Fitur peta mungkin tidak berfungsi dengan baik."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      _setupLocationFallback();
    }
  }

  void _setupLocationTracking() async {
    // Aktifkan mode akurasi tinggi dengan interval dan jarak minimum
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 5000, // Update lokasi setiap 5 detik
      distanceFilter: 10, // Update lokasi setiap 10 meter
    );

    // Meminta izin lokasi jika belum diperoleh
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Memulai pelacakan lokasi
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        this.currentLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });

      _updateMap();
    });
  }

  void _setupLocationFallback() async {
    // Menyediakan fallback jika Google Play Services tidak tersedia
    // Memulai pelacakan lokasi menggunakan `Location` tanpa Google Play Services
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Mulai melacak lokasi
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        this.currentLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });

      _updateMap();
    });
  }

  void _updateMap() {
    if (googleMapController != null) {
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: zoomLevel,
            target: LatLng(
              currentLocation!.latitude,
              currentLocation!.longitude,
            ),
          ),
        ),
      );

      setState(() {
        polylineCurrentLocationCoordinates.add(currentLocation!);
      });
    }
  }

  void getRoutePolylines() async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(
          origin.latitude,
          origin.longitude,
        ),
        PointLatLng(
          destination.latitude,
          destination.longitude,
        ),
      );
      if (result.points.isNotEmpty) {
        for (PointLatLng point in result.points) {
          polylineDestinationCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
        if (!mounted) return;
        setState(() {});
      }
    } catch (e) {
      // print("Unstable internet connection error");
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
              target: LatLng(
                currentLocation!.latitude,
                currentLocation!.longitude,
              ),
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
                        ? "Membuat Perjalanan"
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
                        polylineId: const PolylineId("rute-tujuan"),
                        points: polylineDestinationCoordinates,
                        color: lightPrimary,
                      ),
                      Polyline(
                        polylineId: const PolylineId("posisi-sekarang"),
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
                        "asal",
                        origin,
                        "Asal",
                        "Lokasi Asal",
                      );
                      addMarker(
                        "tujuan",
                        destination,
                        "Tujuan",
                        "Lokasi Tujuan",
                      );
                      if (widget.mode == SelfMadeWalkMapMode.idle &&
                          widget.walk != null) {
                        addMarker(
                          "tujuan-akhir-yang-dibuat",
                          widget.walk!.coordinates.last,
                          "Dimana saya berhenti",
                          "Perjalanan ini memakan waktu ${getTimer(widget.walk!.createdAt, widget.walk!.endedAt)}",
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
                          barrierLabel: "simpan-perjalanan",
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
                          creatorId: AuthService().getAuth()?.userId ??
                              "user-tidak-dikenal",
                          endedAt: DateTime.now(),
                        );
                        // Logic to handle saved walk locally
                        await walkController.addWalk(walk);
                        if (!mounted) return;
                        popPage(context);
                      },
                      child: const Text("Berhenti"),
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
            imgUrl:
                ("assets/images/reza.png"), // Placeholder for user profile pic
            username: "Reza",
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
