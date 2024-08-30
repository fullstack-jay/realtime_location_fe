import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/screens/components/warn_method.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_application_1/controllers/movements_controller.dart';
import 'package:get/get.dart';

import '../../widgets/app_bar_2.dart';
import 'widgets/setting_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final move = Get.find<MovementController>();
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
                  title: "Pengaturan",
                ),
              ),
            ),
            toolbarHeight: 100.h,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Umum".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.5.sp,
                    color: primary.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                addVerticalSpace(15),
                Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: lightPrimary.withOpacity(0.8),
                        blurRadius: 12.r,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingTile(
                        icon: Icons.group_off_outlined,
                        onSwitchChanged: (value) {},
                        text: "Batasi anggota baru",
                        active: true,
                        subText:
                            "Izinkan hanya teman Anda yang menemukan profil saat menggunakan didekat saya di lokasi Anda. ",
                      ),
                      SettingTile(
                        icon: Icons.directions_outlined,
                        onSwitchChanged: (value) {},
                        text: "Rute & Arah",
                        active: true,
                        subText:
                            "Menampilkan jalan yang sedang dilalui anggota jika dihidupkan",
                      ),
                      SettingTile(
                        icon: Icons.location_on_outlined,
                        onSwitchChanged: (value) {},
                        text: "Penanda khusus",
                        active: true,
                        subText:
                            "Tetapkan penanda khusus untuk aktor yang sedang bergerak",
                      ),
                      SettingTile(
                        icon: Icons.calendar_month,
                        onSwitchChanged: (value) {},
                        text: "Waktu akhir",
                        active: true,
                        subText:
                            "Tetapkan penanda khusus untuk aktor yang sedang bergerak",
                      ),
                      SettingTile(
                        icon: Icons.location_off_outlined,
                        onSwitchChanged: (value) {},
                        text: "Aktif",
                        active: true,
                        subText:
                            "Nonaktifkan pengguna lain untuk melihat lokasi Anda saat ini",
                      ),
                      SettingTile(
                        icon: Icons.logout_outlined,
                        onTap: () async {
                          final res = await warnMethod(
                            context,
                            title: "Meninggalkan perjalanan selamanya?",
                            subtitle:
                                "Apakah kamu yakin ingin meninggalkan perjalanan selamanya?",
                            okButtonText: "Tinggalkan",
                          );
                          if (res == true && mounted) {
                            // Handle leaving movement logic here
                          }
                        },
                        text: "Meninggalkan perjalanan",
                        subText: "Meninggalkan perjalanan ini selamanya",
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(15),
                Text(
                  "pesan".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.5.sp,
                    color: primary.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                addVerticalSpace(15),
                Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: lightPrimary.withOpacity(0.8),
                        blurRadius: 12.r,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingTile(
                        icon: Icons.tv_off_rounded,
                        onSwitchChanged: (value) {},
                        text: "Matikan pesan",
                        active: true,
                        subText:
                            "Izinkan hanya teman Anda yang menemukan profil saat menggunakan didekat saya di lokasi Anda.",
                      ),
                      SettingTile(
                        icon: Icons.group,
                        onSwitchChanged: (value) {},
                        text: "Siapa yang bisa mengirim pesan",
                        active: true,
                        subText:
                            "Tetapkan penanda khusus untuk aktor yang sedang bergerak",
                      ),
                    ],
                  ),
                ),
                addVerticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
