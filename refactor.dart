import 'dart:io';

void main() {
  final file = File('lib/services/account_manager.dart');
  String content = file.readAsStringSync();
  List<String> lines = content.split('\n');
  List<String> newLines = [];
  
  bool skipMode = false;
  
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    if (line.contains('try {') && 
        i + 1 < lines.length && 
        lines[i+1].contains('await DatabaseHelper.instance.updateUser(updatedUser);')) {
        
        skipMode = true;
        newLines.add('    await _persistAndNotify(updatedUser);');
        continue;
    }
    
    if (skipMode) {
      if (line.contains('notifyListeners();')) {
        skipMode = false;
      }
      continue;
    }
    
    newLines.add(line);
  }
  
  String newContent = newLines.join('\n');
  if (content != newContent) {
    file.writeAsStringSync(newContent);
    print('Refactoring successful!');
  } else {
    print('No changes made.');
  }
}
