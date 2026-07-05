import os

def remove_shape():
    lib_dir = "lib"
    modified_files = []

    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if not file.endswith(".dart"): continue
            
            filepath = os.path.join(root, file)
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
                
            old_str1 = "shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)), "
            old_str2 = "shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), "
            
            new_content = content.replace(old_str1, "").replace(old_str2, "")
            
            if new_content != content:
                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(new_content)
                modified_files.append(filepath)
                    
    print(f"Modified {len(modified_files)} files.")

if __name__ == "__main__":
    remove_shape()
