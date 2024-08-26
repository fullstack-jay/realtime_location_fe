import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
//import './over_map_widget.dart';

import 'widgets/circular_fab_widget.dart';

class MovementLiveMap extends StatefulWidget {
  const MovementLiveMap({
    super.key,
    required this.movementTitle, // Updated to take only a title instead of the entire movement
  });

  final String movementTitle;

  @override
  State<MovementLiveMap> createState() => _MovementLiveMapState();
}

class _MovementLiveMapState extends State<MovementLiveMap> {
  GoogleMapController? mapController;
  Map<String, Marker> markers = {};
  LatLng? currentLocation;
  double zoomLevel = 18;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    if (!mounted) return;
    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });

    location.onLocationChanged.listen((newLoc) {
      if (!mounted) return;
      setState(() {
        currentLocation = LatLng(newLoc.latitude!, newLoc.longitude!);
      });

      if (mapController != null) {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: zoomLevel,
              target: currentLocation!,
            ),
          ),
        );

        addMarker(
          "Current Location",
          currentLocation!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final leave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Leave movement"),
            content:
                const Text("Are you sure you want to leave this movement?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Stay"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Leave"),
              ),
            ],
          ),
        );
        return leave ?? false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            if (currentLocation != null)
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation!,
                  zoom: zoomLevel,
                ),
                compassEnabled: false,
                mapType: MapType.hybrid,
                onMapCreated: (controller) {
                  mapController = controller;
                  addMarker(
                    "You",
                    currentLocation!,
                  );
                },
                myLocationButtonEnabled: false,
                markers: markers.values.toSet(),
                onCameraMove: (position) {
                  if (!mounted) return;
                  setState(() {
                    zoomLevel = position.zoom;
                  });
                },
              ),
            if (currentLocation == null)
              const Center(
                child: Text("Loading current location..."),
              ),
            // OverMapWidget(
            //   membersLength: 5, // Placeholder value for number of members
            // ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: mapController != null
            ? CircularFabWidget(
                gMapController: mapController!, id: widget.movementTitle)
            : null,
      ),
    );
  }

  addMarker(String markerId, LatLng location) async {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: location,
      infoWindow: InfoWindow(title: markerId),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }
}
