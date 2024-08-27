import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/screens/components/warn_method.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import '../../utils/colors.dart';
import '../movements/widgets/app_bar_2.dart';

class ClearCaches extends StatefulWidget {
  const ClearCaches({super.key});

  @override
  State<ClearCaches> createState() => _ClearCachesState();
}

class _ClearCachesState extends State<ClearCaches> {
  // Data Dummy
  late List<Activity> activities = [
    Activity(id: 1, name: "Inspeksi"),
    Activity(id: 2, name: "Pemenuhan SPM"),
  ];

  late List<SelfMadeWalk> selfMadeWalk = [
    SelfMadeWalk(id: 1, name: "Lokasi Kebaran"),
    SelfMadeWalk(id: 2, name: "Lokasi Kecelakaan"),
  ];

  late List<CacheItem> lens;

  _init() {
    lens = [
      CacheItem(
        count: activities.length,
        icon: Icons.local_activity_outlined,
        text: "Aktivitas",
      ),
      CacheItem(
        count: selfMadeWalk.length,
        icon: Icons.explore_outlined,
        text: "Perjalanan Mandiri",
      ),
    ];
    setState(() {});
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
                  title: "Bersihkan Cache",
                ),
              ),
            ),
            toolbarHeight: 100.h,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.amberAccent.shade700,
                      ),
                      color: Colors.amberAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.amberAccent.shade700,
                          size: 30.sp,
                        ),
                        addHorizontalSpace(10),
                        Expanded(
                          child: Text(
                            "Menghapus cache akan menghapus semua aktivitas dan perjalanan yang dilakukan sendiri yang tidak terkait dengan akun yang diautentikasi saat ini",
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  addVerticalSpace(40),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 650 ? 4 : 3,
                      mainAxisSpacing: 18.h,
                      crossAxisSpacing: 17.w,
                    ),
                    shrinkWrap: true,
                    itemCount: lens.length,
                    itemBuilder: (context, index) {
                      return CacheCategory(item: lens[index]);
                    },
                  ),
                  if (activities.isNotEmpty && selfMadeWalk.isNotEmpty)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final clear = await warnMethod(
                            context,
                            title: "Bersihkan semua cache",
                            subtitle:
                                "Kami mendeteksi beberapa pengguna yang masuk ke perangkat ini dan membuat beberapa aktivitas dan perjalanan yang dilakukan sendiri, setelah Anda menghapus cache, mereka tidak akan melihatnya lagi saat mereka kembali. Klik Hapus Semua untuk mengonfirmasi",
                            okButtonText: "Bersihkan Semua",
                          );
                          if (clear == true) {
                            setState(() {
                              activities.clear();
                              selfMadeWalk.clear();
                              _init();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade700,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 5.h,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        icon: Icon(
                          Icons.delete_outline,
                          size: 22.sp,
                        ),
                        label: Text(
                          "Bersihkan cache",
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                    ),
                  if (activities.isEmpty && selfMadeWalk.isEmpty)
                    Center(
                      child: Text(
                        "Tidak ada cache yang terdeteksi!",
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Activity {
  int id;
  String name;
  Activity({required this.id, required this.name});
}

class SelfMadeWalk {
  int id;
  String name;
  SelfMadeWalk({required this.id, required this.name});
}

class CacheItem {
  int count;
  IconData icon;
  String text;
  CacheItem({
    required this.count,
    required this.icon,
    required this.text,
  });
}

class CacheCategory extends StatelessWidget {
  const CacheCategory({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CacheItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.r),
      decoration: BoxDecoration(
        color: lightPrimary.withOpacity(0.1),
        border: Border.all(
          width: 1,
          color: lightPrimary,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 22.sp,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Text(
              item.count.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            item.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}
