import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth_wrapper.dart';
//import 'package:flutter_application_1/screens/layout.dart';
//import 'package:flutter_application_1/screens/authentication/signin/signin_form.dart';
//import './screens/authentication/welcome.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './utils/theme.dart';
import 'package:flutter_application_1/services/hive_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  await Hive.initFlutter();

  //Opening database of the saved walks
  await Future.wait([
    Hive.openBox(Boxes.selfMadeWalksBox),
    Hive.openBox(Boxes.activitiesBox),
    Hive.openBox(Boxes.authBox),
  ]);
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
        return GetMaterialApp(
          title: 'Infra Location Application',
          color: primary,
          theme: MyThemes.theme,
          home: child,
        );
      },
      child: const AuthWrapper(),
    );
  }
}
