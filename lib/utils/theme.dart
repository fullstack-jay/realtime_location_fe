import 'package:flutter/material.dart';
import './colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyThemes {
  static final theme = ThemeData(
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: lightPrimary.withOpacity(0.8),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2.r),
            topRight: Radius.circular(25.r),
            bottomRight: Radius.circular(25.r),
            bottomLeft: Radius.circular(25.r),
          ),
        ),
      ),
    ),
  );
}
