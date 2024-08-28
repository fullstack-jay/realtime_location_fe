import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authentication/signin/signin_input_field.dart';
import 'package:flutter_application_1/screens/authentication/signup/components/create_account.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../utils/colors.dart';
import 'package:flutter_application_1/screens/layout.dart';
import 'package:get/get.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final IsLoading _isLoading = IsLoading.idle;

  String? email;
  String? password;

  void _sign() async {
    if (email != null &&
        password != null &&
        email!.isNotEmpty &&
        password!.isNotEmpty) {
      // Navigate to LayoutPage
      Get.offAll(() => const LayoutPage()); // Use your layout page widget
    } else {
      // Handle error case (e.g., show a message)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid email and password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = _isLoading == IsLoading.loading;
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SignInInputField(
            hintText: "Email",
            svg: "email.svg",
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          SignInInputField(
            hintText: "Password",
            svg: "pwd.svg",
            isPwd: true,
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10.h, bottom: 24.h),
            child: ElevatedButton.icon(
              onPressed: _sign,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: lightPrimary,
                disabledForegroundColor: white,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              ),
              icon: loading
                  ? LoadingAnimationWidget.inkDrop(color: white, size: 18.sp)
                  : Icon(
                      CupertinoIcons.arrow_right,
                      color: const Color(0xFF9fcdf5),
                      size: 24.sp,
                    ),
              label: Text(
                "Masuk",
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
