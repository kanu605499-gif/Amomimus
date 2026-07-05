import os

def strip_const_edgeinsets():
    lib_dir = "lib"
    modified_files = []

    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if not file.endswith(".dart"): continue
            
            filepath = os.path.join(root, file)
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
                
            old_str = "margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24)"
            new_str = "margin: EdgeInsets.only(bottom: 100.0, left: 24.0, right: 24.0)"
            
            if old_str in content:
                new_content = content.replace(old_str, new_str)
                
                if new_content != content:
                    with open(filepath, "w", encoding="utf-8") as f:
                        f.write(new_content)
                    modified_files.append(filepath)
                    
    print(f"Modified {len(modified_files)} files.")

if __name__ == "__main__":
    strip_const_edgeinsets()
