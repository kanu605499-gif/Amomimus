import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';

import '../../services/account_manager.dart';

class ProfileBioSection extends StatefulWidget {
  final dynamic user;
  final bool isDark;
  final bool isOtherUser;

  const ProfileBioSection({
    super.key,
    required this.user,
    required this.isDark,
    required this.isOtherUser,
  });

  @override
  State<ProfileBioSection> createState() => _ProfileBioSectionState();
}

class _ProfileBioSectionState extends State<ProfileBioSection> {
  final PageController _pageController = PageController();
  final TextEditingController _bioController = TextEditingController();
  bool _bioChanged = false;
  int _selectedScrollDurationIndex = 0;
  bool _isEditingBailout = false;
  int _bailoutSelectedDuration = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.isOtherUser) {
      _bioController.text =
          widget.user.bio == t.no_bio_yet || widget.user.bio == "No bio yet"
          ? ""
          : widget.user.bio;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    if (widget.isOtherUser) {
      return SizedBox(
        height: 140,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t.bio,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.isDark
                          ? Colors.grey[400]
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.user.bio.isEmpty ? t.no_bio_yet : widget.user.bio,
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: PageView(
        controller: _pageController,
        children: [
          // Bio Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: widget.isDark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.bio,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isDark
                            ? Colors.grey[400]
                            : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Builder(
                  builder: (context) {
                    bool isLocked = false;
                    String lockTimeLeft = "";
                    if (widget.user.bioExpirationDate != null) {
                      final expDate = DateTime.tryParse(widget.user.bioExpirationDate!);
                      if (expDate != null && expDate.isAfter(DateTime.now())) {
                        isLocked = true;
                        final diff = expDate.difference(DateTime.now());
                        lockTimeLeft = "${diff.inDays}d ${diff.inHours % 24}h";
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _bioController,
                              maxLines: 2,
                              maxLength: 80,
                              readOnly: isLocked && !_isEditingBailout,
                              enableInteractiveSelection: !isLocked || _isEditingBailout,
                              onChanged: (val) {
                                if (!_bioChanged && !isLocked) {
                                  setState(() => _bioChanged = true);
                                } else if (isLocked && _isEditingBailout && !_bioChanged) {
                                  setState(() => _bioChanged = true);
                                }
                              },
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: t.write_bio,
                                hintStyle: TextStyle(
                                  color: widget.isDark
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                ),
                                counterText: '',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (isLocked && !_isEditingBailout)
                            _buildLockUI(context, lockTimeLeft, t)
                          else if (_isEditingBailout)
                            GestureDetector(
                              onTap: () async {
                                final text = _bioController.text.trim();
                                if (text.isEmpty) return;

                                final am = Provider.of<AccountManager>(context, listen: false);
                                final messenger = ScaffoldMessenger.of(context);
                                final themeColor = widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;
                                
                                final success = await am.bailoutBio();
                                if (success) {
                                  await am.updateBio(text, _bailoutSelectedDuration);
                                  if (mounted) {
                                    setState(() {
                                      _isEditingBailout = false;
                                      _bioChanged = false;
                                    });
                                    messenger.showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),content: Text(t.bio_bailout_used), backgroundColor: themeColor));
                                  }
                                } else {
                                  if (mounted) {
                                    messenger.showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),content: Text(t.bio_not_enough_coins), backgroundColor: Colors.redAccent));
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.send_rounded,
                                  size: 22,
                                  color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                                ),
                              ),
                            )
                          else if (_bioChanged)
                            GestureDetector(
                              onTap: () {
                                final text = _bioController.text.trim();
                                if (text.isEmpty) return;
                                _showConvexDurationPicker(context, t, false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.send_rounded,
                                  size: 22,
                                  color: widget.isDark
                                      ? AmomimusDarkTheme.policeLineYellow
                                      : AmomimusDarkTheme.primaryPurple,
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 30),
                        ],
                      ),
                    );
                  }
                ),
                const Spacer(),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xff8c72c4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Coins Redemption Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDark
                  ? AmomimusDarkTheme.surfaceDark
                  : const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isDark
                    ? AmomimusDarkTheme.policeLineYellow.withValues(alpha: 0.5)
                    : AmomimusDarkTheme.policeLineYellow.withValues(alpha: 0.8),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AmomimusDarkTheme.policeLineYellow.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 18,
                      color: widget.isDark
                          ? AmomimusDarkTheme.policeLineYellow
                          : Colors.amber.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.coins_redemption,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isDark
                            ? AmomimusDarkTheme.policeLineYellow
                            : Colors.amber.shade700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Builder(
                  builder: (context) {
                    bool canRedeem = true;
                    String countdownText = "";

                    if (widget.user.lastRedeemed != null) {
                      final lastRedeemedDate = DateTime.tryParse(
                        widget.user.lastRedeemed!,
                      );
                      if (lastRedeemedDate != null) {
                        final difference = DateTime.now().difference(
                          lastRedeemedDate,
                        );
                        final remaining =
                            const Duration(minutes: 30) - difference;

                        if (remaining.inSeconds > 0) {
                          canRedeem = false;
                          final m = remaining.inMinutes.toString().padLeft(
                            2,
                            '0',
                          );
                          final s = (remaining.inSeconds % 60)
                              .toString()
                              .padLeft(2, '0');
                          countdownText = "$m:$s";
                        }
                      }
                    }

                    return GestureDetector(
                      onTap: canRedeem
                          ? () async {
                              await Provider.of<AccountManager>(
                                context,
                                listen: false,
                              ).updateCoins(100, updateTimestamp: true);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
                                    content: Text(
                                      t.redeemed_100_coins,
                                      style: TextStyle(
                                        color: widget.isDark ? Colors.black : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    backgroundColor: AmomimusDarkTheme.policeLineYellow,
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: canRedeem
                              ? const Color(0xFFFFD54F)
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: canRedeem
                              ? const Icon(
                                  Icons.monetization_on,
                                  color: Colors.white,
                                  size: 28,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      countdownText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xff8c72c4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockUI(BuildContext context, String timeStr, Translations t) {
    final bool hasBailout = !widget.user.hasUsedBioBailout;
    final Color iconColor = hasBailout
        ? (widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple)
        : Colors.grey[500]!;

    return GestureDetector(
      onTap: hasBailout ? () => _showBailoutDialog(context, t) : null,
      child: Container(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, color: iconColor, size: 20),
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBailoutDialog(BuildContext context, Translations t) {
    final themeColor = widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: themeColor.withValues(alpha: 0.5), width: 1.5),
        ),
        title: Stack(
          clipBehavior: Clip.none,
          children: [
            Text(t.bio_bailout, style: TextStyle(color: widget.isDark ? Colors.white : Colors.black87)),
            Positioned(
              top: -15,
              right: -15,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.grey[500], size: 24),
                onPressed: () => Navigator.pop(ctx, false),
              ),
            ),
          ],
        ),
        content: Text(t.bio_bailout_warning, style: TextStyle(color: widget.isDark ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.continue_btn, style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).then((result) {
      if (result == true && mounted) {
        _showConvexDurationPicker(context, t, true);
      }
    });
  }

  void _showPostScrollConfirmDialog(BuildContext context, Translations t, bool isBailout, int durationDays, String durationLabel, Color themeColor) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: themeColor.withValues(alpha: 0.5), width: 1.5),
        ),
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: Text(
                isBailout
                    ? t.bio_bailout_confirm(duration: durationLabel)
                    : t.bio_first_time_confirm(duration: durationLabel),
                textAlign: TextAlign.center,
                style: TextStyle(color: widget.isDark ? Colors.white : Colors.black87, fontSize: 16, height: 1.4),
              ),
            ),
            Positioned(
              top: -20,
              right: -20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.grey[500], size: 24),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send, color: themeColor, size: 28),
            onPressed: () {
              Navigator.pop(ctx);
              if (!isBailout) {
                _commitBioChange(durationDays, themeColor, t);
              } else {
                setState(() => _isEditingBailout = true);
              }
            },
          ),
        ],
      ),
    );
  }

  void _commitBioChange(int durationDays, Color themeColor, Translations t) async {
    final text = _bioController.text.trim();
    if (text.isEmpty) return;
    
    final am = Provider.of<AccountManager>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final success = await am.updateBio(text, durationDays);
    if (success && mounted) {
      setState(() {
        _bioChanged = false;
      });
      messenger.showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),content: Text(t.bio_updated), backgroundColor: themeColor));
    } else if (!success && mounted) {
      messenger.showSnackBar(SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),content: Text(t.bio_not_enough_coins), backgroundColor: Colors.redAccent));
    }
  }

  void _showConvexDurationPicker(BuildContext context, Translations t, bool isBailout) {
    final themeColor = widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;
    final labels = [t.bio_duration_3, t.bio_duration_5, t.bio_duration_7, t.bio_duration_15, t.bio_duration_30];
    final days = [3, 5, 7, 15, 30];

    int localSelectedIndex = isBailout ? 0 : _selectedScrollDurationIndex;
    final scrollController = FixedExtentScrollController(initialItem: localSelectedIndex);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, localSelectedIndex),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        height: 250,
                        width: 120,
                        decoration: BoxDecoration(
                          color: widget.isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: themeColor.withValues(alpha: 0.5), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: themeColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: ListWheelScrollView.useDelegate(
                                controller: scrollController,
                                itemExtent: 50,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  localSelectedIndex = index;
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    return Center(
                                      child: Text(
                                        labels[index],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: themeColor,
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: days.length,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context, localSelectedIndex),
                                child: Icon(Icons.check_circle, color: themeColor, size: 36),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
    ).then((selectedIndex) {
      if (mounted) {
        int finalIndex = (selectedIndex as int?) ?? localSelectedIndex;
        if (isBailout) {
          setState(() {
            _bailoutSelectedDuration = days[finalIndex];
          });
          _showPostScrollConfirmDialog(context, t, true, days[finalIndex], labels[finalIndex], themeColor);
        } else {
          setState(() {
            _selectedScrollDurationIndex = finalIndex;
          });
          _showPostScrollConfirmDialog(context, t, false, days[finalIndex], labels[finalIndex], themeColor);
        }
      }
    });
  }
}
