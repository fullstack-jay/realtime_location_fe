import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/screens/movements/widgets/app_bar_2.dart';
import 'package:flutter_application_1/screens/widgets/slide_fade_switcher.dart';

import '../../../../utils/colors.dart';
import 'components/create_account.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    this.index = 0,
  });

  final int index;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late List<Widget> steps;
  late int selectedIndex;

  _init() {
    selectedIndex = widget.index;
    steps = [
      CreateAccount(
        onContinue: () {
          setState(() {
            selectedIndex = 1;
          });
        },
      ),
    ];
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

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
                  title: "Buat Akun",
                ),
              ),
            ),
            toolbarHeight: 100.h,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: SlideFadeSwitcher(child: steps[selectedIndex]),
          ),
        ),
      ),
    );
  }
}
