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
  final PageController _durationPageController = PageController(viewportFraction: 0.33);
  bool _bioChanged = false;
  bool _showCommitOptions = false;
  int _selectedScrollDurationIndex = 0;
  bool _isPickingBailoutDuration = false;
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
                          if (isLocked && !_isPickingBailoutDuration && !_isEditingBailout)
                            _buildLockUI(context, lockTimeLeft, t)
                          else if (_isPickingBailoutDuration)
                            _buildBailoutDurationPicker(context, t)
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
                                      _showCommitOptions = false;
                                    });
                                    messenger.showSnackBar(SnackBar(content: Text(t.bio_bailout_used), backgroundColor: themeColor));
                                  }
                                } else {
                                  if (mounted) {
                                    messenger.showSnackBar(SnackBar(content: Text(t.bio_not_enough_coins), backgroundColor: Colors.redAccent));
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
                          else if (_showCommitOptions)
                            _buildScrollWheelOptions(context, t)
                          else if (_bioChanged)
                            GestureDetector(
                              onTap: () {
                                final text = _bioController.text.trim();
                                if (text.isEmpty) return;
                                setState(() {
                                  _showCommitOptions = true;
                                });
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
                            ),
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
                                  SnackBar(
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
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
        title: Text("Bailout", style: TextStyle(color: widget.isDark ? Colors.white : Colors.black87)),
        content: Text(t.bio_bailout_warning, style: TextStyle(color: widget.isDark ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.continue_btn, style: TextStyle(color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).then((result) {
      if (result == true && mounted) {
        setState(() {
          _isPickingBailoutDuration = true;
        });
      }
    });
  }

  Widget _buildBailoutDurationPicker(BuildContext context, Translations t) {
    final themeColor = widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;
    final labels = [t.bio_duration_3, t.bio_duration_5, t.bio_duration_7, t.bio_duration_15, t.bio_duration_30];
    final days = [3, 5, 7, 15, 30];

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(days.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _bailoutSelectedDuration = days[index];
                  _isPickingBailoutDuration = false;
                  _isEditingBailout = true;
                });
                _showBailoutConfirmDialog(context, t);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showBailoutConfirmDialog(BuildContext context, Translations t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
        content: Text(t.bio_bailout_confirm, style: TextStyle(color: widget.isDark ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.ok, style: TextStyle(color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollWheelOptions(BuildContext context, Translations t) {
    final themeColor = widget.isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;
    final labels = [t.bio_duration_3, t.bio_duration_5, t.bio_duration_7, t.bio_duration_15, t.bio_duration_30];
    final days = [3, 5, 7, 15, 30];

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        width: 36,
        height: 70,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification && notification.depth == 0) {
              final text = _bioController.text.trim();
              if (text.isNotEmpty) {
                 final am = Provider.of<AccountManager>(context, listen: false);
                 final messenger = ScaffoldMessenger.of(context);
                 am.updateBio(text, days[_selectedScrollDurationIndex]).then((success) {
                   if (success && mounted) {
                     setState(() {
                       _bioChanged = false;
                       _showCommitOptions = false;
                     });
                     messenger.showSnackBar(SnackBar(content: Text(t.bio_updated), backgroundColor: themeColor));
                   } else if (!success && mounted) {
                     messenger.showSnackBar(SnackBar(content: Text(t.bio_not_enough_coins), backgroundColor: Colors.redAccent));
                   }
                 });
              }
            }
            return false;
          },
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _durationPageController,
            itemCount: days.length,
            onPageChanged: (index) {
              setState(() {
                _selectedScrollDurationIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final isSelected = index == _selectedScrollDurationIndex;
              return GestureDetector(
                onTap: () {
                   if (isSelected) {
                     final text = _bioController.text.trim();
                     if (text.isNotEmpty) {
                       final am = Provider.of<AccountManager>(context, listen: false);
                       final messenger = ScaffoldMessenger.of(context);
                       am.updateBio(text, days[index]).then((success) {
                         if (success && mounted) {
                           setState(() {
                             _bioChanged = false;
                             _showCommitOptions = false;
                           });
                           messenger.showSnackBar(SnackBar(content: Text(t.bio_updated), backgroundColor: themeColor));
                         }
                       });
                     }
                   } else {
                     _durationPageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                   }
                },
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? themeColor : Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
