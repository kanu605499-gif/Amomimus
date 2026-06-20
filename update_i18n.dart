import 'dart:convert';
import 'dart:io';

void main() async {
  final Map<String, Map<String, String>> translations = {
    'ja.i18n.json': {
      "app_features_title": "App Features",
      "system_features_title": "System Features",
      "feature_1_title": "Dynamic Persona Theming",
      "feature_1_desc": "インターフェースのテーマは、プロフィールに使用される性別（Amo、Amom、またはAmi）に適応し、各役割セッションに同期した視覚的なカスタマイズを提供します。",
      "feature_2_title": "Interactive Mini Island",
      "feature_2_desc": "ユーザーのインタラクションの快適さを容易にするために設計されたポータブル通知パネル。チャットエリアに浮かび、動的に上部のナビゲーションバー（App Bar）に融合します。",
      "feature_3_title": "Glitch & Ex-Blocked",
      "feature_3_desc": "ブロックとレポート機能に心理的な影響を与えるように設計されています。以前ブロックされたユーザーとのインタラクションは、視覚的な歪みの警告を引き起こし、自然な注意を促します。",
      "feature_4_title": "Memories & Activity Log",
      "feature_4_desc": "包括的なロギングユーティリティを提供します。重要なメッセージをMemoriesにピン留めでき、Chat Logは自律的にルームの履歴とアクティビティの時系列を記録します。",
      "feature_5_title": "Floating Countdown Capsule",
      "feature_5_desc": "ユーザーがチャットの残り時間を認識できるようにするインタラクティブな時間追跡モジュール。メッセージの読み取り領域を遮らないように自由にドラッグアンドドロップできます。",
      "system_1_title": "Hybrid Sync Engine",
      "system_1_desc": "メッセージングアーキテクチャは、インテリジェントな非同期シミュレーションエンジンを利用しています。保留中、成功、失敗の処理に至るまで、メッセージのライフサイクルを非常にリアルに管理します。",
      "system_2_title": "Secret \"Human\" Cheat Detection",
      "system_2_desc": "チャットのスポーツマンシップを維持する目に見えないセキュリティプロトコル。禁止された会話パターンをパッシブにスキャンし、アプリのパフォーマンスに負担をかけることなく違反者を警告します。",
      "system_3_title": "State Persistence Core",
      "system_3_desc": "すべてのステータス設定、ログ、およびインタラクションは、API統合と組み合わせたハイブリッドローカルメソッドを介して管理されます。アプリが閉じられて再度開かれたときに、チャットの重要なデータがそのまま残ることを保証します。"
    },
    'de.i18n.json': {
      "app_features_title": "App Features",
      "system_features_title": "System Features",
      "feature_1_title": "Dynamic Persona Theming",
      "feature_1_desc": "Das Schnittstellendesign passt sich dem Geschlecht Ihres Profils an (Amo, Amom oder Ami) und bietet so eine synchronisierte visuelle Anpassung für jede Rollensitzung.",
      "feature_2_title": "Interactive Mini Island",
      "feature_2_desc": "Ein tragbares Benachrichtigungsfeld, das den Interaktionskomfort für Benutzer erleichtert. Es schwebt im Chatbereich und verschmilzt dynamisch mit der oberen Navigationsleiste (App Bar).",
      "feature_3_title": "Glitch & Ex-Blocked",
      "feature_3_desc": "Entwickelt, um den Blockier- und Meldefunktionen ein psychologisches Gewicht zu verleihen. Interaktionen mit einem zuvor blockierten Benutzer lösen eine visuelle Verzerrungswarnung aus, die natürliche Vorsicht vermittelt.",
      "feature_4_title": "Memories & Activity Log",
      "feature_4_desc": "Bietet umfassende Protokollierungswerkzeuge. Sie können wichtige Nachrichten in Memories anheften, während das Chat-Protokoll autonom den Verlauf und die Aktivitätschronologie des Raums dokumentiert.",
      "feature_5_title": "Floating Countdown Capsule",
      "feature_5_desc": "Ein interaktives Zeitverfolgungsmodul, das sicherstellt, dass die Benutzer die verbleibende Chat-Dauer im Auge behalten. Es kann frei per Drag & Drop verschoben werden, um den Lesebereich für Nachrichten nicht zu blockieren.",
      "system_1_title": "Hybrid Sync Engine",
      "system_1_desc": "Die Nachrichtenarchitektur wird von einer intelligenten asynchronen Simulationsmaschine angetrieben. Es verwaltet den Nachrichtenlebenszyklus von anstehenden, erfolgreichen bis hin zu Fehlerbehebungen mit hohem Realismus.",
      "system_2_title": "Secret \"Human\" Cheat Detection",
      "system_2_desc": "Ein unsichtbares Sicherheitsprotokoll, das die Chat-Sportlichkeit aufrechterhält. Es scannt passiv auf verbotene Verhaltensmuster und verwarnt Übertreter, ohne die App-Leistung zu beeinträchtigen.",
      "system_3_title": "State Persistence Core",
      "system_3_desc": "Alle Statuspräferenzen, Protokolle und Interaktionen werden über eine hybride lokale Methode kombiniert mit API-Integration verwaltet. Dies stellt sicher, dass kritische Chatdaten über Sitzungen hinweg intakt bleiben."
    },
    'th.i18n.json': {
      "app_features_title": "App Features",
      "system_features_title": "System Features",
      "feature_1_title": "Dynamic Persona Theming",
      "feature_1_desc": "ธีมของอินเทอร์เฟซจะปรับเปลี่ยนตามเพศโปรไฟล์ของคุณ (Amo, Amom หรือ Ami) ทำให้เกิดการปรับแต่งภาพที่ซิงโครไนซ์สำหรับทุกช่วงบทบาท",
      "feature_2_title": "Interactive Mini Island",
      "feature_2_desc": "แผงการแจ้งเตือนแบบพกพาที่ออกแบบมาเพื่ออำนวยความสะดวกในการโต้ตอบของผู้ใช้ มันลอยอยู่ในพื้นที่แชทและผสานเข้ากับแถบนำทางด้านบน (App Bar) แบบไดนามิก",
      "feature_3_title": "Glitch & Ex-Blocked",
      "feature_3_desc": "ออกแบบมาเพื่อให้ผลกระทบทางจิตวิทยาแก่คุณสมบัติการบล็อกและการรายงาน การโต้ตอบกับผู้ใช้ที่เคยถูกบล็อกจะทำให้เกิดคำเตือนความผิดเพี้ยนทางภาพเพื่อสร้างความระมัดระวังตามธรรมชาติ",
      "feature_4_title": "Memories & Activity Log",
      "feature_4_desc": "จัดเตรียมยูทิลิตี้การบันทึกที่ครอบคลุม คุณสามารถปักหมุดข้อความที่สำคัญลงใน Memories ได้ ในขณะที่ Chat Log จะบันทึกประวัติและลำดับเหตุการณ์ของห้องโดยอัตโนมัติ",
      "feature_5_title": "Floating Countdown Capsule",
      "feature_5_desc": "โมดูลตัวติดตามเวลาแบบอินเทอร์แอกทีฟที่ช่วยให้ผู้ใช้รับรู้ถึงระยะเวลาแชทที่เหลืออยู่ สามารถลากและวางได้อย่างอิสระเพื่อไม่ให้บดบังพื้นที่อ่านข้อความ",
      "system_1_title": "Hybrid Sync Engine",
      "system_1_desc": "สถาปัตยกรรมการส่งข้อความขับเคลื่อนโดยกลไกการจำลองแบบอะซิงโครนัสอัจฉริยะ โดยจัดการวงจรชีวิตของข้อความตั้งแต่รอดำเนินการ สำเร็จ ไปจนถึงการจัดการความล้มเหลวด้วยความสมจริงสูง",
      "system_2_title": "Secret \"Human\" Cheat Detection",
      "system_2_desc": "โปรโตคอลความปลอดภัยที่มองไม่เห็นซึ่งรักษาน้ำใจนักกีฬาในการแชท จะสแกนหารูปแบบพฤติกรรมที่ต้องห้ามแบบพาสซีฟ และตำหนิผู้ฝ่าฝืนโดยไม่เป็นภาระต่อประสิทธิภาพของแอป",
      "system_3_title": "State Persistence Core",
      "system_3_desc": "การตั้งค่าสถานะ บันทึก และการโต้ตอบทั้งหมดได้รับการจัดการผ่านวิธีการโลคัลไฮบริดที่รวมกับการรวม API เพื่อให้มั่นใจว่าข้อมูลแชทที่สำคัญจะยังคงอยู่เหมือนเดิมในทุกช่วงเวลา"
    },
    'tm.i18n.json': {
      "app_features_title": "App Features",
      "system_features_title": "System Features",
      "feature_1_title": "Dynamic Persona Theming",
      "feature_1_desc": "Interfeýs temasy profil jynsyňyza (Amo, Amom ýa-da Ami) laýyklaşyp, her rol seansy üçin sinhronlaşdyrylan wizual sazlamany üpjün edýär.",
      "feature_2_title": "Interactive Mini Island",
      "feature_2_desc": "Ulanyjy aragatnaşygynyň amatlygyny ýeňilleşdirmek üçin niýetlenen göçme habarnama paneli. Çat meýdançasynda ýüzýär we ýokarky nawigasiýa zolagyna (App Bar) dinamiki birikýär.",
      "feature_3_title": "Glitch & Ex-Blocked",
      "feature_3_desc": "Bloklamak we hasabat bermek aýratynlyklaryna psihologik täsir etmek üçin niýetlenen. Öňki bloklanan ulanyjy bilen aragatnaşyk, tebigy ätiýaçlygy döretmek üçin wizual ýoýulma duýduryşyny döredýär.",
      "feature_4_title": "Memories & Activity Log",
      "feature_4_desc": "Köpmetaraplaýyn bellik amallaryny üpjün edýär. Möhüm habarlary Memories-e berkidip bilersiňiz, Chat Log bolsa otagyň taryhyny we işjeňliginiň hronologiýasyny awtonom resminamalaşdyrýar.",
      "feature_5_title": "Floating Countdown Capsule",
      "feature_5_desc": "Ulanyjylaryň galan çatyň dowamlylygyndan habarly bolmagyny üpjün edýän interaktiw wagt yzarlaýjy modul. Habary okamak meýdanyny beklemäzlik üçin erkin süýräp we taşlap bolýar.",
      "system_1_title": "Hybrid Sync Engine",
      "system_1_desc": "Habarlaşma arhitekturasy akylly asinhron simulýasiýa hereketlendirijisi bilen işleýär. Garaşylýan, üstünlikli bolanlardan başlap, şowsuzlygy ýokary hakykat bilen dolandyrýança habaryň ýaşaýyş siklini dolandyrýar.",
      "system_2_title": "Secret \"Human\" Cheat Detection",
      "system_2_desc": "Çat sport rejeliligini saklaýan göze görünmeýän howpsuzlyk protokoly. Gadagan edilen özüni alyp barşyň nusgalaryny passiw gözden geçirýär we programma öndürijiligine agram salman düzgün bozujylara duýduryş berýär.",
      "system_3_title": "State Persistence Core",
      "system_3_desc": "Shli ýagdaý islegleri, loglar we aragatnaşyklar API integrasiýasy bilen birleşdirilen gibrid ýerli usul arkaly dolandyrylýar. Möhüm çat maglumatlarynyň seanslaryň dowamynda üýtgewsiz galmagyny üpjün etmek."
    }
  };

  for (final entry in translations.entries) {
    final file = File('lib/i18n/${entry.key}');
    if (file.existsSync()) {
      final content = await file.readAsString();
      final Map<String, dynamic> json = jsonDecode(content);
      
      json.addAll(entry.value);
      
      await file.writeAsString(jsonEncode(json));
    }
  }
  print('done');
}
