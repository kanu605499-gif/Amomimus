import sys
import re

file_path = r"e:\Kanu Flutter\project_flutter_b6\lib\language\strings.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

en_add = """      'doc_title': 'App Documentation',
      'doc_category_legal': 'Legal & Privacy Policy',
      'doc_rule_1_title': '1. Data Collection',
      'doc_rule_1_desc': 'We collect minimal data necessary for core features. Your anonymous identifier is not linked to your personal identity.',
      'doc_rule_2_title': '2. End-to-End Encryption',
      'doc_rule_2_desc': 'All chat messages are end-to-end encrypted. We cannot read your private messages.',
      'doc_rule_3_title': '3. Session Data',
      'doc_rule_3_desc': 'Local session data is stored securely on your device. Clearing your app data will permanently erase your local history.',
      'doc_rule_4_title': '4. Third-Party Services',
      'doc_rule_4_desc': 'We do not sell or share your data with third parties. Any external integrations are strictly for operational purposes.',
      'doc_rule_5_title': '5. User Content Liability',
      'doc_rule_5_desc': 'You are solely responsible for the content you post. Amomimus is not liable for user-generated content.',
      'doc_rule_6_title': '6. Anonymity Guarantee',
      'doc_rule_6_desc': 'Your public interactions remain anonymous unless you explicitly choose to reveal your identity via a chat request.',
      'doc_rule_7_title': '7. Account Deletion',
      'doc_rule_7_desc': 'You have the right to delete your account at any time. This action is irreversible and wipes all associated records.',
      'doc_rule_8_title': '8. Harassment & Abuse',
      'doc_rule_8_desc': 'We maintain a strict zero-tolerance policy against harassment. Violators will be permanently banned.',
      'doc_rule_9_title': '9. Intellectual Property',
      'doc_rule_9_desc': 'All original assets, including stickers and UI elements, are the intellectual property of Amomimus.',
      'doc_rule_10_title': '10. Policy Updates',
      'doc_rule_10_desc': 'We reserve the right to update these terms. Continued use of the app constitutes acceptance of the new terms.',
"""

id_add = """      'doc_title': 'Dokumentasi Aplikasi',
      'doc_category_legal': 'Hukum & Kebijakan Privasi',
      'doc_rule_1_title': '1. Pengumpulan Data',
      'doc_rule_1_desc': 'Kami hanya mengumpulkan data minimum untuk fitur inti. Pengidentifikasi anonim Anda tidak tertaut dengan identitas pribadi Anda.',
      'doc_rule_2_title': '2. Enkripsi End-to-End',
      'doc_rule_2_desc': 'Semua pesan obrolan dienkripsi secara end-to-end. Kami tidak dapat membaca pesan pribadi Anda.',
      'doc_rule_3_title': '3. Data Sesi',
      'doc_rule_3_desc': 'Data sesi lokal disimpan dengan aman di perangkat Anda. Menghapus data aplikasi akan menghapus riwayat lokal Anda secara permanen.',
      'doc_rule_4_title': '4. Layanan Pihak Ketiga',
      'doc_rule_4_desc': 'Kami tidak menjual atau membagikan data Anda dengan pihak ketiga. Integrasi eksternal apa pun hanya untuk tujuan operasional.',
      'doc_rule_5_title': '5. Tanggung Jawab Konten Pengguna',
      'doc_rule_5_desc': 'Anda bertanggung jawab penuh atas konten yang Anda posting. Amomimus tidak bertanggung jawab atas konten buatan pengguna.',
      'doc_rule_6_title': '6. Jaminan Anonimitas',
      'doc_rule_6_desc': 'Interaksi publik Anda tetap anonim kecuali Anda secara eksplisit memilih untuk mengungkapkan identitas Anda melalui permintaan obrolan.',
      'doc_rule_7_title': '7. Penghapusan Akun',
      'doc_rule_7_desc': 'Anda berhak menghapus akun Anda kapan saja. Tindakan ini tidak dapat diubah dan menghapus semua catatan terkait.',
      'doc_rule_8_title': '8. Pelecehan & Penyalahgunaan',
      'doc_rule_8_desc': 'Kami menerapkan kebijakan tanpa toleransi terhadap pelecehan. Pelanggar akan diblokir secara permanen.',
      'doc_rule_9_title': '9. Kekayaan Intelektual',
      'doc_rule_9_desc': 'Semua aset asli, termasuk stiker dan elemen UI, adalah kekayaan intelektual Amomimus.',
      'doc_rule_10_title': '10. Pembaruan Kebijakan',
      'doc_rule_10_desc': 'Kami berhak memperbarui ketentuan ini. Penggunaan aplikasi yang berkelanjutan merupakan penerimaan terhadap ketentuan baru.',
"""

jp_add = """      'doc_title': 'アプリのドキュメント',
      'doc_category_legal': '法的・プライバシーポリシー',
      'doc_rule_1_title': '1. データ収集',
      'doc_rule_1_desc': '主要機能に必要な最小限のデータのみを収集します。匿名の識別子は個人情報とはリンクされません。',
      'doc_rule_2_title': '2. エンドツーエンド暗号化',
      'doc_rule_2_desc': 'すべてのチャットメッセージはエンドツーエンドで暗号化されます。私たちはあなたのプライベートメッセージを読むことはできません。',
      'doc_rule_3_title': '3. セッションデータ',
      'doc_rule_3_desc': 'ローカルセッションデータはデバイスに安全に保存されます。アプリデータをクリアすると、ローカルの履歴が永久に消去されます。',
      'doc_rule_4_title': '4. サードパーティサービス',
      'doc_rule_4_desc': '私たちはあなたのデータを第三者に販売または共有することはありません。外部統合は厳密に運用目的のためだけです。',
      'doc_rule_5_title': '5. ユーザーコンテンツの責任',
      'doc_rule_5_desc': '投稿したコンテンツについては、あなたが全責任を負います。Amomimusはユーザー生成コンテンツについて一切の責任を負いません。',
      'doc_rule_6_title': '6. 匿名性の保証',
      'doc_rule_6_desc': 'チャットリクエストを通じて身元を明かすことを明示的に選択しない限り、公開でのやり取りは匿名のままです。',
      'doc_rule_7_title': '7. アカウント削除',
      'doc_rule_7_desc': 'あなたはいつでもアカウントを削除する権利があります。この操作は元に戻せず、関連するすべての記録が消去されます。',
      'doc_rule_8_title': '8. ハラスメントと乱用',
      'doc_rule_8_desc': 'ハラスメントに対して厳格なゼロ・トレランス・ポリシーを維持しています。違反者は永久に追放されます。',
      'doc_rule_9_title': '9. 知的財産権',
      'doc_rule_9_desc': 'ステッカーやUI要素を含むすべてのオリジナルアセットは、Amomimusの知的財産です。',
      'doc_rule_10_title': '10. ポリシーの更新',
      'doc_rule_10_desc': '私たちはこれらの条件を更新する権利を留保します。アプリの継続使用は新しい条件への同意とみなされます。',
"""

content = content.replace("'reply': 'Reply',", "'reply': 'Reply',\n" + en_add)
content = content.replace("'reply': 'Balas',", "'reply': 'Balas',\n" + id_add)
content = content.replace("'reply': '返信',", "'reply': '返信',\n" + jp_add)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
print("Done")
