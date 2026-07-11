import 'dart:convert';
import 'dart:io';

void main() {
  final Map<String, Map<String, String>> translations = {
    'en.i18n.json': {
      'function_features_title': 'Function Features',
      'tutorial_1_title': 'How to Chat',
      'tutorial_1_desc': 'Send a Chat Request to the author of a feed post. If accepted, a chat room will open for you to communicate anonymously.',
      'tutorial_2_title': 'How to Reply Comments',
      'tutorial_2_desc': 'Open a feed post to view comments. Tap the reply button on a specific comment to create a structured conversation thread.',
      'tutorial_3_title': 'Redeem & Use Coins',
      'tutorial_3_desc': 'Claim free coins from the Vault menu. Coins can be used to buy premium sticker packs or to bypass the cooldown timer when changing your favorite character or bio.',
      'tutorial_4_title': 'Countdown System',
      'tutorial_4_desc': 'Every chat room has a strict 3-day countdown limit. When time is up, the chat will be permanently deleted. Use the Pin Memories feature to save important messages before the countdown ends!',
      'tutorial_5_title': 'Changing Theme Colors',
      'tutorial_5_desc': 'Your app theme adapts dynamically. To change it, go to Profile > Privacy & Settings > Edit Profile, and change your gender (Amo, Amom, or Ami) to shift the UI colors.',
      'tutorial_6_title': 'Block & Unblock Actions',
      'tutorial_6_desc': 'You can block annoying users from their profile. Blocking completely hides their presence. If you ever unblock them, they receive an "EX-BLOCKED" (Outlaw) status, and any future interactions with them will trigger a visual glitch warning.',
      'tutorial_7_title': 'Ghost & Noise Indicators',
      'tutorial_7_desc': 'When a user behaves suspiciously, their indicator turns into a "Ghost" or "Noise". Ghosts have limited chat requests, while Noise users are completely forbidden from initiating new chats to protect the community.'
    },
    'id.i18n.json': {
      'function_features_title': 'Panduan Fitur',
      'tutorial_1_title': 'Cara Nge-chat',
      'tutorial_1_desc': 'Kirim Chat Request ke pembuat post (author) dari menu Feed. Jika request diterima, ruang obrolan anonim akan terbuka.',
      'tutorial_2_title': 'Balas Komentar',
      'tutorial_2_desc': 'Buka postingan di Feed untuk melihat komentar. Klik tombol balas (reply) pada komentar yang dituju untuk membuat utasan percakapan secara terstruktur.',
      'tutorial_3_title': 'Klaim & Pakai Koin',
      'tutorial_3_desc': 'Ambil koin gratis dari menu Vault. Koin bisa dipakai untuk beli stiker pack premium atau melakukan Bypass (memotong waktu tunggu saat ganti karakter/bio).',
      'tutorial_4_title': 'Sistem Countdown',
      'tutorial_4_desc': 'Setiap room chat memiliki batas waktu 3 hari. Saat waktu habis, chat akan terhapus permanen. Gunakan fitur Pin Memories untuk menyimpan pesan penting sebelum countdown berakhir!',
      'tutorial_5_title': 'Ganti Warna Tema',
      'tutorial_5_desc': 'Tema aplikasi akan menyesuaikan secara dinamis. Untuk mengubahnya, buka Profile > Privacy & Settings > Edit Profile, dan ubah gender kamu (Amo, Amom, atau Ami) untuk mengganti warna UI.',
      'tutorial_6_title': 'Blokir & Buka Blokir',
      'tutorial_6_desc': 'Kamu bisa memblokir user mengganggu lewat profil mereka. Jika kamu membuka blokirnya (unblock), mereka akan mendapat cap "EX-BLOCKED" dan interaksi dengan mereka akan memunculkan efek glitch peringatan.',
      'tutorial_7_title': 'Indikator Ghost & Noise',
      'tutorial_7_desc': 'Saat user bertingkah mencurigakan, indikator mereka berubah jadi Ghost atau Noise. User Ghost dibatasi dalam mengirim chat, sedangkan user Noise sama sekali dilarang memulai chat baru.'
    },
    'de.i18n.json': {
      'function_features_title': 'Funktionen',
      'tutorial_1_title': 'Wie man chattet',
      'tutorial_1_desc': 'Senden Sie eine Chat-Anfrage an den Autor eines Beitrags. Wenn diese akzeptiert wird, öffnet sich ein anonymer Chatraum.',
      'tutorial_2_title': 'Auf Kommentare antworten',
      'tutorial_2_desc': 'Öffnen Sie einen Beitrag, um Kommentare zu sehen. Tippen Sie auf die Schaltfläche "Antworten", um einen strukturierten Gesprächsverlauf zu erstellen.',
      'tutorial_3_title': 'Münzen einlösen & nutzen',
      'tutorial_3_desc': 'Holen Sie sich kostenlose Münzen im Vault-Menü. Münzen können verwendet werden, um Premium-Sticker zu kaufen oder die Wartezeit (Cooldown) beim Ändern von Charakter oder Bio zu überspringen.',
      'tutorial_4_title': 'Countdown-System',
      'tutorial_4_desc': 'Jeder Chatraum hat ein striktes 3-Tage-Limit. Danach wird der Chat endgültig gelöscht. Nutzen Sie die Funktion "Memories anpinnen", um wichtige Nachrichten vor Ablauf der Zeit zu speichern!',
      'tutorial_5_title': 'Themenfarben ändern',
      'tutorial_5_desc': 'Das App-Design passt sich dynamisch an. Gehen Sie zu Profil > Privatsphäre & Einstellungen > Profil bearbeiten und ändern Sie Ihr Geschlecht (Amo, Amom oder Ami), um die UI-Farben zu ändern.',
      'tutorial_6_title': 'Blockieren & Entblocken',
      'tutorial_6_desc': 'Sie können störende Nutzer blockieren. Wenn Sie sie jemals entblocken, erhalten sie den Status "EX-BLOCKED" (Ex-Blockiert), und zukünftige Interaktionen lösen eine visuelle Glitch-Warnung aus.',
      'tutorial_7_title': 'Ghost & Noise Indikatoren',
      'tutorial_7_desc': 'Wenn sich ein Nutzer auffällig verhält, ändert sich sein Indikator zu Ghost (Geist) oder Noise (Lärm). Ghosts haben begrenzte Chat-Anfragen, während Noise-Nutzer zum Schutz der Community keine neuen Chats starten dürfen.'
    },
    'ja.i18n.json': {
      'function_features_title': '機能の紹介',
      'tutorial_1_title': 'チャットの方法',
      'tutorial_1_desc': 'フィードの投稿者にチャットリクエストを送信します。承認されると、匿名で会話できるチャットルームが開きます。',
      'tutorial_2_title': 'コメントへの返信',
      'tutorial_2_desc': '投稿を開いてコメントを表示し、返信ボタンをタップすると、スレッド形式で会話を続けることができます。',
      'tutorial_3_title': 'コインの獲得と使用',
      'tutorial_3_desc': 'Vaultメニューから無料コインを獲得できます。コインを使ってプレミアムステッカーを購入したり、プロフィールの変更待機時間（クールダウン）をスキップしたりできます。',
      'tutorial_4_title': 'カウントダウンシステム',
      'tutorial_4_desc': '各チャットルームには3日間の期限があります。期限が切れるとチャットは永久に削除されます。期限前に「Memories」機能を使って重要なメッセージを保存してください！',
      'tutorial_5_title': 'テーマカラーの変更',
      'tutorial_5_desc': 'アプリのテーマは動的に変化します。プロフィール > プライバシーと設定 > プロフィール編集で性別（Amo、Amom、Ami）を変更すると、UIの色が変わります。',
      'tutorial_6_title': 'ブロックと解除',
      'tutorial_6_desc': '迷惑なユーザーをブロックできます。ブロックを解除すると、そのユーザーは「EX-BLOCKED」（ブロック解除済み）状態になり、今後のやり取りでグリッチ（バグのような視覚的警告）が発生します。',
      'tutorial_7_title': 'Ghost（ゴースト）とNoise（ノイズ）',
      'tutorial_7_desc': '怪しい行動をするユーザーは、インジケーターがGhostまたはNoiseに変わります。Ghostはチャットリクエストが制限され、Noiseのユーザーはコミュニティ保護のため新規チャットを一切開始できません。'
    },
    'th.i18n.json': {
      'function_features_title': 'คู่มือการใช้งาน',
      'tutorial_1_title': 'วิธีแชท',
      'tutorial_1_desc': 'ส่งคำขอแชทถึงผู้เขียนโพสต์ในฟีด หากได้รับการยอมรับ ห้องแชทที่ไม่ระบุตัวตนจะเปิดขึ้น',
      'tutorial_2_title': 'วิธีตอบกลับความคิดเห็น',
      'tutorial_2_desc': 'เปิดโพสต์ในฟีดเพื่อดูความคิดเห็น แตะปุ่มตอบกลับที่ความคิดเห็นเพื่อสร้างเธรดการสนทนา',
      'tutorial_3_title': 'รับและใช้เหรียญ',
      'tutorial_3_desc': 'รับเหรียญฟรีจากเมนู Vault เหรียญสามารถใช้ซื้อสติกเกอร์พรีเมียมหรือใช้ข้ามเวลารอ (Bypass) เมื่อเปลี่ยนตัวละครโปรดหรือประวัติได้',
      'tutorial_4_title': 'ระบบนับถอยหลัง (Countdown)',
      'tutorial_4_desc': 'ห้องแชททุกห้องมีการนับถอยหลัง 3 วัน เมื่อหมดเวลา แชทจะถูกลบอย่างถาวร อย่าลืมใช้ฟีเจอร์ ปักหมุดความทรงจำ เพื่อบันทึกข้อความสำคัญก่อนหมดเวลา!',
      'tutorial_5_title': 'การเปลี่ยนสีธีม',
      'tutorial_5_desc': 'ธีมแอปจะปรับเปลี่ยนแบบไดนามิก ไปที่ โปรไฟล์ > ความเป็นส่วนตัวและการตั้งค่า > แก้ไขโปรไฟล์ แล้วเปลี่ยนเพศของคุณ (Amo, Amom หรือ Ami) เพื่อเปลี่ยนสีของแอป',
      'tutorial_6_title': 'การบล็อกและปลดบล็อก',
      'tutorial_6_desc': 'คุณสามารถบล็อกผู้ใช้ที่น่ารำคาญได้ หากคุณปลดบล็อกพวกเขาในภายหลัง พวกเขาจะได้รับสถานะ "EX-BLOCKED" (เคยบล็อก) และการโต้ตอบกับพวกเขาในอนาคตจะทำให้เกิดเอฟเฟกต์ภาพแตก (Glitch) เพื่อเป็นการเตือน',
      'tutorial_7_title': 'สถานะ Ghost และ Noise',
      'tutorial_7_desc': 'เมื่อผู้ใช้มีพฤติกรรมน่าสงสัย สถานะจะเปลี่ยนเป็น Ghost หรือ Noise โดย Ghost จะถูกจำกัดการส่งคำขอแชท ในขณะที่ Noise จะไม่สามารถเริ่มแชทใหม่ได้เลยเพื่อปกป้องชุมชน'
    },
    '[tamriel].i18n.json': {
      'function_features_title': 'Rituals of Power',
      'tutorial_1_title': 'Summoning a Parley',
      'tutorial_1_desc': 'Dispatch a Courier to the scribe of a Thu\'um. If they accept, a rift will open for you to converse in the shadows.',
      'tutorial_2_title': 'Retorting to Rot',
      'tutorial_2_desc': 'Gaze upon a Thu\'um to behold the Rot (comments). Tap the retort rune on a specific rot to weave a structured tapestry of voices.',
      'tutorial_3_title': 'Faraan Exchange',
      'tutorial_3_desc': 'Claim your free Faraan (coins) from the Strongbox. Faraan can be bartered for enchanted Runes or used to bypass the Sands of Time when altering your Su\'um (bio).',
      'tutorial_4_title': 'The Shattering Hourglass',
      'tutorial_4_desc': 'Every rift is bound by a strict 3-day hourglass. When the sands run out, the rift is cleansed forever. Bind your Rot to Vahrukiv (Memories) before Oblivion takes them!',
      'tutorial_5_title': 'Shifting the Illusion',
      'tutorial_5_desc': 'The realm adapts its hues to your soul. To cast a new illusion, journey to Visage > Shadow Rites > Alter Visage, and change your mortal vessel (Amo, Amom, or Ami) to shift the colors of Mundus.',
      'tutorial_6_title': 'Dungeon \u0026 Pardon',
      'tutorial_6_desc': 'You may cast annoying bards into the Dungeon. If you ever grant them a Pardon, they bear the mark of the OUTLAW. Any future encounters with them will trigger a chaotic illusion glitch, warning you of their foul presence.',
      'tutorial_7_title': 'Omens of the Wretched',
      'tutorial_7_desc': 'When a soul dabbles in dark arts, their aura shifts to Skooma Drinker (Ghost) or Bandit (Noise). Ghosts have meager magicka for Couriers, while Bandits are entirely stripped of their power to initiate parleys.'
    }
  };

  for (final langFile in translations.keys) {
    final file = File('lib/i18n/$langFile');
    if (!file.existsSync()) continue;
    
    final content = file.readAsStringSync();
    final jsonContent = json.decode(content) as Map<String, dynamic>;
    
    jsonContent.addAll(translations[langFile]!);
    
    // Save pretty formatted without mojibake (ensure utf8)
    const encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(encoder.convert(jsonContent));
    print('Updated $langFile');
  }
}
