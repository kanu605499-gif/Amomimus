import os

def unconst_shape():
    lib_dir = "lib"
    modified_files = []

    for root, dirs, files in os.walk(lib_dir):
        for file in files:
            if not file.endswith(".dart"): continue
            
            filepath = os.path.join(root, file)
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
                
            old_shape = "shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))"
            new_shape = "shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))"
            
            if old_shape in content:
                new_content = content.replace(old_shape, new_shape)
                
                if new_content != content:
                    with open(filepath, "w", encoding="utf-8") as f:
                        f.write(new_content)
                    modified_files.append(filepath)
                    
    print(f"Modified {len(modified_files)} files.")

if __name__ == "__main__":
    unconst_shape()
