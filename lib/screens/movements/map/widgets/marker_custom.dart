import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:screenshot/screenshot.dart';

// Simple user class to replace MoveUser model
class CustomUser {
  final String id;
  final String username;
  final String imgUrl;
  final String joinedAt;

  CustomUser({
    required this.id,
    required this.username,
    required this.imgUrl,
    required this.joinedAt,
  });
}

// Simple class to replace MoveUser model
class CustomMoveUser {
  final CustomUser user;
  final LatLng location;

  CustomMoveUser({
    required this.user,
    required this.location,
  });
}

Future<Marker> customMarker(CustomMoveUser customMoveUser) async {
  final cont = ScreenshotController();
  final bytes = await cont.captureFromWidget(Material(
    color: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: lightPrimary,
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipOval(
            child: Image.network(
              customMoveUser.user.imgUrl,
              fit: BoxFit.cover,
              width: 35,
              height: 35,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: lightPrimary,
            borderRadius: BorderRadius.circular(25),
          ),
          width: 15,
          height: 15,
        ),
      ],
    ),
  ));

  return Marker(
    markerId: MarkerId(customMoveUser.user.id),
    position: customMoveUser.location,
    infoWindow: InfoWindow(
      title: customMoveUser.user.username,
      snippet: customMoveUser.user.joinedAt,
    ),
    icon: BitmapDescriptor.fromBytes(bytes),
  );
}
