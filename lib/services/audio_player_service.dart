import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 使用 audioplayers 播放云端 TTS 二进制流。不使用系统本地 TTS。
class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  /// 播放字节音频：写入临时文件后播放；新播放会打断上一首。
  Future<void> playBytes(List<int> bytes, {String extension = 'mp3'}) async {
    await stop();
    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(
        dir.path,
        'asean_tts_${DateTime.now().millisecondsSinceEpoch}.$extension',
      ),
    );
    await file.writeAsBytes(bytes, flush: true);
    await _player.play(DeviceFileSource(file.path));
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
