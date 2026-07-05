import 'dart:io'; 
void main() { 
  var f = File('lib/widgets/chat/chat_home_list_section.dart'); 
  var lines = f.readAsLinesSync(); 
  for (var i=0; i<lines.length; i++) { 
    if (lines[i].contains('\uFFFD')) { 
      print('Line \${i+1}: \${lines[i]}'); 
    } 
  } 
}
