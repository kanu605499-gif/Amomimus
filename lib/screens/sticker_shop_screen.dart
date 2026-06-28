import 'package:amomimus/i18n/strings.g.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/effects/plastic_box_effect_model.dart';
import 'package:provider/provider.dart';
import '../amomimusdark.dart';

import '../models/sticker_batch_model.dart';
import '../services/account_manager.dart';
import 'sticker_inventory_screen.dart';

class StickerShopScreen extends StatefulWidget {
  const StickerShopScreen({super.key});

  @override
  State<StickerShopScreen> createState() => _StickerShopScreenState();
}

class _StickerShopScreenState extends State<StickerShopScreen>
    with SingleTickerProviderStateMixin {
  late List<StickerBatchModel> allMockBatches;

  Offset _dragOffset = Offset.zero;
  bool _isSwipingAway = false;
  double _angle = 0;

  late AnimationController _hintController;

  @override
  void initState() {
    super.initState();
    allMockBatches = StickerBatchModel.mockBatches.toList();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _hintController.addListener(() {
      if (!_isSwipingAway && _dragOffset == Offset.zero && mounted) {
        setState(() {
          // Subtle left-right wiggle (sine wave)
          _angle = sin(_hintController.value * pi * 2) * 0.04;
        });
      }
    });

    _startHintLoop();
  }

  void _startHintLoop() async {
    while (mounted) {
      // User requested 2.1 seconds delay
      await Future.delayed(const Duration(milliseconds: 2100));
      if (!mounted) break;
      if (_isSwipingAway || _dragOffset != Offset.zero) continue;

      try {
        await _hintController.forward(from: 0.0);
        await _hintController.reverse();
      } catch (e) {
        // Animation was interrupted or disposed
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
      _angle = _dragOffset.dx / 400; // gentle rotation
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isSwipingAway) return;

    // Swipe threshold
    if (_dragOffset.dx.abs() > 100) {
      setState(() {
        _isSwipingAway = true;
        // Move far off screen in the direction of the swipe
        _dragOffset = Offset(_dragOffset.dx.sign * 600, _dragOffset.dy);
      });

      // Wait for the animation to finish, then cycle the deck
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          final topBatch = allMockBatches.removeAt(0);
          allMockBatches.add(topBatch);
          _isSwipingAway = false;
          _dragOffset = Offset.zero;
          _angle = 0;
        });
      });
    } else {
      // Snap back to center
      setState(() {
        _dragOffset = Offset.zero;
        _angle = 0;
      });
    }
  }

  static IconData _getIconForAsset(String asset) {
    switch (asset) {
      case 'thumb_up':
        return Icons.thumb_up;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'favorite':
        return Icons.favorite;
      case 'sentiment_very_satisfied':
        return Icons.sentiment_very_satisfied;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'diamond':
        return Icons.diamond;
      case 'ghost':
        return Icons.smart_toy_outlined;
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'star':
        return Icons.star;
      case 'sentiment_dissatisfied':
        return Icons.sentiment_dissatisfied;
      case 'mood_bad':
        return Icons.mood_bad;
      case 'bolt':
        return Icons.bolt;
      default:
        return Icons.star;
    }
  }

  void _showPurchaseSheet(
    BuildContext context,
    StickerBatchModel batch,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    batch.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AmomimusDarkTheme.policeLineYellow
                          : AmomimusDarkTheme.primaryPurple,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AmomimusDarkTheme.primaryPurple.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AmomimusDarkTheme.primaryPurple,
                      ),
                    ),
                    child: Text(
                      batch.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AmomimusDarkTheme.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                t.includes_exclusive_items(count: batch.stickers.length),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AmomimusDarkTheme.textSecondary
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: batch.stickers.length,
                  itemBuilder: (context, index) {
                    final sticker = batch.stickers[index];
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 16),
                      child: PlasticBoxEffect(
                        borderRadius: 16.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF23232F)
                                : const Color(0xFFF4F0FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AmomimusDarkTheme.primaryPurple.withValues(
                                      alpha: 0.3,
                                    )
                                  : AmomimusDarkTheme.primaryPurple.withValues(
                                      alpha: 0.2,
                                    ),
                              width: 1.5,
                            ),
                            boxShadow: isDark
                                ? [
                                    BoxShadow(
                                      color: AmomimusDarkTheme.primaryPurple
                                          .withValues(alpha: 0.15),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              sticker.imageAsset.contains('/')
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (isDark)
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.08),
                                                  blurRadius: 15,
                                                  spreadRadius: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        Image.asset(
                                          sticker.imageAsset,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    )
                                  : Icon(
                                      _getIconForAsset(sticker.imageAsset),
                                      size: 60,
                                      color: isDark
                                          ? AmomimusDarkTheme.policeLineYellow
                                          : AmomimusDarkTheme.primaryPurple,
                                    ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  sticker.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AmomimusDarkTheme.textPrimary
                                        : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Consumer<AccountManager>(
                  builder: (context, accountManager, child) {
                    final isOwned =
                        accountManager.currentUser?.ownedStickerBatches
                            .contains(batch.id) ??
                        false;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AmomimusDarkTheme.policeLineYellow
                            : AmomimusDarkTheme.primaryPurple,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final accountManager = Provider.of<AccountManager>(
                          context,
                          listen: false,
                        );
                        final success = await accountManager
                            .purchaseStickerBatch(batch.id, batch.price);

                        if (!context.mounted) return;
                        Navigator.pop(context);

                        if (success) {
                          // Purchase successful, no snackbar needed.
                        } else {
                          final isOwned =
                              accountManager.currentUser?.ownedStickerBatches
                                  .contains(batch.id) ??
                              false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isOwned
                                    ? t.already_own_batch
                                    : t.not_enough_coins,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        isOwned ? t.view : '${t.buy} - ${batch.price} Coins',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(
    StickerBatchModel batch,
    bool isDark, {
    bool isFront = false,
  }) {
    // Dynamic opacity based on drag distance
    double dragOpacity = (1.0 - (_dragOffset.dx.abs() / 300)).clamp(0.2, 1.0);

    // If it's the front card, apply gesture detectors and animated transforms
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
            child: _buildCardContent(batch, isDark),
          ),
        ),
      );
    }

    // The card behind is slightly scaled down to give depth
    return Transform.scale(scale: 0.9, child: _buildCardContent(batch, isDark));
  }

  Widget _buildCardContent(StickerBatchModel batch, bool isDark) {
    return AspectRatio(
      aspectRatio: 2.5 / 3.5, // Poker Card Proportion
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
              // Top Half: The "Artwork" section of the card
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    batch.coverAsset != null
                        ? SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.asset(
                              batch.coverAsset!,
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isDark
                                    ? [
                                        AmomimusDarkTheme.backgroundDark,
                                        const Color(
                                          0xff8c72c4,
                                        ).withValues(alpha: 0.4),
                                      ]
                                    : [
                                        Colors.grey[100]!,
                                        const Color(
                                          0xff8c72c4,
                                        ).withValues(alpha: 0.2),
                                      ],
                              ),
                            ),
                            child: Center(
                              child:
                                  batch.stickers.first.imageAsset.contains('/')
                                  ? Image.asset(
                                      batch.stickers.first.imageAsset,
                                      width: 180,
                                      height: 180,
                                      fit: BoxFit.contain,
                                    )
                                  : Icon(
                                      _getIconForAsset(
                                        batch.stickers.first.imageAsset,
                                      ),
                                      size: 140,
                                      color: isDark
                                          ? AmomimusDarkTheme.policeLineYellow
                                          : AmomimusDarkTheme.primaryPurple,
                                    ),
                            ),
                          ),
                    // Interactive Heart Top Right (No circle background, purely icon)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: _HeartButton(batchId: batch.id),
                    ),
                  ],
                ),
              ),
              // Bottom Half: Details and Actions (Clean, Left-Aligned Design)
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Left align the title
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              batch.name,
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
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AmomimusDarkTheme.primaryPurple.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AmomimusDarkTheme.primaryPurple,
                              ),
                            ),
                            child: Text(
                              batch.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AmomimusDarkTheme.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t.stickers_inside(
                          count: batch.stickers.length,
                          tier: batch.stickers.isNotEmpty
                              ? batch.stickers.first.tier
                              : t.premium,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? AmomimusDarkTheme.textSecondary
                              : Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      // Tiers included
                      Row(
                        children: batch.stickers.map((s) => s.tier).toSet().map(
                          (tier) {
                            Color tierColor;
                            switch (tier) {
                              case 'classic':
                                tierColor = Colors.grey;
                                break;
                              case 'common':
                                tierColor = Colors.green;
                                break;
                              case 'rare':
                                tierColor = Colors.blue;
                                break;
                              case 'epic':
                                tierColor = Colors.purple;
                                break;
                              default:
                                tierColor = Colors.grey;
                            }
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: tierColor.withValues(alpha: 0.15),
                                border: Border.all(color: tierColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tier.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? tierColor
                                      : tierColor.withAlpha(220),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const Spacer(),
                      Consumer<AccountManager>(
                        builder: (context, accountManager, child) {
                          final isOwned =
                              accountManager.currentUser?.ownedStickerBatches
                                  .contains(batch.id) ??
                              false;
                          return GestureDetector(
                            onTap: () =>
                                _showPurchaseSheet(context, batch, isDark),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isOwned
                                    ? (isDark
                                          ? const Color(0xFF3A382C)
                                          : const Color(0xFFE8E5F0))
                                    : (isDark
                                          ? AmomimusDarkTheme.backgroundDark
                                          : Colors.grey[100]),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isOwned
                                      ? Colors.transparent
                                      : (isDark
                                            ? AmomimusDarkTheme.policeLineYellow
                                                  .withValues(alpha: 0.5)
                                            : AmomimusDarkTheme.primaryPurple
                                                  .withValues(alpha: 0.5)),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  isOwned ? t.view : t.buy,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isOwned
                                        ? (isDark
                                              ? const Color(0xFF8A8450)
                                              : const Color(0xFF9A8CB8))
                                        : (isDark
                                              ? AmomimusDarkTheme
                                                    .policeLineYellow
                                              : AmomimusDarkTheme
                                                    .primaryPurple),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;
    final currentUser = Provider.of<AccountManager>(context).currentUser;

    return Scaffold(
      backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            t.sticker_shop,
            style: TextStyle(
              color: isDark
                  ? AmomimusDarkTheme.policeLineYellow
                  : AmomimusDarkTheme.primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: isDark
            ? AmomimusDarkTheme.backgroundDark
            : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Moved the coins to the AppBar so it's clean and perfectly aligned
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFFFFD54F)
                      : AmomimusDarkTheme.primaryPurple,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Color(0xFFFFD54F),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${currentUser?.coins ?? 0}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark
                          ? AmomimusDarkTheme.policeLineYellow
                          : AmomimusDarkTheme.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.inventory_2_outlined,
              color: isDark
                  ? AmomimusDarkTheme.policeLineYellow
                  : AmomimusDarkTheme.primaryPurple,
            ),
            tooltip: "My Stickers",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StickerInventoryScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (allMockBatches.length > 1)
                  // The card underneath (index 1)
                  _buildCard(allMockBatches[1], isDark, isFront: false),

                if (allMockBatches.isNotEmpty)
                  // The front card (index 0)
                  _buildCard(allMockBatches[0], isDark, isFront: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Stateless widget for the heart that connects to AccountManager wishlist
class _HeartButton extends StatelessWidget {
  final String batchId;
  const _HeartButton({required this.batchId});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final accountManager = Provider.of<AccountManager>(context);
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;

    // Check if the current user has wishlisted this specific batch ID
    final isTapped =
        accountManager.currentUser?.wishlistStickerBatches.contains(batchId) ??
        false;

    return GestureDetector(
      onTap: () {
        accountManager.toggleWishlistBatch(batchId);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isTapped
              ? Colors.redAccent.withValues(alpha: 0.15)
              : (isDark ? Colors.black54 : Colors.white.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          isTapped ? Icons.favorite : Icons.favorite_border,
          size: 26,
          color: isTapped
              ? Colors.redAccent
              : (isDark ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}

