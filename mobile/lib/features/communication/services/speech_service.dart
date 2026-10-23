import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Reads a sentence out loud. The pages depend on this, not on a package.
abstract class SpeechService {
  Future<void> speak(String text);

  Future<void> stop();
}

/// Reads Arabic sentences out loud with the device's text-to-speech engine.
class FlutterTtsSpeechService implements SpeechService {
  FlutterTtsSpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;
  Future<void>? _preparation;

  // Egyptian Arabic first, because the app speaks Egyptian.
  static const List<String> _preferredLanguages = ['ar-EG', 'ar-SA', 'ar'];

  // 0.5 is the normal speed; a little slower is easier for a child to follow.
  static const double _speechRate = 0.4;
  static const double _volume = 1.0;

  @override
  Future<void> speak(String text) async {
    // Prepare once; later taps reuse the same result.
    await (_preparation ??= _prepare());
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Future<void> stop() => _tts.stop();

  Future<void> _prepare() async {
    // Without this, a missing voice fails silently and nobody knows why.
    _tts.setErrorHandler((message) => debugPrint('TTS error: $message'));

    try {
      final languages = await _availableLanguages();
      final language = _preferredLanguages.firstWhere(
        languages.contains,
        orElse: () => _preferredLanguages.last,
      );
      if (!languages.contains(language)) {
        debugPrint('TTS: no Arabic voice found. Available: $languages');
      }
      await _tts.setLanguage(language);
      await _tts.setSpeechRate(_speechRate);
      await _tts.setVolume(_volume);
    } catch (error) {
      debugPrint('TTS setup failed: $error');
    }
  }

  Future<List<String>> _availableLanguages() async {
    final languages = await _tts.getLanguages;
    if (languages is! List) return const [];
    return [for (final item in languages) '$item'.replaceAll('_', '-')];
  }
}
