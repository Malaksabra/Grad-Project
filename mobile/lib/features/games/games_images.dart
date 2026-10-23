// Image paths of the games section.
// The files live in assets/images/games/, which is registered in pubspec.yaml.
class GamesImages {
  const GamesImages._();

  static const String _folder = 'assets/images/games';

  // The picture of the memory game on the games list page.
  static const String memoryCards = '$_folder/Memory.jpeg';

  // Small pictures from Noto Emoji (Google), used instead of emoji characters.
  static const String controller = '$_folder/controller.png';
  static const String timer = '$_folder/timer.png';
  static const String question = '$_folder/question.png';
  static const String alarm = '$_folder/alarm.png';

  // The pictures on the memory cards. The biggest level uses all six.
  static const List<String> fruits = [
    '$_folder/apple.jpg',
    '$_folder/banana.jpg',
    '$_folder/mango.jpg',
    '$_folder/orange.jpg',
    '$_folder/strawberry.jpg',
    '$_folder/watermelon.jpg',
  ];
}
