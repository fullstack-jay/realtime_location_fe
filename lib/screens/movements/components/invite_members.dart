import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:flutter_application_1/controllers/movements_controller.dart'; // Removed backend controller
// import 'package:flutter_application_1/models/user.dart'; // Removed backend user model
import 'package:flutter_application_1/screens/components/top_snackbar.dart';
import 'package:flutter_application_1/utils/colors.dart';
import '../../../../utils/helpers.dart';

class InviteMembers extends StatefulWidget {
  const InviteMembers({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title, description;

  @override
  State<InviteMembers> createState() => _InviteMembersState();
}

class _InviteMembersState extends State<InviteMembers> {
  List<User> selected = [];
  // final _moveCnt = Get.find<MovementController>(); // Removed backend controller
  late bool isLoading;
  List<User> users = [];
  bool isCreating = false;

  void _init() {
    isLoading = true;
    // Dummy users data
    users = [
      User(
          id: '1',
          imgUrl: 'https://example.com/image1.jpg',
          username: 'Alice',
          joinedAt: 'alice@example.com'),
      User(
          id: '2',
          imgUrl: 'https://example.com/image2.jpg',
          username: 'Bob',
          joinedAt: 'bob@example.com'),
      User(
          id: '3',
          imgUrl: 'https://example.com/image3.jpg',
          username: 'Charlie',
          joinedAt: 'charlie@example.com'),
    ];
    isLoading = false;
    setState(() {});
  }

  void _createMovement() {
    setState(() {
      isCreating = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isCreating = false;
      });
      showMessage(
        message: "You created movement ${widget.title}",
        title: "Movement created successfully",
        type: MessageType.success,
      );

      // Here we would normally add the movement to some controller
      // _moveCnt.addMovement(movement);

      popPage(context);
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Invite",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade900,
              ),
            ),
            addHorizontalSpace(5),
            Icon(
              Icons.share,
              color: Colors.grey.shade600,
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addVerticalSpace(20),
                Row(
                  children: [
                    Text(
                      "select members".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: primary.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      selected.length.toString(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    addHorizontalSpace(10),
                    const Icon(Icons.group)
                  ],
                ),
                addVerticalSpace(18),
                if (users.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      children: [
                        Icon(
                          Icons.hide_source,
                          size: 40.sp,
                          color: Colors.red.shade300,
                        ),
                        addVerticalSpace(20),
                        Text(
                          "We're sorry, there is no any member in our system you can invite to your movement",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                Column(
                  children: [
                    for (int i = 0; i < users.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: ListTile(
                          onTap: () {
                            if (selected.contains(users[i])) {
                              selected.remove(users[i]);
                            } else {
                              selected.add(users[i]);
                            }

                            setState(() {});
                          },
                          selected: selected.contains(users[i]),
                          selectedTileColor: Colors.grey.shade200,
                          selectedColor: primary,
                          leading: CircleAvatar(
                            radius: 27.r,
                            backgroundColor: primary,
                            child: CircleAvatar(
                              radius: 24.r,
                              backgroundColor: primary,
                              foregroundColor: white,
                              foregroundImage: NetworkImage(users[i].imgUrl),
                              child: Text(
                                users[i].username[0].toUpperCase(),
                              ),
                            ),
                          ),
                          title: Text(
                            users[i].username,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            users[i].joinedAt,
                            maxLines: 2,
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: lightPrimary,
                            foregroundColor: white,
                            radius: 12.r,
                            child: selected.contains(users[i])
                                ? Icon(
                                    Icons.check,
                                    size: 16.sp,
                                  )
                                : null,
                          ),
                        ),
                      ),
                  ],
                ),
                addVerticalSpace(20),
                Center(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      onPressed: isCreating
                          ? null
                          : () {
                              if (selected.isEmpty) {
                                showMessage(
                                  message:
                                      "Please select a member to start a movement",
                                  title: "No member selected",
                                  type: MessageType.error,
                                );
                                return;
                              }
                              _createMovement();
                            },
                      icon: isCreating
                          ? LoadingAnimationWidget.inkDrop(
                              color: white, size: 18.sp)
                          : Icon(
                              Icons.share,
                              size: 24.sp,
                            ),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: lightPrimary,
                        disabledForegroundColor: white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 7.h,
                        ),
                      ),
                      label: Text(
                        isCreating ? "  LOADING  " : "  INVITE  ",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Frontend-only User class
class User {
  final String id;
  final String imgUrl;
  final String username;
  final String joinedAt;

  User({
    required this.id,
    required this.imgUrl,
    required this.username,
    required this.joinedAt,
  });
}
