import 'dart:io';

const List<int> _xorKey = [0x4A, 0x1F, 0x8D, 0x55, 0x9B, 0x3C, 0x7E, 0x2A];

void main() async {
  final rawDir = Directory('assets/stickers_raw');
  final encDir = Directory('assets/stickers');

  if (!rawDir.existsSync()) {
    print('Error: assets/stickers_raw does not exist.');
    return;
  }

  if (!encDir.existsSync()) {
    encDir.createSync(recursive: true);
  }

  final files = rawDir.listSync().whereType<File>();
  int count = 0;

  for (final file in files) {
    if (file.path.endsWith('.png') || file.path.endsWith('.jpg')) {
      final bytes = file.readAsBytesSync();
      final encryptedBytes = <int>[];

      for (int i = 0; i < bytes.length; i++) {
        encryptedBytes.add(bytes[i] ^ _xorKey[i % _xorKey.length]);
      }

      final fileName = file.uri.pathSegments.last;
      final encFile = File('${encDir.path}/$fileName.enc');
      encFile.writeAsBytesSync(encryptedBytes);
      print('Encrypted $fileName -> ${fileName}.enc');
      count++;
    }
  }

  print('Successfully encrypted $count stickers.');
}
