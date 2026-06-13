import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../language/language_manager.dart';
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

  @override
  void initState() {
    super.initState();
    if (!widget.isOtherUser) {
      final lang = context.read<LanguageManager>();
      _bioController.text = widget.user.bio == lang.getString('no_bio_yet') || widget.user.bio == "No bio yet" ? "" : widget.user.bio;
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
                    context.watch<LanguageManager>().getString('bio'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.user.bio.isEmpty ? context.watch<LanguageManager>().getString('no_bio_yet') : widget.user.bio,
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
                      color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.watch<LanguageManager>().getString('bio'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _bioController,
                          maxLines: 2,
                          maxLength: 80,
                          onChanged: (val) {
                            if (!_bioChanged) {
                              setState(() => _bioChanged = true);
                            }
                          },
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: context.watch<LanguageManager>().getString('write_bio'),
                            hintStyle: TextStyle(
                              color: widget.isDark ? Colors.grey[600] : Colors.grey[400],
                            ),
                            counterText: '',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_bioChanged)
                        GestureDetector(
                          onTap: () async {
                            final text = _bioController.text.trim();
                            if (text.isEmpty) return;
                            await Provider.of<AccountManager>(
                              context,
                              listen: false,
                            ).updateBio(text);
                            setState(() => _bioChanged = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.read<LanguageManager>().getString('bio_updated')),
                                  backgroundColor: widget.isDark
                                      ? AmomimusDarkTheme.policeLineYellow
                                      : AmomimusDarkTheme.primaryPurple,
                                ),
                              );
                            }
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
              color: widget.isDark ? AmomimusDarkTheme.surfaceDark : const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isDark ? AmomimusDarkTheme.policeLineYellow.withValues(alpha: 0.5) : Colors.amber.shade300,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isDark
                      ? AmomimusDarkTheme.policeLineYellow.withValues(alpha: 0.1)
                      : Colors.amber.withValues(alpha: 0.2),
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
                      color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : Colors.amber.shade800,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.watch<LanguageManager>().getString('coins_redemption'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.isDark ? AmomimusDarkTheme.policeLineYellow : Colors.amber.shade900,
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
                      final lastRedeemedDate = DateTime.tryParse(widget.user.lastRedeemed!);
                      if (lastRedeemedDate != null) {
                        final difference = DateTime.now().difference(lastRedeemedDate);
                        final remaining = const Duration(minutes: 30) - difference;

                        if (remaining.inSeconds > 0) {
                          canRedeem = false;
                          final m = remaining.inMinutes.toString().padLeft(2, '0');
                          final s = (remaining.inSeconds % 60).toString().padLeft(2, '0');
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
                                    content: Text(context.read<LanguageManager>().getString('redeemed_100_coins')),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: canRedeem ? const Color(0xFFFFD54F) : Colors.grey[400],
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
}
