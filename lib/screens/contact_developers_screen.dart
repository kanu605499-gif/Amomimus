import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../amomimusdark.dart';
import '../models/developer_model.dart';
import 'package:amomimus/i18n/strings.g.dart';

class ContactDevelopersScreen extends StatefulWidget {
  const ContactDevelopersScreen({super.key});

  @override
  State<ContactDevelopersScreen> createState() => _ContactDevelopersScreenState();
}

class _ContactDevelopersScreenState extends State<ContactDevelopersScreen>
    with SingleTickerProviderStateMixin {
  late List<DeveloperModel> _developers;

  Offset _dragOffset = Offset.zero;
  bool _isSwipingAway = false;
  double _angle = 0;

  late AnimationController _hintController;

  @override
  void initState() {
    super.initState();
    _developers = DeveloperModel.mockDevelopers.toList();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _hintController.addListener(() {
      if (!_isSwipingAway && _dragOffset == Offset.zero && mounted) {
        setState(() {
          _angle = sin(_hintController.value * pi * 2) * 0.04;
        });
      }
    });

    _startHintLoop();
  }

  void _startHintLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 2100));
      if (!mounted) break;
      if (_isSwipingAway || _dragOffset != Offset.zero) continue;

      try {
        await _hintController.forward(from: 0.0);
        await _hintController.reverse();
      } catch (e) {
        break;
      }
    }
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isSwipingAway) return;
    if (_hintController.isAnimating) {
      _hintController.stop();
    }
    setState(() {
      _dragOffset += details.delta;
      _angle = _dragOffset.dx / 400;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isSwipingAway) return;

    if (_dragOffset.dx.abs() > 100) {
      setState(() {
        _isSwipingAway = true;
        _dragOffset = Offset(_dragOffset.dx.sign * 600, _dragOffset.dy);
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          final topDev = _developers.removeAt(0);
          _developers.add(topDev);
          _isSwipingAway = false;
          _dragOffset = Offset.zero;
          _angle = 0;
        });
      });
    } else {
      setState(() {
        _dragOffset = Offset.zero;
        _angle = 0;
      });
    }
  }

  Future<void> _launchDeveloperUrl(DeveloperModel dev) async {
    final Uri url = Uri.parse(dev.url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar( 
          SnackBar(behavior: SnackBarBehavior.floating, margin: EdgeInsets.only(bottom: 100.0, left: 24.0, right: 24.0), content: Text('Could not launch ${dev.url}')),
        );
      }
    }
  }

  Widget _buildCard(DeveloperModel dev, bool isDark, {bool isFront = false}) {
    double dragOpacity = (1.0 - (_dragOffset.dx.abs() / 300)).clamp(0.2, 1.0);

    if (isFront) {
      return GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: AnimatedContainer(
          duration: _isSwipingAway
              ? const Duration(milliseconds: 300)
              : const Duration(milliseconds: 0),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(_dragOffset.dx, _dragOffset.dy)
            ..rotateZ(_angle),
          child: AnimatedOpacity(
            duration: _isSwipingAway
                ? const Duration(milliseconds: 300)
                : const Duration(milliseconds: 0),
            opacity: _isSwipingAway ? 0.0 : dragOpacity,
            child: _buildCardContent(dev, isDark),
          ),
        ),
      );
    }

    return Transform.scale(scale: 0.9, child: _buildCardContent(dev, isDark));
  }

  Widget _buildCardContent(DeveloperModel dev, bool isDark) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    
    return AspectRatio(
      aspectRatio: 2.5 / 3.5,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? AmomimusDarkTheme.primaryPurple.withValues(alpha: 0.5)
                : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AmomimusDarkTheme.backgroundDark,
                              const Color(0xff8c72c4).withValues(alpha: 0.4),
                            ]
                          : [
                              Colors.grey[100]!,
                              const Color(0xff8c72c4).withValues(alpha: 0.2),
                            ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark 
                            ? AmomimusDarkTheme.surfaceDark.withValues(alpha: 0.8)
                            : Colors.white.withValues(alpha: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: AmomimusDarkTheme.primaryPurple.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        dev.icon,
                        size: 80,
                        color: isDark
                            ? AmomimusDarkTheme.policeLineYellow
                            : AmomimusDarkTheme.primaryPurple,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              dev.displayName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AmomimusDarkTheme.policeLineYellow
                                    : AmomimusDarkTheme.primaryPurple,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dev.handle,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? AmomimusDarkTheme.textPrimary
                              : Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // using the translation key added via script, fallback if not updated yet
                        (t as dynamic).developer_role ?? 'Developer',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? AmomimusDarkTheme.textSecondary
                              : Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _launchDeveloperUrl(dev),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AmomimusDarkTheme.policeLineYellow
                                : AmomimusDarkTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: (isDark
                                        ? AmomimusDarkTheme.policeLineYellow
                                        : AmomimusDarkTheme.primaryPurple)
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              dev.type == DeveloperCardType.email
                                  ? ((t as dynamic).send_email ?? 'Send Email')
                                  : ((t as dynamic).visit_instagram ?? 'Visit Instagram'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          t.contact_dev,
          style: TextStyle(
            color: isDark
                ? AmomimusDarkTheme.policeLineYellow
                : AmomimusDarkTheme.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark
              ? AmomimusDarkTheme.policeLineYellow
              : AmomimusDarkTheme.primaryPurple,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: _developers.isEmpty
                ? const SizedBox()
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_developers.length > 1)
                        _buildCard(_developers[1], isDark, isFront: false),
                      _buildCard(_developers[0], isDark, isFront: true),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
