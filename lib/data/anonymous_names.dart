import 'dart:math';
import 'package:flutter/material.dart';

/// Pool of anonymous name lists used throughout the Amomimus app.
///
/// Centralizes all hardcoded name data that was previously scattered
/// inside [FeedModel] and other locations.
class AnonymousNames {
  AnonymousNames._(); // prevent instantiation

  static final List<String> amoNames = [
    "Silent Phantom",
    "Void Drifter",
    "Night Ember",
    "Shadow Pulse",
    "Dark Mirage",
    "Ash Reverie",
    "Obsidian Ghost",
    "Lunar Veil",
    "Crimson Haunt",
    "Neon Specter",
    "Astral Echo",
    "Midnight Strider",
    "Phantom Shade",
    "Echo Wraith",
    "Abyssal Walker",
    "Hollow Whisper",
    "Ethereal Mask",
    "Dusky Nomad",
    "Celestial Vagabond",
    "Gloom Wanderer",
    "Cosmic Ripple",
    "Silent Solstice",
    "Onyx Illusion",
    "Somber Wraith",
    "Eclipse Seeker",
    "Raven Shadow",
    "Nebular Drift",
    "Twilight Enigma",
    "Ghostly Cipher",
    "Spectral Aura",
  ];

  static final List<String> amiNames = [
    "Crystal Mist",
    "Twilight Bloom",
    "Velvet Shadow",
    "Ivory Whisper",
    "Sapphire Dream",
    "Silver Lining",
    "Moonlit Rose",
    "Pearl Cascade",
    "Aurora Shade",
    "Lilac Phantom",
    "Dawn Blossom",
    "Roseate Veil",
    "Gossamer Dew",
    "Luminous Petal",
    "Ruby Whisper",
    "Celestial Swan",
    "Emerald Breeze",
    "Radiant Aura",
    "Starlit Lily",
    "Velvet Halo",
    "Iris Glimmer",
    "Silken Mirage",
    "Opal Reverie",
    "Amber Tear",
    "Lotus Whisper",
    "Fae Glimpse",
    "Coral Echo",
    "Whisper Willow",
    "Amethyst Dawn",
    "Snowy Feathers",
  ];

  static final List<String> amomNames = [
    "Golden Cipher",
    "Iron Whisper",
    "Bronze Nomad",
    "Titan Shade",
    "Copper Drift",
    "Steel Mirage",
    "Amber Ghost",
    "Platinum Veil",
    "Cobalt Echo",
    "Rustic Phantom",
    "Chrome Strider",
    "Onyx Vanguard",
    "Granite Sentinel",
    "Brass Horizon",
    "Obsidian Core",
    "Meteor Strike",
    "Tungsten Will",
    "Forge Wanderer",
    "Flint Echo",
    "Carbon Phantom",
    "Basalt Drifter",
    "Titanium Edge",
    "Lead Shadow",
    "Mercury Flash",
    "Zinc Illusion",
    "Ironclad Myth",
    "Rust Vagabond",
    "Vulcan Spirit",
    "Aegis Wraith",
    "Nickel Glimmer",
  ];

  /// Returns a random anonymous name from the pool matching the given [gender].
  static String getRandomName(String gender) {
    final random = Random();
    switch (gender) {
      case 'Ami':
        return amiNames[random.nextInt(amiNames.length)];
      case 'Amom':
        return amomNames[random.nextInt(amomNames.length)];
      case 'Amo':
      default:
        return amoNames[random.nextInt(amoNames.length)];
    }
  }

  static const List<IconData> _icons = [
    Icons.diamond,
    Icons.android,
    Icons.water,
    Icons.star,
    Icons.person_outline,
    Icons.favorite,
    Icons.brightness_high,
    Icons.local_fire_department,
    Icons.auto_awesome,
  ];

  static const List<int> _colors = [
    0xFF6C52A3, // Primary Purple
    0xFFFFD54F, // Police Line Yellow
    0xFF9E8EB9, // Amomimus Grey (from border color)
    0xFFB388FF, // Lighter Purple (Noise indicator color)
    0xFFFBC02D, // Slightly darker Yellow
    0xFFBDBDBD, // Standard Grey
  ];

  /// Generates a consistent random name for a specific user on a specific post
  static String getConsistentNameForPost(String userId, String postId) {
    final seed = (userId + postId).hashCode;
    final random = Random(seed);
    final allNames = [...amoNames, ...amiNames, ...amomNames];
    return allNames[random.nextInt(allNames.length)];
  }

  /// Generates a consistent icon for a specific user on a specific post
  static IconData getConsistentIconForPost(String userId, String postId) {
    final seed = (userId + postId).hashCode;
    final random = Random(seed);
    return _icons[random.nextInt(_icons.length)];
  }

  /// Generates a consistent color for a specific user on a specific post
  static int getConsistentColorForPost(String userId, String postId) {
    final seed = (userId + postId).hashCode;
    final random = Random(seed);
    return _colors[random.nextInt(_colors.length)];
  }
}
