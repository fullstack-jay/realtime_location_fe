import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:get/get.dart';

import 'controllers/auth.dart';
import 'screens/authentication/welcome.dart';
import 'screens/layout.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthState auth = Get.put(AuthState());

  final AuthService _hiveDb = AuthService();

  Future<void> _init() async {
    final account = _hiveDb.getAuth();
    if (account != null) {
      auth.isSignedIn.value = true;
    } else {
      auth.isSignedIn.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => auth.isSignedIn.value ? const LayoutPage() : const WelcomeScreen(),
    );
  }
}
