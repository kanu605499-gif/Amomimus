import os
import re

def fix_snackbars():
    lib_dir = "lib"
    modified_files = []

    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if not file.endswith(".dart"): continue
            
            filepath = os.path.join(root, file)
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
                
            if "SnackBar(" in content:
                if "margin: const EdgeInsets.only(bottom: 100" in content:
                    continue
                
                # Use word boundary \b to ONLY match exact word SnackBar, avoiding hideCurrentSnackBar and showSnackBar
                new_content = re.sub(r'\bSnackBar\s*\(', r'SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))), ', content)
                
                if new_content != content:
                    with open(filepath, "w", encoding="utf-8") as f:
                        f.write(new_content)
                    modified_files.append(filepath)
                    
    print(f"Modified {len(modified_files)} files.")

if __name__ == "__main__":
    fix_snackbars()
