import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:provider/provider.dart';
import 'package:amomimus/i18n/strings.g.dart';
import 'package:amomimus/amomimusdark.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final updateNavigatorObserver = UpdateNavigatorObserver();

class UpdateNavigatorObserver extends NavigatorObserver {
  int _routeCount = 0;
  VoidCallback? onTrigger;

  int _pauseCount = 0;
  
  void pause() {
    _pauseCount++;
  }

  void resume() {
    if (_pauseCount > 0) {
      _pauseCount--;
    }
  }

  bool get isPaused => _pauseCount > 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Only count actual screen transitions. We use post-frame callback so that
    // the pushed screen's initState() has time to call pause() BEFORE we count.
    if (previousRoute != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isPaused) {
          _routeCount++;
          if (_routeCount >= 5) {
            _routeCount = 0;
            onTrigger?.call();
          }
        }
      });
    }
  }
}

class CustomUpdateChecker extends StatefulWidget {
  final Widget child;
  const CustomUpdateChecker({super.key, required this.child});

  @override
  State<CustomUpdateChecker> createState() => _CustomUpdateCheckerState();
}

class _CustomUpdateCheckerState extends State<CustomUpdateChecker> {
  late final Upgrader _upgrader;
  bool _isDialogShowing = false;
  bool _isForceUpdate = false;
  String? _forceUpdateUrl;

  @override
  void initState() {
    super.initState();
    _upgrader = Upgrader(
      debugLogging: false,
      debugDisplayAlways: false, // Set this to true if you want to test it regardless of version
    );
    updateNavigatorObserver.onTrigger = _checkUpdate;
    _checkUpdate();
  }

  @override
  void dispose() {
    if (updateNavigatorObserver.onTrigger == _checkUpdate) {
      updateNavigatorObserver.onTrigger = null;
    }
    super.dispose();
  }

  Future<void> _checkUpdate() async {
    if (_isDialogShowing) return;

    // 1. Pengecekan Force Update dari Firestore
    try {
      final doc = await FirebaseFirestore.instance.collection('app_config').doc('version_control').get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final minVersionStr = data['min_version'] as String?;
        final updateUrl = data['update_url'] as String?;

        if (minVersionStr != null && minVersionStr.isNotEmpty) {
          final packageInfo = await PackageInfo.fromPlatform();
          final currentVersion = packageInfo.version;

          if (_isVersionLower(currentVersion, minVersionStr)) {
            _isForceUpdate = true;
            _forceUpdateUrl = updateUrl;
            if (mounted) {
              _showUpdateDialog();
            }
            return; // Stop here, no need to check upgrader
          }
        }
      }
    } catch (e) {
      print('Error checking force update: $e');
    }

    // 2. Pengecekan Normal via Upgrader (Play Store)
    await _upgrader.initialize();
    if (_upgrader.isUpdateAvailable()) {
      _isForceUpdate = false;
      if (mounted) {
        _showUpdateDialog();
      }
    }
  }

  bool _isVersionLower(String current, String minVersion) {
    List<int> currentParts = current.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    List<int> minParts = minVersion.split('.').map((s) => int.tryParse(s) ?? 0).toList();

    for (int i = 0; i < 3; i++) {
      int c = i < currentParts.length ? currentParts[i] : 0;
      int m = i < minParts.length ? minParts[i] : 0;
      if (c < m) return true;
      if (c > m) return false;
    }
    return false;
  }

  void _showUpdateDialog() {
    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = context.watch<AmomimusDarkTheme>().isDarkMode;
        final bgColor = isDark ? Colors.black : Colors.white;
        final fgColor = isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;

        return Dialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.system_update_rounded, size: 54, color: fgColor),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    t.update_available_title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: fgColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  t.update_available_body,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fgColor,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    if (_isForceUpdate && _forceUpdateUrl != null && _forceUpdateUrl!.isNotEmpty) {
                      final uri = Uri.parse(_forceUpdateUrl!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        _upgrader.sendUserToAppStore();
                      }
                    } else {
                      _upgrader.sendUserToAppStore();
                    }
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      t.update_now_btn,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (!_isForceUpdate) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? Colors.white54 : Colors.black54,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      _isDialogShowing = false;
                      Navigator.pop(context);
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        t.update_later_btn,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
