import 'package:flutter/material.dart';
//import 'package:flutter_application_1/screens/authentication/signin/signin_form.dart';
import './screens/authentication/welcome.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './utils/theme.dart';

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Infra Location Application',
          color: primary,
          theme: MyThemes.theme,
          home: const Scaffold(
            body: WelcomeScreen(),
          ),
        );
      },
    );
  }
}
