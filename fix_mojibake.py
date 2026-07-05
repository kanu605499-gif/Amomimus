import codecs

def fix_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()
    try:
        # Some characters might have been lost or changed, so we use 'backslashreplace' or ignore if strictly needed
        # But 'strict' is better to ensure it's exact
        original_bytes = text.encode('windows-1252')
        fixed_text = original_bytes.decode('utf-8')
        with open(path, 'w', encoding='utf-8') as f:
            f.write(fixed_text)
        print("Fixed " + path)
    except Exception as e:
        print("Failed " + path + ": " + str(e))
        
fix_file('lib/i18n/ja.i18n.json')
fix_file('lib/i18n/th.i18n.json')
