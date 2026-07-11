import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class SecureSticker extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const SecureSticker({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit,
    this.color,
  });

  @override
  State<SecureSticker> createState() => _SecureStickerState();
}

class _SecureStickerState extends State<SecureSticker> {
  static const List<int> _xorKey = [0x4A, 0x1F, 0x8D, 0x55, 0x9B, 0x3C, 0x7E, 0x2A];
  static final Map<String, Uint8List> _cache = {};
  
  Uint8List? _decryptedBytes;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAndDecrypt();
  }

  @override
  void didUpdateWidget(SecureSticker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _loadAndDecrypt();
    }
  }

  Future<void> _loadAndDecrypt() async {
    if (_cache.containsKey(widget.assetPath)) {
      if (mounted) {
        setState(() {
          _decryptedBytes = _cache[widget.assetPath];
          _hasError = false;
        });
      }
      return;
    }

    try {
      final encPath = '${widget.assetPath}.enc';
      final byteData = await rootBundle.load(encPath);
      final bytes = byteData.buffer.asUint8List();

      final decrypted = Uint8List(bytes.length);
      for (int i = 0; i < bytes.length; i++) {
        decrypted[i] = bytes[i] ^ _xorKey[i % _xorKey.length];
      }
      
      _cache[widget.assetPath] = decrypted;

      if (mounted) {
        setState(() {
          _decryptedBytes = decrypted;
          _hasError = false;
        });
      }
    } catch (e) {
      print('Error loading secure sticker ${widget.assetPath}: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      );
    }

    if (_decryptedBytes == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    return Image.memory(
      _decryptedBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      color: widget.color,
    );
  }
}
