import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';

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
          type: 'exercise',
          createdAt: DateTime.now().subtract(Duration(hours: 1)),
          text: 'Morning Run',
        ),
        Activity(
          id: 2,
          type: 'study',
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          text: 'Read Flutter Documentation',
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
                  "No activities detected yet!",
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
                      "Activities".toUpperCase(),
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
                                title: "Move All Activities to Trash",
                                subtitle:
                                    "Are you sure do you want to delete all activities history?",
                                okButtonText: "Delete All",
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
