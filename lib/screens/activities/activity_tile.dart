import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../components/warn_method.dart';

// Dummy model for Activity
class Activity {
  final int id;
  final String type;
  final DateTime createdAt;
  final String text;

  Activity({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.text,
  });
}

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    Key? key,
    required this.activity,
    required this.onDelete,
  }) : super(key: key);

  final Activity activity;
  final Future<bool> Function(int id) onDelete;

  // Dummy mapping for icon types
  static const Map<String, IconData> toIcon = {
    'exercise': Icons.fitness_center,
    'work': Icons.work,
    'study': Icons.book,
    // Add more types as necessary
  };

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(activity.id),
      background: Container(),
      secondaryBackground: Container(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final delete = await warnMethod(
          context,
          title: "Move Activity to Trash",
          subtitle: "Are you sure do you want to delete this activity?",
          okButtonText: "Delete",
        );
        if (delete == true) {
          return await onDelete(activity.id);
        }
        return false;
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 2.w,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 15.w,
        ),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: lightPrimary.withOpacity(0.4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              toIcon[activity.type] ?? Icons.help_outline, // Fallback icon if type not found
              size: 30.sp,
              color: lightPrimary.withOpacity(0.8),
            ),
            addHorizontalSpace(15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeago.format(activity.createdAt),
                    style: TextStyle(
                      color: lightPrimary,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 13.sp,
                    ),
                  ),
                  addVerticalSpace(4),
                  Text(
                    activity.text,
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
