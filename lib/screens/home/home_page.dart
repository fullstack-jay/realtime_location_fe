import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/helpers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onExploreMore});
  final VoidCallback onExploreMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hey 👋,\nExplore what's new today?",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          // const FeaturedMovements(),
          SizedBox(height: 12.h),
          Center(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ElevatedButton.icon(
                onPressed: onExploreMore,
                icon: const Icon(Icons.arrow_back),
                label: const Text("Explore more"),
              ),
            ),
          ),
          addVerticalSpace(10),
          // const SelfMadeWalksWidget(),
          addVerticalSpace(10),
          // const StartWalkingButton(),
        ],
      ),
    );
  }
}
