import 'app_localizations.dart';

class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId() : super('id');

  @override
  String get appTitle => 'Asisten Cuaca ASEAN AI';
  @override
  String get welcomeTitle => 'Selamat datang';
  @override
  String get welcomeMessage =>
      'Tanyakan cuaca, prakiraan, dan iklim ASEAN. Dukungan teks dan suara.';
  @override
  String get inputHint => 'Tanyakan pertanyaan cuaca...';
  @override
  String get send => 'Kirim';
  @override
  String get recordStart => 'Ketuk untuk merekam';
  @override
  String get recordStop => 'Ketuk untuk berhenti';
  @override
  String get recording => 'Merekam...';
  @override
  String get sourcePanelTitle => 'Sumber data cuaca';
  @override
  String get sourceEmpty => 'Tidak ada sumber';
  @override
  String get loading => 'Sedang berpikir...';
  @override
  String get errorNetwork => 'Kesalahan jaringan. Periksa layanan backend.';
  @override
  String get errorGeneric => 'Terjadi kesalahan. Silakan coba lagi.';
  @override
  String get errorPermissionMic =>
      'Izin mikrofon diperlukan untuk input suara.';
  @override
  String get errorSttEmpty => 'Suara tidak dikenali. Silakan coba lagi.';
  @override
  String get language => 'Bahasa';
  @override
  String get clearHistory => 'Hapus riwayat';
  @override
  String get clearHistoryConfirm => 'Hapus semua riwayat chat?';
  @override
  String get cancel => 'Batal';
  @override
  String get confirm => 'Konfirmasi';
  @override
  String get playingAudio => 'Memutar jawaban...';
}
