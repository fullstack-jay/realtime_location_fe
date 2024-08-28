import 'package:flutter_application_1/models/activity.dart';
import 'package:flutter_application_1/models/movement.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_1/models/notification.dart';
import 'package:flutter_application_1/models/profile.dart';
import 'package:flutter_application_1/screens/components/top_snackbar.dart';
import 'package:flutter_application_1/services/hive_service.dart';
import 'package:flutter_application_1/utils/keys.dart';
import 'package:logger/logger.dart';

import 'auth_service.dart';

class DBService {
  final dio = Dio();
  final authService = AuthService();
  final hiveService = HiveService();
  final logger = Logger(); // Inisialisasi logger

  Future<String?> _getAuthToken() async {
    final account = authService.getAuth();
    if (account != null) {
      return "dummyToken"; // Simulasi token
    }
    return null;
  }

  Future<List<Movement>?> getMovements() async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception("No auth token available");
      }
      dio.options.headers["Authorization"] = "Bearer $authToken";
      final res = await dio.get("$backendApiUrl/movements");
      List<Movement> movements = [];

      for (var movement in res.data["data"]) {
        movements.add(Movement.fromJSON(movement));
      }
      return movements;
    } on DioException catch (e) {
      onDioError(e);
      return null;
    } catch (e) {
      if (e is Exception) {
        onUnkownError(e);
      } else {
        logger.e("Non-exception error"); // Menggunakan logger
      }
      return null;
    }
  }

  Future<Movement?> getOneMovement(String id) async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception("No auth token available");
      }
      dio.options.headers["Authorization"] = "Bearer $authToken";
      final res = await dio.get("$backendApiUrl/movements/$id");
      return Movement.fromJSON(res.data["data"]);
    } on DioException catch (e) {
      onDioError(e);
      return null;
    } catch (e) {
      if (e is Exception) {
        onUnkownError(e);
      } else {
        logger.e("Non-exception error"); // Menggunakan logger
      }
      return null;
    }
  }

  Future<bool> leaveMovement(String id) async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception("No auth token available");
      }
      dio.options.headers["Authorization"] = "Bearer $authToken";
      final res = await dio.patch("$backendApiUrl/movements/$id");
      showMessage(message: res.data["message"], title: res.data["data"]);
      //----------------------------------------------------------------
      await hiveService.addActivity(
        Activity(
          id: 0,
          text: "You've left the movement with ID:$id. ",
          createdAt: DateTime.now(),
          type: ActivityType.delete,
          creatorId: hiveService.profile!.userId,
        ),
      );
      //----------------------------------------------------------------
      return true;
    } on DioException catch (e) {
      onDioError(e);
      return false;
    } catch (e) {
      if (e is Exception) {
        onUnkownError(e);
      } else {
        logger.e("Non-exception error"); // Menggunakan logger
      }
      return false;
    }
  }

  Future<List<Profile>?> getUsers() async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception("No auth token available");
      }
      dio.options.headers["Authorization"] = "Bearer $authToken";
      final res = await dio.get("$backendApiUrl/accounts");
      List<Profile> users = [];

      for (var profile in res.data["data"]) {
        users.add(Profile.fromJson(profile));
      }
      return users;
    } on DioException catch (e) {
      onDioError(e);
      return null;
    } catch (e) {
      if (e is Exception) {
        onUnkownError(e);
      } else {
        logger.e("Non-exception error"); // Menggunakan logger
      }
      return null;
    }
  }

  Future<Movement?> createMovement({
    required String title,
    required String description,
    required String creatorName,
    required List<String> actors,
  }) async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception("No auth token available");
      }
      dio.options.headers["Authorization"] = "Bearer $authToken";
      final res = await dio.post("$backendApiUrl/movements/create", data: {
        "title": title,
        "description": description,
        "creator": creatorName,
        "actors": actors,
      });
      final movement = Movement.fromJSON(res.data["movement"]);
      //----------------------------------------------------------------
      await hiveService.addActivity(
        Activity(
          id: 0,
          text:
              "You've successfully created the movement titled ${movement.title} with ${movement.members} member(s) together. ",
          createdAt: DateTime.now(),
          type: ActivityType.add,
          creatorId: hiveService.profile!.userId,
        ),
      );
      //----------------------------------------------------------------
      return movement;
    } on DioException catch (e) {
      onDioError(e);
      return null;
    } catch (e) {
      if (e is Exception) {
        onUnkownError(e);
      } else {
        logger.e("Non-exception error"); // Menggunakan logger
      }
      return null;
    }
  }

  Future<bool?> deleteMovement(String id) async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception("No auth token available");
      }
      dio.options.headers["Authorization"] = "Bearer $authToken";
      final res = await dio.delete("$backendApiUrl/movements/$id");
      onSuccess(
        title: "Movement deleted",
        message: res.data["message"],
      );
      //----------------------------------------------------------------
      await hiveService.addActivity(
        Activity(
          id: 0,
          text: "You've deleted movement with ID:$id. ",
          createdAt: DateTime.now(),
          type: ActivityType.delete,
          creatorId: hiveService.profile!.userId,
        ),
      );
      //----------------------------------------------------------------
      return true;
    } on DioException catch (e) {
      onDioError(e);
      return null;
    } catch (e) {
      if (e is Exception) {
        onUnkownError(e);
      } else {
        logger.e("Non-exception error"); // Menggunakan logger
      }
      return null;
    }
  }

  Future<List<AppNotification>?> getNotifications() async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception("No auth token available");
      }
      dio.options.headers["Authorization"] = "Bearer $authToken";
      final res = await dio.get("$backendApiUrl/notifications");

      List<AppNotification> notis = [];

      for (var notification in res.data["notifications"]) {
        notis.add(AppNotification.fromJSON(notification));
      }

      return notis;
    } on DioException catch (e) {
      onDioError(e);
      return null;
    } catch (e) {
      if (e is Exception) {
        onUnkownError(e);
      } else {
        logger.e("Non-exception error"); // Menggunakan logger
      }
      return null;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      final authToken = await _getAuthToken();
      if (authToken == null) {
        throw Exception("No auth token available");
      }
      dio.options.headers["Authorization"] = "Bearer $authToken";
      await dio.delete("$backendApiUrl/notifications/$id");
      return true;
    } on DioException catch (e) {
      onDioError(e);
      return false;
    } catch (e) {
      if (e is Exception) {
        onUnkownError(e);
      } else {
        logger.e("Non-exception error"); // Menggunakan logger
      }
      return false;
    }
  }

  void onDioError(DioException e) {
    logger.e("DioException: ${e.message}"); // Menggunakan logger
  }

  void onUnkownError(Exception e) {
    logger.e("Unknown error: ${e.toString()}"); // Menggunakan logger
  }
}
