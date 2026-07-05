import json
import os

translations = {
    'en': 'Sub-profiles cannot chat with each other.',
    'id': 'Profil anakan tidak bisa saling berkirim pesan.',
    'ja': 'サブプロファイル同士はチャットできません。',
    'th': 'โปรไฟล์ย่อยไม่สามารถแชทกันเองได้',
    'de': 'Unterprofile können nicht miteinander chatten.',
    'tm': 'Sub-profiles cannot chat with each other.'
}

base_dir = r'e:\Kanu Flutter\Amomimus\lib\i18n'

for lang, text in translations.items():
    file_path = os.path.join(base_dir, f'{lang}.i18n.json')
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Inject the key
        data['sub_profile_chat_error'] = text

        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"Updated {lang}.i18n.json")
    else:
        print(f"File not found: {file_path}")
