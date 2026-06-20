import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../database/preference_handler.dart';
import 'package:amomimus/screens/about_screen.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../database/models/user_register_sql.dart';
import '../data/anonymous_names.dart';
import '../services/account_manager.dart';
import 'package:amomimus/screens/feed_screen.dart';
import 'package:amomimus/screens/choose_amomimus_screen.dart';

class AmomimusApp4 extends StatefulWidget {
  final String email;
  final String realUsername;
  final String password;
  final String favoriteCharacter;

  const AmomimusApp4({
    super.key,
    required this.email,
    required this.realUsername,
    required this.password,
    required this.favoriteCharacter,
  });

  @override
  State<AmomimusApp4> createState() => _AmomimusApp4State();
}

class _AmomimusApp4State extends State<AmomimusApp4> {
  int _currentIndex = 0;
  final bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final Color mainTextColor = _isDarkMode
        ? Colors.white
        : const Color(0xff121212);
    final Color scaffoldBg = _isDarkMode
        ? const Color(0xff121212)
        : const Color(0xfffdfbfe);
    final Color navBg = _isDarkMode ? const Color(0xff1e1b24) : Colors.white;
    final Color borderColor = _isDarkMode
        ? const Color(0xff3d344d)
        : const Color(0xffe1dbec);

    final List<Widget> pages = [
      AmomimusFormPage(
        email: widget.email,
        realUsername: widget.realUsername,
        password: widget.password,
        favoriteCharacter: widget.favoriteCharacter,
        isDarkMode: _isDarkMode,
      ),
      AboutPage(
        isDarkMode: _isDarkMode,
        onBackToPrivacy: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 9.0),
          child: RichText(
            text: TextSpan(
              text: _currentIndex == 0 ? '${t.privacy} ' : '${t.about} ',
              style: TextStyle(
                color: mainTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Sans-Serif',
              ),
              children: [
                TextSpan(
                  text: _currentIndex == 0 ? t.policy : 'Amomimus',
                  style: TextStyle(color: const Color(0xff8c72c4)),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: navBg,
        elevation: 0,
        iconTheme: IconThemeData(color: mainTextColor),
        automaticallyImplyLeading: false,
        leading: null,
      ),
      drawer: null,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: navBg,
        selectedItemColor: const Color(0xff8c72c4),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.shield_outlined),
            label: t.privacy,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline),
            label: t.about,
          ),
        ],
      ),
    );
  }
}

class AmomimusFormPage extends StatefulWidget {
  final String email;
  final String realUsername;
  final String password;
  final String favoriteCharacter;
  final bool isDarkMode;

  const AmomimusFormPage({
    super.key,
    required this.email,
    required this.realUsername,
    required this.password,
    required this.favoriteCharacter,
    required this.isDarkMode,
  });

  @override
  State<AmomimusFormPage> createState() => _AmomimusFormPageState();
}

class _AmomimusFormPageState extends State<AmomimusFormPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;
  bool _hasAcceptedTerms = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    if (_selectedDate == null) return 'Pick Date';
    final day = _selectedDate!.day.toString().padLeft(2, '0');
    final month = _selectedDate!.month.toString().padLeft(2, '0');
    final year = _selectedDate!.year;

    final String currentLang = LocaleSettings.currentLocale.languageTag;
    return currentLang.startsWith('en')
        ? '$month/$day/$year'
        : '$day/$month/$year';
  }

  Future<void> _pickDate(BuildContext context) async {
    final t = Translations.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: t.select_date,
      cancelText: t.cancel,
      confirmText: t.ok,
      errorFormatText: t.error_format,
      errorInvalidText: t.error_invalid,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
            colorScheme: widget.isDarkMode
                ? const ColorScheme.dark(
                    primary: Color(0xfff1c66a),
                    onPrimary: Colors.black,
                    surface: Color(0xff1e1b24),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xff6c52a3),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
            dialogTheme: DialogThemeData(
              backgroundColor: widget.isDarkMode
                  ? const Color(0xff1e1b24)
                  : Colors.white,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              bodyMedium: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              titleMedium: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              hintStyle: TextStyle(
                color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: widget.isDarkMode
                      ? const Color(0xfff1c66a)
                      : const Color(0xff6c52a3),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color currentCardBg = widget.isDarkMode
        ? const Color(0xff1e1b24)
        : Colors.white;
    final Color mainTextColor = widget.isDarkMode
        ? Colors.white
        : const Color(0xff121212);
    final Color subTextColor = widget.isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;
    final Color borderColor = widget.isDarkMode
        ? const Color(0xff3d344d)
        : const Color(0xffe1dbec);

    return Stack(
      children: [
        Positioned(
          top: -39,
          right: -40,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -12 * Curves.easeInOut.transform(_floatingController.value),
                ),
                child: Transform.rotate(angle: 0.15, child: child),
              );
            },
            child: _buildFloatingContainer(
              bgColor: widget.isDarkMode
                  ? const Color(0x2F252030)
                  : const Color.fromARGB(255, 250, 246, 255),
              icon: Icons.diamond_outlined,
              iconColor: widget.isDarkMode
                  ? const Color(0xff9a82c7)
                  : const Color.fromARGB(255, 215, 192, 255),
            ),
          ),
        ),
        Positioned(
          top: 125,
          bottom: 125,
          left: 25,
          right: 15,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -12 * Curves.easeInOut.transform(_floatingController.value),
                ),
                child: Transform.rotate(angle: 0.15, child: child),
              );
            },
            child: Center(
              child: _buildFloatingContainer(
                bgColor: widget.isDarkMode
                    ? const Color.fromARGB(29, 58, 53, 37)
                    : const Color.fromARGB(255, 255, 251, 240),
                icon: Icons.android_outlined,
                iconColor: widget.isDarkMode
                    ? const Color.fromARGB(255, 241, 198, 106)
                    : const Color(0xFFFFD54F),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -59,
          left: -35,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -12 * Curves.easeInOut.transform(_floatingController.value),
                ),
                child: Transform.rotate(angle: -0.15, child: child),
              );
            },
            child: Center(
              child: _buildFloatingContainer(
                bgColor: widget.isDarkMode
                    ? const Color.fromARGB(29, 58, 53, 37)
                    : const Color(0xFFF8F8F8),
                icon: Icons.water_outlined,
                iconColor: widget.isDarkMode
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFFE0E0E0),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  top: 16.0,
                  right: 24.0,
                ),
                child: RichText(
                  text: TextSpan(
                    text: t.terms_of,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                      fontFamily: 'Sans-Serif',
                    ),
                    children: const [
                      TextSpan(
                        text: 'Amomimus ',
                        style: const TextStyle(color: Color(0xff8c72c4)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 485,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: currentCardBg.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.privacy_rules_agreement,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8c72c4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        t.privacy_rules_text,
                        style: TextStyle(
                          fontSize: 14,
                          color: subTextColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.system_language,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: mainTextColor,
                          ),
                        ),
                        DropdownButton<String>(
                          value: () {
                            switch (LocaleSettings.currentLocale) {
                              case AppLocale.en:
                                return 'English';
                              case AppLocale.ja:
                                return '忍者';
                              case AppLocale.tm:
                                return 'Tamriel';
                              case AppLocale.de:
                                return 'Deutsch';
                              case AppLocale.th:
                                return 'ภาษาไทย';
                              default:
                                return 'Bahasa';
                            }
                          }(),
                          dropdownColor: currentCardBg,
                          style: TextStyle(
                            color: mainTextColor,
                            fontFamily: 'Sans-Serif',
                          ),
                          underline: Container(
                            height: 0.7,
                            color: const Color(0xff8c72c4),
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                if (newValue == 'Bahasa') {
                                  LocaleSettings.setLocale(AppLocale.id);
                                  PreferenceHandler.setLanguage('id');
                                } else if (newValue == 'English') {
                                  LocaleSettings.setLocale(AppLocale.en);
                                  PreferenceHandler.setLanguage('en');
                                } else if (newValue == 'Deutsch') {
                                  LocaleSettings.setLocale(AppLocale.de);
                                  PreferenceHandler.setLanguage('de');
                                } else if (newValue == 'ภาษาไทย') {
                                  LocaleSettings.setLocale(AppLocale.th);
                                  PreferenceHandler.setLanguage('th');
                                } else if (newValue == '忍者') {
                                  LocaleSettings.setLocale(AppLocale.ja);
                                  PreferenceHandler.setLanguage('ja');
                                } else if (newValue == 'Tamriel') {
                                  LocaleSettings.setLocale(AppLocale.tm);
                                  PreferenceHandler.setLanguage('tm');
                                }
                              });
                            }
                          },
                          items:
                              <String>[
                                'Bahasa',
                                'Deutsch',
                                'English',
                                'ภาษาไทย',
                                '忍者',
                                'Tamriel',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.dob,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: mainTextColor,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _pickDate(context),
                          icon: Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: _selectedDate != null
                                ? const Color(0xff8c72c4)
                                : Colors.redAccent,
                          ),
                          label: Text(
                            _getFormattedDate(),
                            style: TextStyle(
                              color: _selectedDate != null
                                  ? const Color(0xff8c72c4)
                                  : Colors.redAccent,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _selectedDate != null
                                  ? borderColor
                                  : Colors.redAccent.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedDate == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          t.dob_required,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.redAccent.withValues(alpha: 0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    Divider(height: 32, color: borderColor),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              _hasAcceptedTerms
                                  ? t.agreement_verified
                                  : t.ready_to_verify,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _hasAcceptedTerms
                                    ? const Color(0xff8c72c4)
                                    : Colors.grey[600],
                              ),
                            ),
                            value: _hasAcceptedTerms,
                            activeColor: const Color(0xff8c72c4),
                            checkColor: Colors.white,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? value) {
                              setState(() {
                                _hasAcceptedTerms = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: (_hasAcceptedTerms && _selectedDate != null)
                            ? () async {
                                // Verify age >= 18
                                final now = DateTime.now();
                                final age =
                                    now.year -
                                    _selectedDate!.year -
                                    ((now.month < _selectedDate!.month ||
                                            (now.month ==
                                                    _selectedDate!.month &&
                                                now.day < _selectedDate!.day))
                                        ? 1
                                        : 0);

                                if (age < 18) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        t.age_warning,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Navigate to Choose Your Amomus page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChooseAmomusPage(
                                      email: widget.email,
                                      realUsername: widget.realUsername,
                                      password: widget.password,
                                      favoriteCharacter:
                                          widget.favoriteCharacter,
                                      dateOfBirth: _getFormattedDate(),
                                      isDarkMode: widget.isDarkMode,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6c52a3),
                          disabledBackgroundColor: widget.isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            (_hasAcceptedTerms && _selectedDate != null)
                                ? t.accept_continue
                                : _selectedDate == null
                                ? t.select_birthday_first
                                : t.accept_terms_first,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: (_hasAcceptedTerms && _selectedDate != null)
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingContainer({
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Opacity(
      opacity: 0.3,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: 140,
          height: 160,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(child: Icon(icon, size: 48, color: iconColor)),
        ),
      ),
    );
  }
}
