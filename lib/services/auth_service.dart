import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/services/hive_service.dart';
import 'package:flutter_application_1/screens/components/top_snackbar.dart';

import 'package:flutter_application_1/models/account.dart';

class AuthService {
  Box authBox = Hive.box(Boxes.authBox);
  final dio = Dio();

  // Simulasi akun yang terdaftar
  final List<Map<String, String>> _dummyAccounts = [
    {
      "email": "johndoe@example.com",
      "password": "password123",
      "fullName": "John Doe",
      "username": "johndoe",
    },
    {
      "email": "janesmith@example.com",
      "password": "mypassword",
      "fullName": "Jane Smith",
      "username": "janesmith",
    },
  ];

  Account? getAuth() {
    try {
      final data = authBox.keys.map((key) {
        final value = authBox.get(key);
        DateTime expiredAt = value["expiredAt"];
        if (!expiredAt.isAfter(DateTime.now())) {
          removeAuth();
          throw Exception("Token expired");
        }
        return Account.fromMap(value["account"]);
      }).toList();
      return data.reversed.toList().single;
    } catch (e) {
      return null;
    }
  }

  Future<bool> addAuth(String token, Account account) async {
    try {
      await authBox.add(
        {
          "authToken": token,
          "expiredAt": DateTime.now().add(const Duration(days: 5)),
          "account": Account.toMap(account),
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeAuth() async {
    try {
      await authBox.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Simulasi proses login
  Future<Account?> login(String email, String password) async {
    try {
      // Cari akun yang cocok dengan email dan password
      final accountData = _dummyAccounts.firstWhere(
        (account) =>
            account["email"] == email && account["password"] == password,
        orElse: () => {},
      );

      if (accountData != {}) {
        final account = Account(
          userId: email, // Untuk simulasi, kita gunakan email sebagai userId
          fullName: accountData["fullName"]!,
          email: email,
          username: accountData["username"]!,
          profilePic: "https://example.com/profiles/default.png",
          createdAt: DateTime.now(),
        );
        await addAuth(
            "dummyToken", account); // Menambahkan token dummy untuk simulasi
        return account;
      } else {
        throw Exception("Invalid email or password");
      }
    } catch (e) {
      // Tangani kesalahan login
      return null;
    }
  }
}

void onSuccess({required String title, required String message}) {
  showMessage(
    message: message,
    title: title,
    type: MessageType.success,
  );
}
