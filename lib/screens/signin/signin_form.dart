import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authentication/signin/signin_input_field.dart';
import 'package:flutter_application_1/screens/authentication/signup/components/create_account.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../utils/colors.dart';

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
    if (email == null ||
        password == null ||
        email!.isEmpty ||
        password!.isEmpty) {
      return;
    }
    // setState(() {
    //   _isLoading = IsLoading.loading;
    // });
    // final response = await _hiveDb.login(email!, password!);
    // setState(() {
    //   _isLoading = IsLoading.idle;
    // });
    // if (response == null) return;
    // try {
    //   if (response["data"]["user"]["verified"]) {
    //     String token = response["data"]["token"];

    //     if (!mounted) return;
    //     setState(() {
    //       _isLoading = IsLoading.loading;
    //     });
    //     //Get profile
    //     final profile = await _hiveDb.getProfile(token);
    //     if (profile["data"] != null) {
    //       showMessage(
    //         message: "Authenticated as ${profile["data"]["email"]}",
    //         title: "Logged in successfully",
    //         type: MessageType.success,
    //       );
    //       if (!mounted) return;
    //       setState(() {
    //         _isLoading = IsLoading.success;
    //       });
    //       //Adding auth to local database
    //       final res = await _hiveDb.addAuth(
    //         token,
    //         Account(
    //           userId: profile["data"]["_id"],
    //           fullName: response["data"]["user"]["fullName"],
    //           email: profile["data"]["email"],
    //           username: profile["data"]["username"],
    //           profilePic: profile["data"]["imgUrl"],
    //           createdAt: DateTime.parse(
    //             profile["data"]["createdAt"],
    //           ),
    //         ),
    //       );
    //       if (!mounted) return;
    //       popPage(context);
    //       Future.delayed(
    //         const Duration(milliseconds: 400),
    //         () => auth.isSignedIn.value = res,
    //       );
    //     } else {
    //       showMessage(
    //         message:
    //             "No profile associated with this account, create your profile here",
    //         title: "Create Profile",
    //       );
    //       auth.email.value = response["data"]["user"]["email"];
    //       auth.token.value = token;

    //       //Go to profile page
    //       if (!mounted) return;
    //       popPage(context);
    //       pushPage(
    //         context,
    //         to: const SignUpPage(
    //           index: 2,
    //         ),
    //       );
    //       // Future.delayed(
    //       //   const Duration(milliseconds: 350),
    //       //   () {
    //       //     if (!mounted) return;

    //       //   },
    //       // );
    //     }
    //   } else {
    //     //Go to verification page
    //     showMessage(
    //       message:
    //           "Use OTP sent to your email recently and verify your account by entering in below fields",
    //       title: "Verify Account",
    //     );
    //     auth.email.value = response["data"]["user"]["email"];

    //     //Go to verification page
    //     if (!mounted) return;
    //     popPage(context);
    //     pushPage(
    //       context,
    //       to: const SignUpPage(
    //         index: 1,
    //       ),
    //     );
    // Future.delayed(
    //   const Duration(milliseconds: 400),
    //   () => pushPage(
    //     context,
    //     to: const SignUpPage(
    //       index: 1,
    //     ),
    //   ),
    // );
    //   }
    // } catch (e) {
    //   onUnkownError(e);
    // }
    // setState(() {
    //   _isLoading = IsLoading.success;
    // });
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
          const Spacer(),
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
                "Sign In",
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
