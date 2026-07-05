import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../amomimusdark.dart';
import '../models/sticker_batch_model.dart';
import '../services/account_manager.dart';
import '../models/effects/plastic_box_effect_model.dart';
import 'package:amomimus/i18n/strings.g.dart';

class FavoritedStickersScreen extends StatelessWidget {
  const FavoritedStickersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;
    final accountManager = Provider.of<AccountManager>(context);
    final currentUser = accountManager.currentUser;
    final t = Translations.of(context);

    // Get the wishlisted batches from the current user
    final wishlistedIds = currentUser?.wishlistStickerBatches ?? [];
    final favoritedBatches = StickerBatchModel.mockBatches
        .where((batch) => wishlistedIds.contains(batch.id))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
      appBar: AppBar(
        title: Text(
          (t as dynamic).my_favorited_stickers ?? "My Favorited Stickers",
          style: TextStyle(
            color: isDark
                ? AmomimusDarkTheme.policeLineYellow
                : AmomimusDarkTheme.primaryPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark
            ? AmomimusDarkTheme.backgroundDark
            : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // NO arrows!
      ),
      body: favoritedBatches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    (t as dynamic).no_favorited_stickers ?? "No favorited stickers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      t.visit_sticker_shop,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.grey[700] : Colors.grey[500],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, // Slightly taller for the buttons
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favoritedBatches.length,
              itemBuilder: (context, index) {
                final batch = favoritedBatches[index];
                return GestureDetector(
                  onTap: () => _showPurchaseSheet(context, batch, isDark),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AmomimusDarkTheme.surfaceDark
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: isDark
                            ? AmomimusDarkTheme.primaryPurple.withValues(
                                alpha: 0.5,
                              )
                            : Colors.grey[300]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.05,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 5,
                                child: batch.coverAsset != null
                                    ? Image.asset(
                                        batch.coverAsset!,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.bottomCenter,
                                      )
                                    : Container(
                                        color: isDark
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                        child: const Icon(Icons.style),
                                      ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: isDark
                                      ? AmomimusDarkTheme.surfaceDark
                                      : Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        batch.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isDark
                                              ? AmomimusDarkTheme.policeLineYellow
                                              : const Color(0xFF8C72C4),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${batch.stickers.length} ${Translations.of(context).stickers}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Heart button overlay
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                accountManager.toggleWishlistBatch(batch.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark ? Colors.black54 : Colors.white.withValues(alpha: 0.8),
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  size: 20,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIconForAsset(String asset) {
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
    final t = Translations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          bottom: true,
          child: Padding(
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
                            borderRadius: BorderRadius.circular(16.0),
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
                            SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
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
}
