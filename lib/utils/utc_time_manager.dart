import 'dart:async';

/// A utility class for handling all UTC calculations for the Amomimus 3-day reset system.
class UTCTimeManager {
  static const int resetDays = 3;

  /// Returns the current UTC time.
  static DateTime nowUTC() {
    return DateTime.now().toUtc();
  }

  /// Calculates the exact expiration date (3 days later) based on a given start time.
  static DateTime calculateExpirationDate(DateTime startUtc) {
    // We add exactly 3 days (72 hours) to the start time.
    return startUtc.add(const Duration(days: resetDays));
  }

  /// Calculates the remaining time duration until expiration.
  static Duration getRemainingTime(DateTime expirationDate) {
    final now = nowUTC();
    if (now.isAfter(expirationDate)) {
      return Duration.zero;
    }
    return expirationDate.difference(now);
  }

  /// Formats a Duration into HH:MM:SS format (e.g. 71:59:59).
  static String formatDurationHHMMSS(Duration duration) {
    if (duration.isNegative || duration == Duration.zero) return "00:00:00";

    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return "${hours.toString().padLeft(2, '0')}:$minutes:$seconds";
  }

  /// Converts a UTC DateTime to a readable string (e.g., "12 Oct 2026 18:00 WIB")
  static String formatToLocalReadable(DateTime utcTime) {
    final localTime = utcTime.toLocal();
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final day = localTime.day.toString().padLeft(2, '0');
    final month = months[localTime.month - 1];
    final year = localTime.year;
    final hour = localTime.hour.toString().padLeft(2, '0');
    final minute = localTime.minute.toString().padLeft(2, '0');

    return "$day $month $year $hour:$minute";
  }

  /// Formats a timestamp dynamically for feed posts and comments relative to current time.
  static String formatTimeAgo(String timeStamp) {
    try {
      final dateTime = DateTime.tryParse(timeStamp);
      if (dateTime == null) return timeStamp; // Keep dummy static strings
      final now = dateTime.isUtc ? DateTime.now().toUtc() : DateTime.now();
      final diff = now.difference(dateTime);
      if (diff.isNegative) {
        return "Just now";
      }
      if (diff.inSeconds < 60) {
        return "Just now";
      } else if (diff.inMinutes < 60) {
        return "${diff.inMinutes}m ago";
      } else if (diff.inHours < 24) {
        return "${diff.inHours}h ago";
      } else {
        return "${diff.inDays}d ago";
      }
    } catch (_) {
      return timeStamp;
    }
  }
}

