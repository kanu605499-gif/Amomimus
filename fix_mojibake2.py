import sys

def fix_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()
    
    # Extract the raw bytes by mapping the character's ordinal back to a byte
    # Since it was read as UTF-8 but contains bytes mapped into the Latin-1 block,
    # some characters might be mapped to cp1252.
    # Let's try to map cp1252 chars back to bytes.
    cp1252_to_byte = {
        '\u20AC': 0x80, '\u201A': 0x82, '\u0192': 0x83, '\u201E': 0x84,
        '\u2026': 0x85, '\u2020': 0x86, '\u2021': 0x87, '\u02C6': 0x88,
        '\u2030': 0x89, '\u0160': 0x8A, '\u2039': 0x8B, '\u0152': 0x8C,
        '\u017D': 0x8E, '\u2018': 0x91, '\u2019': 0x92, '\u201C': 0x93,
        '\u201D': 0x94, '\u2022': 0x95, '\u2013': 0x96, '\u2014': 0x97,
        '\u02DC': 0x98, '\u2122': 0x99, '\u0161': 0x9A, '\u203A': 0x9B,
        '\u0153': 0x9C, '\u017E': 0x9E, '\u0178': 0x9F
    }
    
    byte_list = []
    for c in text:
        if c in cp1252_to_byte:
            byte_list.append(cp1252_to_byte[c])
        elif ord(c) < 256:
            byte_list.append(ord(c))
        else:
            # If it's a valid Unicode character that somehow didn't get mojibaked,
            # encode it back as utf-8 bytes
            byte_list.extend(c.encode('utf-8'))
            
    raw_bytes = bytes(byte_list)
    
    try:
        fixed_text = raw_bytes.decode('utf-8')
        with open(path, 'w', encoding='utf-8') as f:
            f.write(fixed_text)
        print("Fixed " + path)
    except Exception as e:
        print("Failed to decode " + path + ": " + str(e))
        # fallback to replace
        fixed_text = raw_bytes.decode('utf-8', errors='replace')
        with open(path, 'w', encoding='utf-8') as f:
            f.write(fixed_text)
        print("Fixed with replacement " + path)

fix_file('lib/i18n/ja.i18n.json')
fix_file('lib/i18n/th.i18n.json')
