import 'package:flutter/material.dart';

enum DeveloperCardType {
  email,
  instagram,
}

class DeveloperModel {
  final String id;
  final String displayName;
  final String handle;
  final DeveloperCardType type;
  final String url;
  final IconData icon;

  const DeveloperModel({
    required this.id,
    required this.displayName,
    required this.handle,
    required this.type,
    required this.url,
    required this.icon,
  });

  static const List<DeveloperModel> mockDevelopers = [
    DeveloperModel(
      id: 'dev_email',
      displayName: 'Satarnus Diata',
      handle: 'satarnusdiata@gmail.com',
      type: DeveloperCardType.email,
      url: 'mailto:satarnusdiata@gmail.com',
      icon: Icons.email_outlined,
    ),
    DeveloperModel(
      id: 'dev_ig',
      displayName: 'Satarnus Diata',
      handle: '@diatasatarnus',
      type: DeveloperCardType.instagram,
      url: 'https://instagram.com/diatasatarnus',
      icon: Icons.camera_alt_outlined,
    ),
  ];
}
