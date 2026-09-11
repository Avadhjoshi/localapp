import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceHelper {
  static const _key = "device_id";

  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    String? deviceId = prefs.getString(_key);

    if (deviceId != null) {
      return deviceId;
    }

    // Generate new ID
    deviceId = const Uuid().v4();

    await prefs.setString(_key, deviceId);

    return deviceId;
  }
}