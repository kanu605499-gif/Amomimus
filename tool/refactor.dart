import 'dart:io';

void main() {
  final file = File('lib/services/account_manager.dart');
  String content = file.readAsStringSync();

  final helperMethod = '''
  Future<void> _persistAndNotify(UserAccount updatedUser) async {
    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: \$e ====");
    }

    if (_currentUser?.id == updatedUser.id) {
      _currentUser = updatedUser;
    }

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();
  }
''';

  if (!content.contains('_persistAndNotify')) {
    content = content.replaceFirst(
      'class AccountManager extends ChangeNotifier {',
      'class AccountManager extends ChangeNotifier {\n\$helperMethod'
    );
  }

  // Replace standard block
  final standardBlock = '''
    try {
      await DatabaseHelper.instance.updateUser(updatedUser);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: \$e ====");
    }

    _currentUser = updatedUser;

    final index = _accounts.indexWhere((acc) => acc.id == updatedUser.id);
    if (index != -1) {
      _accounts[index] = updatedUser;
    }

    notifyListeners();''';

  content = content.replaceAll(standardBlock, '    await _persistAndNotify(updatedUser);');

  // Replace block in updatePresenceStatus
  final presenceBlock = '''
    // Persist to local database
    try {
      await DatabaseHelper.instance.updateUser(_currentUser!);
    } catch (e) {
      print("==== DB UPDATE SKIPPED: \$e ====");
    }
    
    notifyListeners();''';
  
  final presenceReplacement = '''
    // Persist to local database
    await _persistAndNotify(_currentUser!);''';
    
  content = content.replaceAll(presenceBlock, presenceReplacement);

  // Replace block in blockUser (target)
  final targetBlock1 = '''
      try {
        await DatabaseHelper.instance.updateUser(updatedTarget);
      } catch (e) {
        print("==== DB UPDATE TARGET SKIPPED: \$e ====");
      }
      final targetIdx = _accounts.indexWhere((acc) => acc.id == updatedTarget.id);
      if (targetIdx != -1) _accounts[targetIdx] = updatedTarget;''';
      
  final targetRepl1 = '''
      await _persistAndNotify(updatedTarget);''';
      
  content = content.replaceAll(targetBlock1, targetRepl1);

  // Replace block in submitReport (reporter)
  final reporterBlock = '''
      try {
        await DatabaseHelper.instance.updateUser(newReporter);
      } catch (e) {
        print("==== DB UPDATE SKIPPED: \\\$e ====");
      }

      final reporterIndex = _accounts.indexWhere(
        (acc) => acc.id == newReporter.id,
      );
      if (reporterIndex != -1) {
        _accounts[reporterIndex] = newReporter;
      }''';
      
  final reporterRepl = '''
      await _persistAndNotify(newReporter);''';
      
  content = content.replaceAll(reporterBlock, reporterRepl);

  file.writeAsStringSync(content);
  print('Refactor complete.');
}
