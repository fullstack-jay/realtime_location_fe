import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_application_1/models/activity.dart';

import '../movements/map/widgets/warn_dialog.dart';
import 'activity_tile.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  late List<Activity> activities;

  _init() {
    setState(() {
      activities = [
        Activity(
          id: 1,
          type: ActivityType.add,
          creatorId: "Adam",
          createdAt: DateTime.now().subtract(Duration(hours: 1)),
          text: 'Inspeksi bersama tim BPJT',
        ),
        Activity(
          id: 2,
          type: ActivityType.delete,
          creatorId: "Rizqi",
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          text: 'Memadamkan api di KM 52',
        ),
        Activity(
          id: 3,
          type: ActivityType.add,
          creatorId: "Ardiansyah",
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          text: 'Membantu kecelakaan di KM 60',
        ),
      ];
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return activities.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber,
                  size: 30.sp,
                  color: lightPrimary,
                ),
                const Text(
                  "Belum ada aktivitas yang terdeteksi!",
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Aktivitas".toUpperCase(),
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: primary),
                    ),
                    if (activities.length > 20)
                      GestureDetector(
                        onTap: () async {
                          final delete = await showDialog<bool>(
                            context: context,
                            barrierColor: Colors.black26,
                            builder: ((context) {
                              return const WarnDialogWidget(
                                title: "Pindahkan Semua Aktivitas ke Sampah",
                                subtitle:
                                    "Apakah Anda yakin ingin menghapus semua riwayat aktivitas?",
                                okButtonText: "Hapus Semua",
                              );
                            }),
                          );
                          if (delete == true) {
                            setState(() {
                              activities.clear(); // Clear all activities
                            });
                          }
                        },
                        child: Icon(
                          Icons.delete_outline,
                          size: 24.sp,
                          color: primary,
                        ),
                      ),
                  ],
                ),
                addVerticalSpace(5),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: activities
                          .map(
                            (activity) => ActivityTile(
                              activity: activity,
                              onDelete: (id) async {
                                setState(() {
                                  activities.removeWhere(
                                      (activity) => activity.id == id);
                                });
                                return true;
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
