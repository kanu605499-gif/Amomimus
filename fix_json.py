import json
import os

langs = ['de', 'ja', 'th', 'tm']
for lang in langs:
    filepath = f"lib/i18n/{lang}.i18n.json"
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # update bio_bailout_confirm
        if 'bio_bailout_confirm' in data:
            if '${duration}' not in data['bio_bailout_confirm']:
                data['bio_bailout_confirm'] = '${duration} - ' + data['bio_bailout_confirm']
        
        # add bio_first_time_confirm
        if 'bio_first_time_confirm' not in data:
            data['bio_first_time_confirm'] = '${duration} - Please confirm your bio.'
            
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, separators=(',', ':'))
