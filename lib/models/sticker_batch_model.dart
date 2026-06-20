import 'sticker_model.dart';

/// Represents a bundle/batch of stickers that users can purchase together.
class StickerBatchModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final List<StickerModel> stickers;
  final int resonatedCount;
  final int timesBought;
  final String? createdAt;
  final String? coverAsset;

  StickerBatchModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stickers,
    this.coverAsset,
    this.resonatedCount = 0,
    this.timesBought = 0,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stickers': stickers.map((s) => s.toMap()).toList(),
      'coverAsset': coverAsset,
      'resonatedCount': resonatedCount,
      'timesBought': timesBought,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory StickerBatchModel.fromMap(Map<String, dynamic> map) {
    return StickerBatchModel(
      id: map['id'],
      name: map['name'],
      category: map['category'] ?? 'general',
      price: map['price'] ?? 100,
      stickers:
          (map['stickers'] as List<dynamic>?)
              ?.map((s) => StickerModel.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
      coverAsset: map['coverAsset'],
      resonatedCount: map['resonatedCount'] ?? 0,
      timesBought: map['timesBought'] ?? 0,
      createdAt: map['createdAt'],
    );
  }

  // Global static list of mock batches for the app
  static final List<StickerBatchModel> mockBatches = [
    StickerBatchModel(
      id: 'b1',
      name: 'Tarot Moods Vol. 1',
      category: 'MOOD',
      price: 300,
      coverAsset: 'assets/stickers/batch1_cover.jpg',
      resonatedCount: 1500,
      timesBought: 500,
      createdAt: '2026-06-10T00:00:00Z',
      stickers: [
        StickerModel(
          id: 's1',
          name: 'Temperance',
          imageAsset: 'assets/stickers/temperance.png',
          tier: 'epic',
        ),
        StickerModel(
          id: 's4',
          name: 'Hermit',
          imageAsset: 'assets/stickers/hermit.png',
          tier: 'epic',
        ),
        StickerModel(
          id: 's10',
          name: 'Chariot',
          imageAsset: 'assets/stickers/chariot.png',
          tier: 'epic',
        ),
      ],
    ),
    StickerBatchModel(
      id: 'b2',
      name: 'Tarot Moods Vol. 2',
      category: 'MOOD',
      price: 600,
      coverAsset: 'assets/stickers/batch2_cover.jpg',
      resonatedCount: 5000,
      timesBought: 1200,
      createdAt: '2026-06-05T00:00:00Z',
      stickers: [
        StickerModel(
          id: 's2',
          name: 'The Fool',
          imageAsset: 'assets/stickers/fool.png',
          tier: 'epic',
        ),
        StickerModel(
          id: 's8',
          name: 'The Tower',
          imageAsset: 'assets/stickers/tower.png',
          tier: 'epic',
        ),
        StickerModel(
          id: 's12',
          name: 'Death',
          imageAsset: 'assets/stickers/death.png',
          tier: 'epic',
        ),
      ],
    ),
  ];
}
