import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../widgets/app_bar_2.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/movements_controller.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/models/movement.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final moveController = Get.find<MovementController>();
  final auth = AuthService().getAuth();

  Movement? movement;

  // Dummy data untuk menggantikan data dari backend
  final List<Member> currentMoveMembers = [
    Member(
        id: "1",
        username: "John",
        imgUrl: "https://via.placeholder.com/150",
        joinedAt: DateTime.now().subtract(Duration(days: 3))),
    Member(
        id: "2",
        username: "Jane",
        imgUrl: "https://via.placeholder.com/150",
        joinedAt: DateTime.now().subtract(Duration(days: 2))),
  ];

  final String creator = "Alice";
  final DateTime createdAt = DateTime.now().subtract(Duration(days: 5));

  @override
  Widget build(BuildContext context) {
    return Container(
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
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const AnotherCustomAppBar(
                  title: "Anggota",
                ),
              ),
            ),
            toolbarHeight: 100.h,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "anggota".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        //color: primary.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      currentMoveMembers.length.toString(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    addHorizontalSpace(10),
                    const Icon(Icons.group)
                  ],
                ),
                addVerticalSpace(10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 20.sp,
                              color: Colors.amberAccent,
                            ),
                            Text(
                              " Pembuat",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.amberAccent.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        addVerticalSpace(5),
                        ListTile(
                          leading: CircleAvatar(
                            radius: 24.r,
                            backgroundColor: lightPrimary,
                            foregroundColor: white,
                            child: Text(
                              creator[0].toUpperCase(),
                            ),
                          ),
                          title: Text(
                            creator,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            "Pembuat gerakan ini ${timeago.format(createdAt)}",
                            maxLines: 2,
                          ),
                        ),
                        addVerticalSpace(20),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 20.sp,
                              color: Colors.green.shade400,
                            ),
                            Text(
                              " Aktif",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.green.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        addVerticalSpace(20),
                        for (int i = 0; i < currentMoveMembers.length; i++)
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 27.r,
                                backgroundColor: lightPrimary,
                                child: CircleAvatar(
                                  radius: 22.r,
                                  backgroundColor: primary,
                                  foregroundColor: white,
                                  foregroundImage: NetworkImage(
                                    currentMoveMembers[i].imgUrl,
                                  ),
                                  child: Text(
                                    currentMoveMembers[i]
                                        .username[0]
                                        .toUpperCase(),
                                  ),
                                ),
                              ),
                              title: Text(
                                currentMoveMembers[i].username,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Bergabung ${timeago.format(currentMoveMembers[i].joinedAt)}",
                                maxLines: 2,
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 20.sp,
                              color: Colors.redAccent.shade700,
                            ),
                            Text(
                              " Tidak Aktif",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.redAccent.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        addVerticalSpace(20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Member {
  final String id;
  final String username;
  final String imgUrl;
  final DateTime joinedAt;

  Member({
    required this.id,
    required this.username,
    required this.imgUrl,
    required this.joinedAt,
  });
}
