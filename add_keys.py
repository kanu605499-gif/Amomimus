import json
import glob
import os

keys = {
    "en": "Whoops! It seems our server is being a bit shy to your phone right now. Don't worry, your message is saved securely and we'll deliver it ASAP when our server synchronized!",
    "id": "Waduh! Sepertinya server kita lagi malu-malu nih sama HP kamu. Jangan khawatir, pesanmu udah aman tersimpan dan bakal langsung dikirim pas server kita tersinkronisasi!",
    "ja": "おっと！今、私たちのサーバーがあなたのスマホに対して少し照れているようです。ご心配なく。メッセージは安全に保存されており、サーバーが同期され次第、すぐにお届けします！",
    "de": "Hoppla! Es scheint, dass unser Server im Moment ein wenig schüchtern gegenüber Ihrem Telefon ist. Keine Sorge, Ihre Nachricht ist sicher gespeichert und wir werden sie so schnell wie möglich zustellen, wenn unser Server synchronisiert ist!",
    "oe": "Hoppla! Es scheint, dass unser Server im Moment ein wenig schüchtern gegenüber Ihrem Telefon ist. Keine Sorge, Ihre Nachricht ist sicher gespeichert und wir werden sie so schnell wie möglich zustellen, wenn unser Server synchronisiert ist!", # Same as DE for oe
    "th": "อุ๊ย! ดูเหมือนเซิร์ฟเวอร์ของเราจะเขินโทรศัพท์ของคุณนิดหน่อย ไม่ต้องกังวล ข้อความของคุณถูกบันทึกไว้อย่างปลอดภัยแล้ว และเราจะส่งให้เร็วที่สุดเมื่อเซิร์ฟเวอร์ซิงโครไนซ์แล้ว!",
    "tm": "Whoops! It seems our server is being a bit shy to your phone right now. Don't worry, your message is saved securely and we'll deliver it ASAP when our server synchronized!" # default
}

i18n_dir = r"E:\Kanu Flutter\Amomimus\lib\i18n"
for filepath in glob.glob(os.path.join(i18n_dir, "*.json")):
    if "i18n.json" in filepath and not filepath.endswith("$target.i18n.json"):
        lang = os.path.basename(filepath).split(".")[0]
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        data["delayed_sync_msg"] = keys.get(lang, keys["en"])
        data["delayed_sync_title"] = "Delayed Sync" if lang != "id" else "Sinkronisasi Tertunda"
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

print("Translations updated successfully.")
