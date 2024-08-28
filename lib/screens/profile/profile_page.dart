import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/screens/profile/caches.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_application_1/auth_wrapper.dart';

import '../movements/map/widgets/warn_dialog.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // Data Dummy
  final profile = {
    'fullName': 'Rizqi Reza Ardiansyah',
    'createdAt': DateTime(2024, 8, 26),
    'profilePic':
        'https://cdn.pixabay.com/photo/2023/02/18/16/02/bicycle-7798227_1280.jpg',
    'email': 'rizqirezaardiansyah@gmail.com',
    'username': 'fullstack_jay',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          ListTile(
            title: Text(
              profile['fullName'] as String,
              style: TextStyle(fontSize: 14.sp),
            ),
            subtitle: Text(
              "Bergabung sejak ${months[(profile['createdAt'] as DateTime).month - 1]} ${(profile['createdAt'] as DateTime).day}, ${(profile['createdAt'] as DateTime).year}",
              style: TextStyle(fontSize: 12.sp),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  width: 3.r,
                  color: lightPrimary,
                ),
              ),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 24.r,
                  foregroundImage: NetworkImage(
                    profile['profilePic'] as String,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Informasi Pribadi".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: primary.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.mail_outline_outlined,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Email",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    profile['email'] as String,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                Text(
                  "umum".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: primary.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.cached,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Hapus cache",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    "Membersihkan cache dari perangkat anda",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  onTap: () => pushPage(
                    context,
                    to: const ClearCaches(),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 24.sp,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.logout, size: 25.sp),
                  title: Text(
                    "Keluar",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    "Masuk sebagai ${profile['username'] as String}",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  onTap: () async {
                    final logout = await showDialog<bool>(
                      context: context,
                      barrierColor: Colors.black26,
                      builder: ((context) {
                        return const WarnDialogWidget(
                          title: "Keluar?",
                          subtitle:
                              "Apakah anda yakin ingin keluar dari aplikasi ini?",
                          okButtonText: "Keluar",
                        );
                      }),
                    );
                    if (logout != true) return;

                    // Clear any authentication data if necessary
                    // For example:
                    // await authService.removeAuth();

                    // Navigate to AuthWrapper
                    Get.offAll(() => const AuthWrapper());
                  },
                )
              ],
            ),
          ),
          const Spacer(),
          Transform.scale(
            scale: .7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/images/astra.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Infra Location",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    addVerticalSpace(5),
                    Text(
                      "Pelacakan lokasi langsung menjadi lebih mudah",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 12.sp,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          addVerticalSpace(25)
        ],
      ),
    );
  }
}
