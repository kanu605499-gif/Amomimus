import 'dart:math';
import '../models/report_model.dart';
import '../models/user_indicator_model.dart';

/// Benevolent Calculator v2 — Scalable for 100K+ users.
///
/// **Key changes from v1:**
/// - Logarithmic report impact (diminishing returns per additional report)
/// - Time decay (-3 points/month without new reports)
/// - Proportional resonate redemption (every 50 resonates = -1 point)
/// - Reporter credibility (GHOST/NOISE reporters have reduced weight)
/// - Token-based daily/weekly report limits per category
///
/// **Benevolent Points** (0–100 percentage scale):
/// - Points INCREASE when a user is reported (bad behavior).
/// - Points DECREASE via resonate redemption and time decay.
/// - 0–69  → CLOUDY (grey, neutral user)
/// - 70–89 → GHOST (yellow, amoral / nonchalant user)
/// - 90–100 → NOISE (purple, flagged / toxic user)
class BenevolentCalculator {
  BenevolentCalculator._(); // prevent instantiation

  // ── Report weights ──────────────────────────────────────

  /// Base weight for a general (user-level) report.
  static const int baseReportWeight = 2;

  /// Extra weight when the report is a per-chat-bubble report.
  static const int chatBubbleBonus = 1;

  /// Severity multipliers per report category.
  static const Map<ReportCategory, double> categoryMultipliers = {
    ReportCategory.spamHarassment: 1.0,
    ReportCategory.inappropriateContent: 1.25,
    ReportCategory.hateSpeech: 1.5,
  };

  // ── Resonate weights ────────────────────────────────────

  /// How many resonates needed to subtract 1 benevolent point.
  static const int resonatesPerPoint = 50;

  // ── Time Decay ──────────────────────────────────────────

  /// Points decayed per 30-day period without new reports.
  static const int decayPerMonth = 3;

  // ── Token System (Daily/Weekly Report Limits) ───────────

  /// Daily report token limits per category.
  /// These limit how many reports a single account can SUBMIT per day.
  static const Map<ReportCategory, int> dailyTokenLimits = {
    ReportCategory.spamHarassment: 5,
    ReportCategory.inappropriateContent: 4,
    ReportCategory.hateSpeech: 3,
  };

  /// Weekly report limit specifically for hate speech.
  static const int weeklyHateSpeechLimit = 55;

  /// Maximum total reports per day across all categories.
  static const int dailyTotalLimit = 10;

  // ── Core Calculation (v2 — Logarithmic) ─────────────────

  /// Calculates benevolent points using logarithmic scaling.
  ///
  /// Formula: score = Σ(log(1 + i) × severity) - resonateBonus - decay
  ///
  /// [reportsAgainstUser] — all reports filed against this user.
  /// [totalResonatesReceived] — total resonates the user has received.
  /// [lastReportDate] — date of the most recent report (for decay calculation).
  static int calculate({
    required List<ReportModel> reportsAgainstUser,
    required int totalResonatesReceived,
    DateTime? lastReportDate,
  }) {
    // 1. Logarithmic report accumulation
    double reportPoints = 0;

    // Group reports by category for logarithmic diminishing returns
    final Map<ReportCategory, List<ReportModel>> grouped = {};
    for (final report in reportsAgainstUser) {
      grouped.putIfAbsent(report.category, () => []).add(report);
    }

    for (final entry in grouped.entries) {
      final multiplier = categoryMultipliers[entry.key] ?? 1.0;
      final reports = entry.value;

      for (int i = 0; i < reports.length; i++) {
        // Each additional report has diminishing impact: log(1 + index)
        final diminishingFactor = log(1 + (i + 1)) / log(2); // log base 2
        final base = baseReportWeight * multiplier;
        final bonus = reports[i].isChatBubbleReport ? chatBubbleBonus : 0;
        reportPoints += (base + bonus) * diminishingFactor;
      }
    }

    // 2. Proportional resonate redemption
    final resonateRedemption = totalResonatesReceived ~/ resonatesPerPoint;

    // 3. Time decay
    int decay = 0;
    if (lastReportDate != null) {
      final daysSinceLastReport = DateTime.now().difference(lastReportDate).inDays;
      final monthsPassed = daysSinceLastReport ~/ 30;
      decay = monthsPassed * decayPerMonth;
    }

    final rawScore = reportPoints - resonateRedemption - decay;
    return rawScore.round().clamp(0, 100);
  }

  /// Calculates points and returns the corresponding [UserIndicator].
  static UserIndicator calculateIndicator({
    required List<ReportModel> reportsAgainstUser,
    required int totalResonatesReceived,
    required String currentIndicator,
    DateTime? lastReportDate,
  }) {
    final points = calculate(
      reportsAgainstUser: reportsAgainstUser,
      totalResonatesReceived: totalResonatesReceived,
      lastReportDate: lastReportDate,
    );

    return UserIndicatorHelper.fromBenevolentPoints(points);
  }

  /// Convenience: returns both the calculated points and the indicator.
  static ({int points, UserIndicator indicator}) evaluateUser({
    required List<ReportModel> reportsAgainstUser,
    required int totalResonatesReceived,
    required String currentIndicator,
    DateTime? lastReportDate,
  }) {
    final points = calculate(
      reportsAgainstUser: reportsAgainstUser,
      totalResonatesReceived: totalResonatesReceived,
      lastReportDate: lastReportDate,
    );

    return (
      points: points,
      indicator: UserIndicatorHelper.fromBenevolentPoints(points),
    );
  }

  // ── Single Report Addition (v2) ─────────────────────────

  /// Adds a single report's points with logarithmic scaling.
  ///
  /// [existingReportCount] — how many reports this user already has in
  /// the same category. Used for diminishing returns.
  /// [reporterBenevolentPoints] — the reporter's own benevolent points.
  /// Reporters with high points (GHOST/NOISE) have reduced credibility.
  static ({int points, UserIndicator indicator}) addReportToUser({
    required int currentPoints,
    required ReportCategory category,
    required bool isChatBubbleReport,
    required String currentIndicator,
    double pointMultiplier = 1.0,
    int existingReportCount = 0,
    int reporterBenevolentPoints = 0,
  }) {
    final multiplier = categoryMultipliers[category] ?? 1.0;
    final base = baseReportWeight * multiplier;
    final bonus = isChatBubbleReport ? chatBubbleBonus : 0;

    // Logarithmic diminishing returns based on existing reports in this category
    final diminishingFactor = log(1 + (existingReportCount + 1)) / log(2);

    // Reporter credibility: GHOST/NOISE reporters have reduced weight
    double credibilityFactor = 1.0;
    if (reporterBenevolentPoints >= 90) {
      credibilityFactor = 0.3; // NOISE reporter — heavily discounted
    } else if (reporterBenevolentPoints >= 70) {
      credibilityFactor = 0.5; // GHOST reporter — halved
    }

    final int pointsToAdd =
        ((base + bonus) * diminishingFactor * pointMultiplier * credibilityFactor)
            .round()
            .clamp(0, 15); // Cap single report impact at 15 points

    final int newPoints = (currentPoints + pointsToAdd).clamp(0, 100);
    return (
      points: newPoints,
      indicator: UserIndicatorHelper.fromBenevolentPoints(newPoints),
    );
  }

  // ── Token System Helpers ────────────────────────────────

  /// Checks if a user can submit a report based on daily/weekly token limits.
  ///
  /// [dailyReportsByCategory] — Map of {category: count} for today's reports.
  /// [weeklyHateSpeechCount] — total hate speech reports in the last 7 days.
  /// [totalDailyReports] — total reports across all categories today.
  ///
  /// Returns `null` if allowed, or a reason string if blocked.
  static String? checkReportTokens({
    required ReportCategory category,
    required Map<ReportCategory, int> dailyReportsByCategory,
    required int weeklyHateSpeechCount,
    required int totalDailyReports,
  }) {
    // Check total daily limit
    if (totalDailyReports >= dailyTotalLimit) {
      return 'daily_limit_reached'; // "You've reached your daily report limit."
    }

    // Check per-category daily limit
    final categoryCount = dailyReportsByCategory[category] ?? 0;
    final categoryLimit = dailyTokenLimits[category] ?? 5;
    if (categoryCount >= categoryLimit) {
      return 'category_limit_reached'; // "You've used all your {category} report tokens for today."
    }

    // Check weekly hate speech limit
    if (category == ReportCategory.hateSpeech &&
        weeklyHateSpeechCount >= weeklyHateSpeechLimit) {
      return 'weekly_hate_speech_limit'; // "Weekly hate speech report limit reached."
    }

    return null; // Allowed
  }

  /// Calculates remaining report tokens for display in UI.
  static Map<String, int> getRemainingTokens({
    required Map<ReportCategory, int> dailyReportsByCategory,
    required int weeklyHateSpeechCount,
    required int totalDailyReports,
  }) {
    return {
      'daily_total': (dailyTotalLimit - totalDailyReports).clamp(0, dailyTotalLimit),
      'spam_daily': ((dailyTokenLimits[ReportCategory.spamHarassment] ?? 5) -
              (dailyReportsByCategory[ReportCategory.spamHarassment] ?? 0))
          .clamp(0, 99),
      'inappropriate_daily':
          ((dailyTokenLimits[ReportCategory.inappropriateContent] ?? 4) -
                  (dailyReportsByCategory[ReportCategory.inappropriateContent] ?? 0))
              .clamp(0, 99),
      'hate_speech_daily': ((dailyTokenLimits[ReportCategory.hateSpeech] ?? 3) -
              (dailyReportsByCategory[ReportCategory.hateSpeech] ?? 0))
          .clamp(0, 99),
      'hate_speech_weekly':
          (weeklyHateSpeechLimit - weeklyHateSpeechCount).clamp(0, weeklyHateSpeechLimit),
    };
  }

  // ── Decay Helper ────────────────────────────────────────

  /// Applies time decay to existing points.
  /// Call this periodically (e.g., on app launch or daily).
  static int applyDecay({
    required int currentPoints,
    required DateTime? lastReportDate,
  }) {
    if (lastReportDate == null || currentPoints <= 0) return currentPoints;

    final daysSinceLastReport = DateTime.now().difference(lastReportDate).inDays;
    final monthsPassed = daysSinceLastReport ~/ 30;
    final decayAmount = monthsPassed * decayPerMonth;

    return (currentPoints - decayAmount).clamp(0, 100);
  }
}
