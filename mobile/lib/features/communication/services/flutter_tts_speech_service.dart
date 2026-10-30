import 'package:flutter_tts/flutter_tts.dart';

import 'speech_service.dart';

/// Reads Arabic sentences out loud with the phone's text-to-speech engine.
class FlutterTtsSpeechService implements SpeechService {
  FlutterTtsSpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;
  bool _isReady = false;

  static const String _egyptianArabic = 'ar-EG';
  static const String _arabic = 'ar';

  // 0.5 is the normal speed; a little slower is easier for a child to follow.
  static const double _speechRate = 0.4;

  @override
  Future<void> speak(String text) async {
    await _prepare();
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Future<void> stop() => _tts.stop();

  Future<void> _prepare() async {
    if (_isReady) return;
    final hasEgyptian = await _tts.isLanguageAvailable(_egyptianArabic) == true;
    await _tts.setLanguage(hasEgyptian ? _egyptianArabic : _arabic);
    await _tts.setSpeechRate(_speechRate);
    _isReady = true;
  }
}