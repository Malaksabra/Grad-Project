/// Reads a sentence out loud. The pages depend on this, not on a package.
abstract class SpeechService {
  Future<void> speak(String text);

  Future<void> stop();
}