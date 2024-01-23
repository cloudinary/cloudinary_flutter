import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class VideoAnalyticsHelper {
  static String generateUuid() {
    Random random = Random();

    String generateRandomHex(int length) {
      var result = StringBuffer();
      for (var i = 0; i < length; i++) {
        result.write(random.nextInt(16).toRadixString(16));
      }
      return result.toString();
    }

    String part1 = generateRandomHex(8);
    String part2 = generateRandomHex(4);
    String part3 = '4${generateRandomHex(3)}';
    String part4 =
        (8 + random.nextInt(3)).toRadixString(16) + generateRandomHex(3);
    String part5 = generateRandomHex(12);

    String uuid = '$part1$part2$part3$part4$part5';

    return uuid;
  }
}

class UserIdHelper {
  static const _userIdKey = 'user_id';

  static Future<String> getUserId() async {
    String? userId = await _readUserIdFromPrefs();

    if (userId == null) {
      userId = _generateUserId();
      await _writeUserIdToPrefs(userId);
    }

    return userId;
  }

  static String _generateUserId() {
    return VideoAnalyticsHelper.generateUuid();
  }

  static Future<void> _writeUserIdToPrefs(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> _readUserIdFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
    }
  }
}
