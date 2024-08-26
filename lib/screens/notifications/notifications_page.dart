import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Remove imports related to backend and models
//import 'package:quickstep_app/models/notification.dart';
//import 'package:quickstep_app/services/db_service.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import '../widgets/icon_shadow_button.dart';
//import 'widgets/notification_tile.dart';

// Sample static data for notifications
List<AppNotification> sampleNotifications = [
  AppNotification(
    createdAt: DateTime.now().subtract(Duration(minutes: 10)),
    action: "Sample Action 1",
    message: "This is a sample notification message.",
    data: {},
    id: "1",
  ),
  AppNotification(
    createdAt: DateTime.now().subtract(Duration(hours: 1)),
    action: "Sample Action 2",
    message: "Another sample notification message.",
    data: {},
    id: "2",
  ),
];

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<AppNotification> notifications = sampleNotifications;

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
                onPress: () => popPage(context),
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
                    "You have no recent notifications",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  addVerticalSpace(10),
                  ElevatedButton(
                    onPressed: () => popPage(context),
                    child: const Text("Go Back"),
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
                    "Notifications",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  addVerticalSpace(10),
                  // Display notification tiles with static data

                  // for (int i = 0; i < notifications.length; i++)
                  //   NotificationTile(
                  //     notification: notifications[i],
                  //     onDeleted: () {
                  //       setState(() {
                  //         notifications.removeAt(i);
                  //       });
                  //     },
                  //   ),
                ],
              ),
            ),
    );
  }
}

// Define a simple AppNotification model for the frontend
class AppNotification {
  final DateTime createdAt;
  final String action;
  final String message;
  final Map<String, dynamic> data;
  final String id;

  AppNotification({
    required this.createdAt,
    required this.action,
    required this.message,
    required this.data,
    required this.id,
  });
}

class MenuItem {
  IconData icon;
  String title;
  VoidCallback onClick;

  MenuItem({
    required this.icon,
    required this.title,
    required this.onClick,
  });
  static List<MenuItem> items = [
    MenuItem(
      icon: Icons.visibility_outlined,
      title: "Mark all as read",
      onClick: () {},
    ),
    MenuItem(
      icon: Icons.visibility_off_outlined,
      title: "Mark all as unread",
      onClick: () {},
    ),
    MenuItem(
      icon: Icons.notifications_off,
      title: "Turn off",
      onClick: () {},
    ),
    MenuItem(
      icon: Icons.delete,
      title: "Clear All",
      onClick: () {},
    ),
  ];
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: primary.withOpacity(0.9),
        fontSize: 14.5.sp,
      ),
    );
  }
}
