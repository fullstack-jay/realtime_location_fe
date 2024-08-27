import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Remove imports related to backend and models
//import 'package:quickstep_app/models/notification.dart';
//import 'package:quickstep_app/services/db_service.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import '../widgets/icon_shadow_button.dart';
import 'widgets/notification_tile.dart';
import 'package:flutter_application_1/models/notification.dart';

// Sample static data for notifications
List<AppNotification> dummyNotifications = [
  AppNotification(
    id: "1",
    createdAt: DateTime.now().subtract(Duration(minutes: 5)),
    action: NotificationAction.join,
    message: "Anda telah diundang untuk bergabung dengan perjalan ini.",
    data: {},
  ),
  AppNotification(
    id: "2",
    createdAt: DateTime.now().subtract(Duration(hours: 2)),
    action: NotificationAction.unknown,
    message: "Permintaan anda telah diterima",
    data: {},
  ),
  AppNotification(
    id: "3",
    createdAt: DateTime.now().subtract(Duration(days: 1)),
    action: NotificationAction.join,
    message: "Sebuah perjalanan baru tersedia untuk Anda ikuti.",
    data: {},
  ),
];

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<AppNotification> notifications = dummyNotifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconShadowButton(
                onPress: () => Navigator.pop(context),
                icon: Icons.arrow_back,
              ),
            ],
          ),
        ),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80.sp,
                    color: lightPrimary,
                  ),
                  addVerticalSpace(10),
                  Text(
                    "Anda tidak memiliki pemberitahuan terbaru",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  addVerticalSpace(10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Kembali"),
                  ),
                  addVerticalSpace(100),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addVerticalSpace(10),
                  Text(
                    "Notifikasi",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  addVerticalSpace(10),
                  // Tampilkan notifikasi menggunakan data dummy
                  for (int i = 0; i < notifications.length; i++)
                    NotificationTile(
                      notification: notifications[i],
                      onDeleted: () {
                        setState(() {
                          notifications.removeAt(i);
                        });
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
