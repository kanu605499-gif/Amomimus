import 'dart:convert';
import 'dart:io';

void main() {
  final keys = {
    'en': {
      'report_user': 'Report User',
      'report_message': 'Report Message',
      'select_category': 'Select a category:',
      'detailed_comment': 'Detailed comment (required for ban):',
      'provide_details': 'Please provide details...',
      'block_ban_user': 'Block / Ban User',
      'comment_required_ban': 'You must provide a comment to enable this.',
      'submit_report': 'Submit Report',
      'report_submitted': 'Report Submitted',
      'report_sent_user_blocked': 'The report was sent and the user is now blocked.',
      'thank_you_safe': 'Thank you for making Amomimus a safer place.',
      'close': 'Close',
      'category_spam': 'Spam / Harassment',
      'category_inappropriate': 'Inappropriate Content',
      'category_hate': 'Hate Speech',
    },
    'id': {
      'report_user': 'Laporkan Pengguna',
      'report_message': 'Laporkan Pesan',
      'select_category': 'Pilih kategori:',
      'detailed_comment': 'Komentar detail (wajib untuk ban):',
      'provide_details': 'Tolong berikan detail...',
      'block_ban_user': 'Blokir / Ban Pengguna',
      'comment_required_ban': 'Anda harus memberikan komentar untuk mengaktifkan ini.',
      'submit_report': 'Kirim Laporan',
      'report_submitted': 'Laporan Terkirim',
      'report_sent_user_blocked': 'Laporan terkirim dan pengguna kini diblokir.',
      'thank_you_safe': 'Terima kasih telah membuat Amomimus lebih aman.',
      'close': 'Tutup',
      'category_spam': 'Spam / Pelecehan',
      'category_inappropriate': 'Konten Tidak Pantas',
      'category_hate': 'Ujaran Kebencian',
    },
    'th': {
      'report_user': 'รายงานผู้ใช้',
      'report_message': 'รายงานข้อความ',
      'select_category': 'เลือกหมวดหมู่:',
      'detailed_comment': 'รายละเอียด (จำเป็นสำหรับการแบน):',
      'provide_details': 'กรุณาให้รายละเอียด...',
      'block_ban_user': 'บล็อกผู้ใช้',
      'comment_required_ban': 'คุณต้องระบุความคิดเห็นเพื่อเปิดใช้งานสิ่งนี้',
      'submit_report': 'ส่งรายงาน',
      'report_submitted': 'ส่งรายงานแล้ว',
      'report_sent_user_blocked': 'ส่งรายงานแล้วและผู้ใช้ถูกบล็อกแล้ว',
      'thank_you_safe': 'ขอบคุณที่ทำให้ Amomimus เป็นพื้นที่ที่ปลอดภัยขึ้น',
      'close': 'ปิด',
      'category_spam': 'สแปม / การคุกคาม',
      'category_inappropriate': 'เนื้อหาไม่เหมาะสม',
      'category_hate': 'คำพูดเกลียดชัง',
    },
    'tm': {
      'report_user': 'Condemn Joor',
      'report_message': 'Condemn Rot',
      'select_category': 'Select a transgression:',
      'detailed_comment': 'Scribe your reason (required for banishment):',
      'provide_details': 'Detail the transgression...',
      'block_ban_user': 'Throw in Dungeon',
      'comment_required_ban': 'You must scribe a reason to banish this soul.',
      'submit_report': 'Summon Guards',
      'report_submitted': 'Guards Summoned',
      'report_sent_user_blocked': 'The guards have taken the soul to the dungeon.',
      'thank_you_safe': 'You have done Skyrim a great service.',
      'close': 'Sheathe',
      'category_spam': 'Annoying Bard / Harassment',
      'category_inappropriate': 'Skooma Dealing / Vile Act',
      'category_hate': 'Blasphemy against the Divines',
    }
  };

  final dir = Directory('e:/Kanu Flutter/Amomimus/lib/i18n');
  
  for (final lang in keys.keys) {
    final file = File('${dir.path}/$lang.i18n.json');
    if (file.existsSync()) {
      final jsonString = file.readAsStringSync();
      final Map<String, dynamic> data = jsonDecode(jsonString);
      
      final langKeys = keys[lang]!;
      for (final key in langKeys.keys) {
        data[key] = langKeys[key];
      }
      
      file.writeAsStringSync(jsonEncode(data));
      print('Updated $lang.i18n.json');
    }
  }
}
