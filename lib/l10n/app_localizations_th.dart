import 'app_localizations.dart';

class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh() : super('th');

  @override
  String get appTitle => 'ผู้ช่วยอากาศอาเซียน AI';
  @override
  String get welcomeTitle => 'ยินดีต้อนรับ';
  @override
  String get welcomeMessage =>
      'สอบถามสภาพอากาศ พยากรณ์ และภูมิอากาศในอาเซียนได้ ทั้งข้อความและเสียง';
  @override
  String get inputHint => 'ถามคำถามเกี่ยวกับอากาศ...';
  @override
  String get send => 'ส่ง';
  @override
  String get recordStart => 'แตะเพื่ออัดเสียง';
  @override
  String get recordStop => 'แตะเพื่อหยุด';
  @override
  String get recording => 'กำลังอัดเสียง...';
  @override
  String get sourcePanelTitle => 'แหล่งข้อมูลอากาศ';
  @override
  String get sourceEmpty => 'ไม่มีแหล่งข้อมูล';
  @override
  String get loading => 'กำลังคิด...';
  @override
  String get errorNetwork => 'เครือข่ายผิดพลาด กรุณาตรวจสอบเซิร์ฟเวอร์';
  @override
  String get errorGeneric => 'เกิดข้อผิดพลาด กรุณาลองใหม่';
  @override
  String get errorPermissionMic => 'ต้องการสิทธิ์ไมโครโฟนสำหรับการพูด';
  @override
  String get errorSttEmpty => 'รู้จำเสียงไม่ได้ กรุณาลองใหม่';
  @override
  String get language => 'ภาษา';
  @override
  String get clearHistory => 'ล้างประวัติ';
  @override
  String get clearHistoryConfirm => 'ล้างประวัติแชททั้งหมด?';
  @override
  String get cancel => 'ยกเลิก';
  @override
  String get confirm => 'ยืนยัน';
  @override
  String get playingAudio => 'กำลังเล่นคำตอบ...';
}
