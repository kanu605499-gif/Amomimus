import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../database/models/user_register_sql.dart';
import '../data/anonymous_names.dart';
import '../services/account_manager.dart';
import '../database_helper.dart'; // for UserAccount
import 'package:amomimus/screens/feed_screen.dart';
import 'package:amomimus/screens/login.dart';

// =========================================================================
// CHOOSE YOUR AMOMUS PAGE
// =========================================================================
class ChooseAmomusPage extends StatefulWidget {
  final String email;
  final String realUsername;
  final String password;
  final String favoriteCharacter;
  final String dateOfBirth;
  final bool isDarkMode;

  const ChooseAmomusPage({
    super.key,
    required this.email,
    required this.realUsername,
    required this.password,
    required this.favoriteCharacter,
    required this.dateOfBirth,
    required this.isDarkMode,
  });

  @override
  State<ChooseAmomusPage> createState() => _ChooseAmomusPageState();
}

class _ChooseAmomusPageState extends State<ChooseAmomusPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;
  final TextEditingController _usernameController = TextEditingController();

  String? _selectedGender;
  final String _generatedId = 'AM*-******';
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleProceed() async {
    if (_isRegistering) return;
    setState(() => _isRegistering = true);

    try {
      // 1. Prepare login credentials
      final newUserSql = UserModelSql(
        fullName: widget.realUsername,
        email: widget.email,
        favoriteCharacter: widget.favoriteCharacter,
        password: widget.password,
      );

      // 2. Prepare the Amomimus UserAccount identity
      final customName = _usernameController.text.trim();
      final alpha = String.fromCharCode(math.Random().nextInt(26) + 65); // Random A-Z
      final numeric = math.Random().nextInt(1000000).toString().padLeft(6, '0'); // Random 000000-999999
      final realGeneratedId = 'AM$alpha-$numeric'; // Backend generation mock

      final userAcc = UserAccount(
        email: widget.email,
        realUsername: widget.realUsername,
        anonymousUsername: AnonymousNames.getRandomName(
          _selectedGender ?? 'Amo',
        ),
        customUsername: customName.isNotEmpty ? customName : null,
        amomimusId: realGeneratedId,
        gender: _selectedGender ?? 'Amo',
        registrationDate: DateTime.now().toIso8601String().split('T').first,
        isDemo: false,
        dateOfBirth: widget.dateOfBirth,
      );

      // 3. Register and Login via AccountManager (Hybrid Architecture)
      bool isSuccess = await context.read<AccountManager>().registerAndLogin(
        newUserSql,
        userAcc,
      );

      if (!mounted) return;

      if (isSuccess) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AmomimusApp5()),
          (route) => false,
        );
      } else {
        _showAlreadyRegisteredDialog();
      }
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  void _showIncompleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDarkMode
            ? const Color(0xff1e1b24)
            : const Color(0xfffdfbfe),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: widget.isDarkMode
                ? const Color(0xff3d344d)
                : const Color(0xffe1dbec),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.incomplete_selection,
                style: TextStyle(
                  color: widget.isDarkMode
                      ? Colors.white
                      : const Color(0xff121212),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          "${t.incomplete_selection_desc_1}\"${t.anonymous_username_label}\"${t.incomplete_selection_desc_2}",
          style: TextStyle(
            color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              t.cancel,
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleProceed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6c52a3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              t.proceed,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAlreadyRegisteredDialog() {
    final t = Translations.of(context);
    bool hasRedirected = false;

    void redirect() {
      if (hasRedirected || !mounted) return;
      hasRedirected = true;
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AmomimusApp2()),
        (route) => false,
      );
    }

    // Auto redirect to login after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), redirect);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDarkMode
            ? const Color(0xff1e1b24)
            : const Color(0xfffdfbfe),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: widget.isDarkMode
                ? const Color(0xff3d344d)
                : const Color(0xffe1dbec),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.email_already_registered_title,
                style: TextStyle(
                  color: widget.isDarkMode
                      ? Colors.white
                      : const Color(0xff121212),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.email_already_registered_desc,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xff8c72c4),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: redirect,
            icon: const Icon(Icons.send),
            color: const Color(0xff8c72c4),
            splashRadius: 24,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordLabel(String text, Color mainTextColor) {
    final words = text.split(' ');
    final List<TextSpan> spans = [];
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final strippedWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
      final isKeyword =
          strippedWord.toUpperCase() == 'AMOMUS' ||
          strippedWord.toUpperCase() == 'AMOMIMUS';
      spans.add(
        TextSpan(
          text: word + (i < words.length - 1 ? ' ' : ''),
          style: TextStyle(
            color: isKeyword ? const Color(0xff8c72c4) : mainTextColor,
          ),
        ),
      );
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontFamily: 'Sans-Serif',
        ),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final Color mainTextColor = widget.isDarkMode
        ? Colors.white
        : const Color(0xff121212);
    final Color subTextColor = widget.isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;
    final Color scaffoldBg = widget.isDarkMode
        ? const Color(0xff121212)
        : const Color(0xfffdfbfe);
    final Color cardBg = widget.isDarkMode
        ? const Color(0xff1e1b24)
        : Colors.white;
    final Color borderColor = widget.isDarkMode
        ? const Color(0xff3d344d)
        : const Color(0xffe1dbec);

    final List<Map<String, dynamic>> genders = [
      {
        'label': 'Amo',
        'icon': Icons.diamond_outlined,
        'iconColor': const Color(0xFFB388FF),
        'bgColor': const Color.fromARGB(255, 250, 246, 255),
        'phase': 0.0,
      },
      {
        'label': 'Amom',
        'icon': Icons.android_outlined,
        'iconColor': const Color(0xFFFFCA28),
        'bgColor': const Color.fromARGB(255, 255, 251, 240),
        'phase': 2.0,
      },
      {
        'label': 'Ami',
        'icon': Icons.water_outlined,
        'iconColor': const Color(0xFFBDBDBD),
        'bgColor': const Color.fromARGB(255, 248, 248, 248),
        'phase': 4.0,
      },
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Delete back arrow icon
        title: RichText(
          text: TextSpan(
            text: t.create_your,
            style: TextStyle(
              color:
                  mainTextColor, // Base title color to black/white (e.g. あなたの)
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Sans-Serif',
            ),
            children: const [
              TextSpan(
                text: ' Amomus',
                style: TextStyle(color: Color(0xff8c72c4)), // Amomus is purple
              ),
            ],
          ),
        ),
        backgroundColor: cardBg,
        elevation: 0,
        iconTheme: IconThemeData(color: mainTextColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ── ANONYMOUS USERNAME (ON THE TOP) ──
            _buildKeywordLabel(t.anonymous_username_label, mainTextColor),
            const SizedBox(height: 8),
            TextFormField(
              controller: _usernameController,
              style: const TextStyle(color: Color(0xff8c72c4)),
              decoration: InputDecoration(
                hintText: t.enter_username_hint,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                filled: true,
                fillColor: cardBg,
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xff8c72c4),
                    width: 2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                t.leave_blank_random,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xff8c72c4),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // 2. ── AMOMIMUS ID GENERATOR (SECOND, CENSORED) ──
            _buildKeywordLabel(t.id_generator_title, mainTextColor),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.random_generate_id,
                          style: TextStyle(fontSize: 12, color: subTextColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _generatedId,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8c72c4),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Removed the refresh button because it is censored/automatic
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xff8c72c4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // 3. ── CHOOSE AVATAR TITLE & SELECTOR (IN THE MIDDLE) ──
            _buildKeywordLabel(t.choose_avatar_title, mainTextColor),
            const SizedBox(height: 32), // INCREASED VERTICAL GAP BEFORE ICONS
            // ── ANIMATED GENDER SELECTOR (stair bounce) ──
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ), // Adjust padding since margin expands height naturally
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Let items align to top
                  children: genders.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final g = entry.value;
                    final bool isSelected = _selectedGender == g['label'];
                    // Stair offset: 0, 60, 120 for a very clear diagonal gap vertically
                    final double stairOffset = index * 60.0;

                    return AnimatedBuilder(
                      animation: _floatingController,
                      builder: (context, child) {
                        final double wave = math.sin(
                          (_floatingController.value * 2 * math.pi) +
                              (g['phase'] as double),
                        );
                        return Transform.translate(
                          offset: Offset(
                            0,
                            wave * 8,
                          ), // Only wave animation here
                          child: child,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ), // Standard horizontal layout
                        width: 90, // Adjusted size to fit all screens
                        height: 90, // Adjusted size to fit all screens
                        child: Material(
                          color: g['bgColor'] as Color, // ALWAYS colored
                          elevation: isSelected ? 8 : 4,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: isSelected
                                ? BorderSide(
                                    color: g['iconColor'] as Color,
                                    width: 3,
                                  )
                                : BorderSide.none,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedGender = g['label'] as String;
                              });
                            },
                            child: Center(
                              child: Icon(
                                g['icon'] as IconData,
                                size: 50, // Big icon
                                color: g['iconColor'] as Color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Dynamic Chosen text below icons
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ), // Reduced to 16 since the Row now has bottom padding 140
                child: Builder(
                  builder: (context) {
                    Color chosenColor = const Color(0xff8c72c4);
                    if (_selectedGender != null) {
                      final match = genders.firstWhere(
                        (g) => g['label'] == _selectedGender,
                        orElse: () => genders[0],
                      );
                      chosenColor = match['iconColor'] as Color;
                    }
                    if (_selectedGender == null) {
                      return Text(
                        t.character_not_chosen,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      );
                    } else {
                      return RichText(
                        text: TextSpan(
                          text: t.chosen_amomus_prefix,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8c72c4), // Normal purple color
                            fontFamily: 'Sans-Serif',
                          ),
                          children: [
                            TextSpan(
                              text: _selectedGender,
                              style: TextStyle(
                                color: chosenColor,
                              ), // Unique color only for the name
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 36),

            // 4. ── PROCEED BUTTON ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isRegistering || _selectedGender == null
                    ? null
                    : () {
                        if (_usernameController.text.trim().isEmpty) {
                          _showIncompleteDialog();
                        } else {
                          _handleProceed();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6c52a3),
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _isRegistering
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        t.proceed,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
