import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../amomimusdark.dart';
import '../models/sticker_batch_model.dart';
import '../services/account_manager.dart';
import '../models/effects/plastic_box_effect_model.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../widgets/secure_sticker.dart';

class StickerInventoryScreen extends StatelessWidget {
  const StickerInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;
    final currentUser = Provider.of<AccountManager>(context).currentUser;

    // Get the owned batches from the current user
    final ownedIds = currentUser?.ownedStickerBatches ?? [];
    final ownedBatches = StickerBatchModel.mockBatches
        .where((batch) => ownedIds.contains(batch.id))
        .toList();

    return Scaffold(
      backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
      appBar: AppBar(
        title: Text(
          Translations.of(context).my_sticker_stash,
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
        automaticallyImplyLeading: false,
      ),
      body: ownedBatches.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Translations.of(context).stash_empty,
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
                      Translations.of(context).visit_sticker_shop,
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
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: ownedBatches.length,
              itemBuilder: (context, index) {
                final batch = ownedBatches[index];
                return GestureDetector(
                  onTap: () => _openPack(context, batch, isDark),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AmomimusDarkTheme.surfaceDark
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 5,
                            child: batch.coverAsset != null
                                ? SecureSticker(
                                    assetPath: batch.coverAsset!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                    child: const Icon(Icons.style),
                                  ),
                          ),
                          Expanded(
                            flex: 2,
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
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _openPack(BuildContext context, StickerBatchModel batch, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final t = Translations.of(context);
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
              const SizedBox(height: 8),
              Text(
                t.own_these_stickers,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AmomimusDarkTheme.textSecondary
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.65, // Taller like a poker card
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: batch.stickers.length,
                itemBuilder: (context, index) {
                  final sticker = batch.stickers[index];
                  return PlasticBoxEffect(
                    borderRadius: 12.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E28) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AmomimusDarkTheme.policeLineYellow
                              : AmomimusDarkTheme.primaryPurple,
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.5 : 0.1,
                            ),
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark
                                  ? AmomimusDarkTheme.policeLineYellow
                                        .withValues(alpha: 0.4)
                                  : AmomimusDarkTheme.primaryPurple.withValues(
                                      alpha: 0.4,
                                    ),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Top small suit/icon (Poker style)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 6.0,
                                    top: 4.0,
                                  ),
                                  child: Icon(
                                    Icons.star_border,
                                    size: 14,
                                    color: isDark
                                        ? AmomimusDarkTheme.policeLineYellow
                                        : AmomimusDarkTheme.primaryPurple,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child: sticker.imageAsset.contains('/')
                                      ? SecureSticker(
                                          assetPath: sticker.imageAsset,
                                          fit: BoxFit.contain,
                                        )
                                      : Icon(
                                          Icons.star,
                                          size: 40,
                                          color: isDark
                                              ? AmomimusDarkTheme
                                                    .policeLineYellow
                                              : AmomimusDarkTheme.primaryPurple,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  left: 4,
                                  right: 4,
                                ),
                                child: Text(
                                  sticker.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: isDark
                                        ? AmomimusDarkTheme.policeLineYellow
                                        : AmomimusDarkTheme.primaryPurple,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
