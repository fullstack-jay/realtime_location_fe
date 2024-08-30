import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/screens/home/components/walks/map_self_made_walk.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../utils/colors.dart';
import '../../../movements/map/widgets/warn_dialog.dart';
import 'package:flutter_application_1/models/self_made_walk.dart';
import 'package:get/get.dart';
import '../../../../controllers/self_made_walks_controller.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class SelfMadeWalksWidget extends StatefulWidget {
  const SelfMadeWalksWidget({Key? key}) : super(key: key);

  @override
  State<SelfMadeWalksWidget> createState() => _SelfMadeWalksWidgetState();
}

class _SelfMadeWalksWidgetState extends State<SelfMadeWalksWidget> {
  // Updated mock data with all fields initialized
  final walkController = Get.put(WalksController());
  final profile = AuthService().getAuth();

  // Data dummy yang sudah didefinisikan sebelumnya
  final List<SelfMadeWalk> walks = [
    SelfMadeWalk(
      id: 1,
      initialPosition: LatLng(37.7749, -122.4194),
      coordinates: [LatLng(37.7749, -122.4194), LatLng(37.7849, -122.4094)],
      destinationPosition: LatLng(37.7849, -122.4094),
      title: "Ciujung",
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      creatorId: "Rizqi Reza Ardiansyah",
      endedAt: DateTime.now().subtract(Duration(hours: 22)),
    ),
    SelfMadeWalk(
      id: 2,
      initialPosition: LatLng(34.0522, -118.2437),
      coordinates: [LatLng(34.0522, -118.2437), LatLng(34.0622, -118.2537)],
      destinationPosition: LatLng(34.0622, -118.2537),
      title: "Balaraja Barat",
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      creatorId: "Surya damarjati",
      endedAt: DateTime.now().subtract(Duration(days: 1, hours: 22)),
    ),
  ];

  void getWalks() {
    walkController.getWalks();
  }

  void _handleDelete(SelfMadeWalk walk) async {
    walkController.removeWalk(walk);
  }

  @override
  void initState() {
    getWalks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    walks.sort((a, b) => b.endedAt.compareTo(a.endedAt));
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Perjalanan yang sudah dilakukan",
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (walks.isNotEmpty)
              Text(
                walks.length.toString(),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (walks.isNotEmpty)
              Icon(
                Icons.travel_explore,
                size: 22.sp,
                color: primary,
              ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15.h),
          height: walks.isNotEmpty ? 190.h : null,
          child: walks.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(18.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 30.sp,
                        color: primary,
                      ),
                      addVerticalSpace(20),
                      Text(
                        "Belum ada jalan yang disimpan, Klik mulai berjalan di bawah",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: walks.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    final walk = walks[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            color: lightPrimary,
                          )
                        ],
                        borderRadius: BorderRadius.circular(8.r),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/map.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: 190.w,
                      margin: EdgeInsets.only(right: 15.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.r,
                          horizontal: 15.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: const [
                                  BoxShadow(
                                    color: veryLightGrey,
                                    blurRadius: 50,
                                    offset: Offset(-2, -2),
                                  )
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 1.5.h,
                              ),
                              child: Text(
                                timeago.format(walk.createdAt),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: CircleAvatar(
                                radius: 32.r,
                                foregroundImage:
                                    const AssetImage('assets/images/reza.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                walk.title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  color: white,
                                  fontSize: 16.sp,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (walk != null &&
                                        walk.initialPosition != null &&
                                        walk.destinationPosition != null) {
                                      Map<String, LatLng> points = {
                                        "origin": walk.initialPosition!,
                                        "destination":
                                            walk.destinationPosition!,
                                      };

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SelfMadeWalkMap(
                                            points: points,
                                            mode: SelfMadeWalkMapMode.idle,
                                            startedAt: DateTime.now(),
                                            walk:
                                                walk, // Pastikan walk tidak null
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Jika salah satu dari posisi atau walk null, tampilkan data dummy
                                      Map<String, LatLng> dummyPoints = {
                                        "origin": LatLng(0.0, 0.0),
                                        "destination": LatLng(0.0, 0.0),
                                      };

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SelfMadeWalkMap(
                                            points: dummyPoints,
                                            mode: SelfMadeWalkMapMode.idle,
                                            startedAt: DateTime.now(),
                                            walk: SelfMadeWalk(
                                              // Buat dummy walk untuk sementara
                                              id: 0,
                                              initialPosition: LatLng(0.0, 0.0),
                                              coordinates: [LatLng(0.0, 0.0)],
                                              destinationPosition:
                                                  LatLng(0.0, 0.0),
                                              title: "Dummy Walk",
                                              createdAt: DateTime.now(),
                                              creatorId: "Dummy Creator",
                                              endedAt: DateTime.now(),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 7.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  child: Text(
                                    "Lihat Perjalanan",
                                    style: TextStyle(
                                      fontSize: 9.7.sp,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final leave = await showDialog<bool>(
                                      context: context,
                                      barrierColor: Colors.black26,
                                      builder: ((context) {
                                        return const WarnDialogWidget(
                                          title: "Hapus Perjalanan",
                                          subtitle:
                                              "Apakah kamu yakin ingin menghapus perjalanan?",
                                          okButtonText: "Hapus",
                                        );
                                      }),
                                    );
                                    if (leave == true) {
                                      _handleDelete(walk);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 7.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    size: 22.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
        ),
      ],
    );
  }
}
