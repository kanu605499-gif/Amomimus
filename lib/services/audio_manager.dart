import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // Singleton pattern
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  // Single player instance to ensure sounds don't overlap/clash
  final AudioPlayer _player = AudioPlayer();
  
  // Throttle tracking for notif alerts
  DateTime _lastAlertTime = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> playClickChat() async {
    await _player.play(AssetSource('audio/mouse_click.mp3'));
  }

  Future<void> playNotifAlert() async {
    final now = DateTime.now();
    // Prevent spam: only play if it has been more than 5 seconds since the last alert
    if (now.difference(_lastAlertTime).inSeconds > 5) {
      _lastAlertTime = now;
      await _player.play(AssetSource('audio/notif_alert.mp3'));
    }
  }

  Future<void> playChatNotif() async {
    final now = DateTime.now();
    // Prevent spam: only play if it has been more than 3 seconds since the last alert
    if (now.difference(_lastAlertTime).inSeconds > 3) {
      _lastAlertTime = now;
      await _player.play(AssetSource('audio/chat_notif.mp3'));
    }
  }

  Future<void> playOldRadio() async {
    await _player.play(AssetSource('audio/old_radio.mp3'));
  }
  
  Future<void> playIntro() async {
    await _player.play(AssetSource('audio/intro.mp3'));
  }
  
  Future<void> stop() async {
    await _player.stop();
  }
}
