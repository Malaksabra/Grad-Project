// Image paths of the games section.
// The files live in assets/images/games/, which is registered in pubspec.yaml.
class GamesImages {
  const GamesImages._();

  static const String _folder = 'assets/images/games';

  // The picture of the memory game on the games list page.
  static const String memoryCards = '$_folder/Memory.jpeg';

  // The pictures of the other two games on the games list page.
  static const String puzzleCards = '$_folder/Puzzle.jpeg';
  static const String oddOneOutCards = '$_folder/OddOneOut.jpeg';

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

  // The vegetables of the "pick the different one" game. Each round shows
  // fruits with one vegetable, or vegetables with one fruit.
  static const List<String> vegetables = [
    '$_folder/carrot.jpeg',
    '$_folder/broccoli.jpeg',
    '$_folder/corn.jpeg',
    '$_folder/eggplant.jpeg',
    '$_folder/cucumber.jpeg',
  ];
}
