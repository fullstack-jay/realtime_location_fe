import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/activities/activities_page.dart';
import 'package:flutter_application_1/screens/home/home_page.dart';
import 'package:flutter_application_1/screens/profile/profile_page.dart';
import 'package:flutter_application_1/screens/movements/movements_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/screens/components/app_bar.dart';
import 'package:flutter_application_1/screens/widgets/slide_fade_switcher.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  late List<Widget> pages = [
    HomePage(
      onExploreMore: _onExplore,
    ),
    const MovementsPage(),
    const ActivitiesPage(),
    ProfilePage(),
  ];

  int currentPage = 0;

  void _onExplore() {
    if (currentPage == 2) return;
    setState(() {
      currentPage = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      child: SafeArea(
        top: true,
        bottom: false,
        right: false,
        left: false,
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
                child: MyAppBar(gotoExplore: _onExplore),
              ),
            ),
            toolbarHeight: 100.h,
          ),
          body: SlideFadeSwitcher(
            child: pages[currentPage],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: Platform.isAndroid ? 5 : 0,
              ),
              child: SalomonBottomBar(
                currentIndex: currentPage,
                onTap: ((p0) {
                  setState(() {
                    currentPage = p0;
                  });
                  return p0;
                }),
                items: [
                  // Menu item 1
                  SalomonBottomBarItem(
                    selectedColor: Colors.blue.shade200,
                    unselectedColor: veryLightGrey,
                    icon: Icon(Icons.home, size: 25.sp),
                    title: const Text("Beranda"),
                  ),
                  // Menu item 2
                  SalomonBottomBarItem(
                    selectedColor: Colors.blue.shade200,
                    unselectedColor: veryLightGrey,
                    icon: Icon(Icons.explore, size: 25.sp),
                    title: const Text("Jelajah"),
                  ),
                  // Menu item 3
                  SalomonBottomBarItem(
                    selectedColor: Colors.blue.shade200,
                    unselectedColor: veryLightGrey,
                    icon: Icon(Icons.history, size: 25.sp),
                    title: const Text("Riwayat"),
                  ),
                  // Menu item 4
                  SalomonBottomBarItem(
                    selectedColor: Colors.blue.shade200,
                    unselectedColor: veryLightGrey,
                    icon: Transform.scale(
                      scale: 1.3,
                      child: CircleAvatar(
                        backgroundColor: lightPrimary,
                        radius: 14.r,
                        foregroundImage: const NetworkImage(
                          // Gambar profil statis
                          "https://cdn.pixabay.com/photo/2023/02/18/16/02/bicycle-7798227_1280.jpg",
                        ),
                      ),
                    ),
                    title: const Text("Profil"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
