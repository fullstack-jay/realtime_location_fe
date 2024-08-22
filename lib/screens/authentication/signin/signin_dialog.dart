import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import '../signup/signup_page.dart';

import 'signin_form.dart';

Future<Object?> customSignInDialog(BuildContext context,
    {required ValueChanged isClosed}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Masuk",
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: ((context, animation, secondaryAnimation, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    }),
    pageBuilder: ((context, _, __) {
      return Center(
        child: Container(
          height: 550.h,
          padding: EdgeInsets.symmetric(
            vertical: 32.h,
            horizontal: 30.w,
          ),
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Material(
            color: transparent,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Masuk",
                    style: TextStyle(fontSize: 34.sp),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Text(
                      "Dapatkan Akses Ke Akun Anda",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  const SignInForm(),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const Text(
                          "Atau",
                          style: TextStyle(
                            color: Colors.black26,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      "Login dengan Email",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          popPage(context);
                          pushPage(context, to: const SignUpPage());
                        },
                        icon: SvgPicture.asset(
                          "assets/icons/email_box.svg",
                          height: 64.r,
                          width: 64.r,
                        ),
                      ),
                      // IconButton(
                      //   padding: EdgeInsets.zero,
                      //   onPressed: () {},
                      //   icon: SvgPicture.asset(
                      //     "assets/icons/google_box.svg",
                      //     height: 64.r,
                      //     width: 64.r,
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }),
  ).then(isClosed);
}
