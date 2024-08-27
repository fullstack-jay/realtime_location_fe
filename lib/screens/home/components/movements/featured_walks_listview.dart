import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'movement_story_card.dart';

class FeaturedMovements extends StatefulWidget {
  const FeaturedMovements({Key? key}) : super(key: key);

  @override
  State<FeaturedMovements> createState() => _FeaturedMovementsState();
}

class _FeaturedMovementsState extends State<FeaturedMovements> {
  @override
  Widget build(BuildContext context) {
    // Mock data for frontend testing
    final List<Map<String, dynamic>> mockMovements = [
      {'title': 'Perjalanan 1', 'createdAt': DateTime.now()},
      {
        'title': 'Perjalanan 2',
        'createdAt': DateTime.now().subtract(Duration(days: 1)),
      },
      // Add more mock movements as needed
    ];

    mockMovements.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

    return SizedBox(
      height: 150.h,
      child: mockMovements.isEmpty
          ? const Center(child: Text("Tidak ada perjalanan yang tersedia"))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockMovements.length,
              itemBuilder: (context, index) {
                return MovementStoryCard(
                  mounted: mounted,
                  movementTitle: mockMovements[index]
                      ['title'], // Pass the title here
                );
              },
            ),
    );
  }
}
