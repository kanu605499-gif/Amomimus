import re

filepath = r"e:\Kanu Flutter\project_flutter_b6\lib\widgets\feed\left_drawer_menu.dart"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()
replacement = r"""\1backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            color: isDark ? AmomimusDarkTheme.backgroundDark.withValues(alpha: 0.65) : Colors.white.withValues(alpha: 0.65),\2"""
# 1. Add dart:ui import
if 'dart:ui' not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'dart:ui';")

# 2. Remove LanguageManager
content = re.sub(r"import 'package:amomimus/language/language_manager\.dart';\n", "", content)
content = re.sub(r"\s*final LanguageManager lang;", "", content)
content = re.sub(r"\s*required this\.lang,", "", content)
content = content.replace("lang.getString('exit')", "t.exit") # Assuming 'exit' exists in slang

# 3. Add glass effect to left drawer properly
# Find the start of the Drawer
drawer_start_pattern = r"(return Drawer\(\s*width: MediaQuery\.of\(context\)\.size\.width \* 0\.7,\s*)backgroundColor: isDark \? AmomimusDarkTheme\.backgroundDark : Colors\.white,(\s*child: Column\(\s*children: \[)"



if re.search(drawer_start_pattern, content):
    content = re.sub(drawer_start_pattern, replacement, content)
    # We also need to add the closing tags at the very end.
    # Replace the last `    );\n  }\n}` with `            ],\n          ),\n        ),\n      ),\n    );\n  }\n}`
    # Wait, the end is:
    #           const SizedBox(height: 20),
    #         ],
    #       ),
    #     );
    #   }
    # }
    
    end_pattern = r"(\s*const SizedBox\(height: 20\),\s*\]\s*,\s*\)\s*,\s*\)\s*;\s*\}\s*\})"
    
    # We want to replace the `], ), );` with `], ), ), ), );`
    # Let's just do a manual string replace at the end:
    content = re.sub(r"(\s*const SizedBox\(height: 20\),\s*\]\s*,\s*\)\s*,\s*\)\s*;\s*\}\s*\})", r"\n          const SizedBox(height: 20),\n        ],\n      ),\n      ),\n      ),\n      ),\n    );\n  }\n}", content)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
