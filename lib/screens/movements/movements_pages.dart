import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:quickstep_app/controllers/movements_controller.dart';
import 'package:flutter_application_1/screens/movements/create_movement.dart';
import 'package:flutter_application_1/screens/movements/widgets/on_empty.dart';
// import 'package:flutter_application_1/screens/movements/widgets/on_error.dart';
import 'package:flutter_application_1/utils/helpers.dart';

import 'widgets/movement_tile.dart';

// Define or import the Movement class
class Movement {
  final int id;
  final String name;
  final DateTime createdAt;

  Movement({
    required this.id,
    required this.name,
    required this.createdAt,
  });
}

class MovementsPage extends StatefulWidget {
  const MovementsPage({super.key});

  @override
  State<MovementsPage> createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage> {
  List<Movement> movements = []; // Initialize an empty list

  @override
  void initState() {
    super.initState();
    loadMovements(); // Load movements when the widget is initialized
  }

  void loadMovements() {
    // Simulate loading data with dummy data
    setState(() {
      movements = [
        // Example mock data
        Movement(
          id: 1,
          name: "Perjalanan 1",
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
        Movement(
          id: 2,
          name: "Perjalanan 2",
          createdAt: DateTime.now().subtract(Duration(days: 2)),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Perjalanan",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  pushPage(context, to: const CreateMovementPage());
                },
                icon: const Icon(Icons.add),
                label: const Text("Buat Perjalanan"),
              ),
            ],
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // children: [
                //   movements.isNotEmpty
                //       ? Column(
                //           children: movements
                //               .map<Widget>(
                //                 (move) => MovementTile(movement: move),
                //               )
                //               .toList(),
                //         )
                //       : const OnEmpty(), // Display OnEmpty if the list is empty
                // ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
