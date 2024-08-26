import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart'; // Removed as we're no longer using GetX for backend operations
// import 'package:flutter_application_1/controllers/movements_controller.dart'; // Removed backend controller
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/helpers.dart';

class OnError extends StatefulWidget {
  const OnError({super.key});

  @override
  State<OnError> createState() => _OnErrorState();
}

class _OnErrorState extends State<OnError> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        children: [
          addVerticalSpace(50),
          Icon(
            Icons.running_with_errors_outlined,
            size: 40.sp,
            color: lightPrimary,
          ),
          addVerticalSpace(20),
          Text(
            "Sorry, we're currently facing issues, try again later.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.sp),
          ),
          addVerticalSpace(20),
          ElevatedButton(
            onPressed: () {
              // Dummy operation to simulate retry
              setState(() {
                // You could set a state to indicate a retry attempt, show a loading spinner, etc.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Retrying...')));
              });
            },
            child: const Text("Try again"),
          )
        ],
      ),
    );
  }
}
