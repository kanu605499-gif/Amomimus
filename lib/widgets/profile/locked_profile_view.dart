import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';

class LockedProfileView extends StatelessWidget {
  final bool isDark;

  const LockedProfileView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(40),
      decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration
          .copyWith(
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
              width: 2,
            ),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            t.profile_locked,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            t.locked_desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
