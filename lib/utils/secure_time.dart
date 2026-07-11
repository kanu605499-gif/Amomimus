import 'package:ntp/ntp.dart';

class SecureTime {
  static Duration _offset = Duration.zero;
  static bool _initialized = false;

  /// Fetch true time from NTP server and calculate offset against local device time.
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      // time.google.com is highly available and reliable
      final ntpTime = await NTP.now(lookUpAddress: 'time.google.com', timeout: const Duration(seconds: 5));
      final localTime = DateTime.now();
      _offset = ntpTime.difference(localTime);
      _initialized = true;
      print('==== SecureTime initialized. Offset: ${_offset.inSeconds} seconds ====');
    } catch (e) {
      print('==== SecureTime failed to initialize, falling back to local time: $e ====');
      // If NTP fails (e.g. no internet), fallback to 0 offset
      _offset = Duration.zero;
    }
  }

  /// Returns the current true time, accounting for the calculated offset.
  /// This prevents users from bypassing cooldowns by changing their local device time,
  /// assuming they were connected to the internet during app launch.
  static DateTime now() {
    return DateTime.now().add(_offset);
  }
}
