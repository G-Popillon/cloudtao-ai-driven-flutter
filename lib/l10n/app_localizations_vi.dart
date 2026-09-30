import 'app_localizations.dart';

class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi() : super('vi');

  @override
  String get appTitle => 'Trợ lý Thời tiết ASEAN AI';
  @override
  String get welcomeTitle => 'Chào mừng';
  @override
  String get welcomeMessage =>
      'Hỏi về thời tiết, dự báo và khí hậu ASEAN. Hỗ trợ văn bản và giọng nói.';
  @override
  String get inputHint => 'Nhập câu hỏi thời tiết...';
  @override
  String get send => 'Gửi';
  @override
  String get recordStart => 'Chạm để ghi âm';
  @override
  String get recordStop => 'Chạm để dừng';
  @override
  String get recording => 'Đang ghi âm...';
  @override
  String get sourcePanelTitle => 'Nguồn dữ liệu thời tiết';
  @override
  String get sourceEmpty => 'Không có nguồn';
  @override
  String get loading => 'Đang suy nghĩ...';
  @override
  String get errorNetwork => 'Lỗi mạng. Vui lòng kiểm tra máy chủ backend.';
  @override
  String get errorGeneric => 'Đã xảy ra lỗi. Vui lòng thử lại.';
  @override
  String get errorPermissionMic => 'Cần quyền micro để nhập giọng nói.';
  @override
  String get errorSttEmpty =>
      'Không nhận diện được giọng nói. Vui lòng thử lại.';
  @override
  String get language => 'Ngôn ngữ';
  @override
  String get clearHistory => 'Xóa lịch sử';
  @override
  String get clearHistoryConfirm => 'Xóa toàn bộ lịch sử trò chuyện?';
  @override
  String get cancel => 'Hủy';
  @override
  String get confirm => 'Xác nhận';
  @override
  String get playingAudio => 'Đang phát câu trả lời...';
}
