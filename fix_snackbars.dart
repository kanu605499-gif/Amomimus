import 'dart:io'; 

void main() { 
  var d = Directory('lib'); 
  for (var f in d.listSync(recursive: true)) { 
    if (f is File && f.path.endsWith('.dart')) { 
      var c = f.readAsStringSync(); 
      bool changed = false;
      
      if (c.contains('showSnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),')) { 
        c = c.replaceAll('showSnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),', 'showSnackBar('); 
        changed = true;
      }
      
      if (c.contains('showSnackBar(behavior: SnackBarBehavior.floating, margin: EdgeInsets.only(bottom: 100.0, left: 24.0, right: 24.0),')) {
        c = c.replaceAll('showSnackBar(behavior: SnackBarBehavior.floating, margin: EdgeInsets.only(bottom: 100.0, left: 24.0, right: 24.0),', 'showSnackBar('); 
        changed = true;
      }
      
      if (changed) {
        f.writeAsStringSync(c); 
      }
    } 
  } 
}
