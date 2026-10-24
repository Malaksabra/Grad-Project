// Arabic texts of the games section, kept in one place.
class GamesTexts {
  const GamesTexts._();

  // Games list page.
  static const String sectionTitle = 'الألعاب';
  static const String sectionSubtitle = 'ألعب وأفكّر';
  static const String memoryCardsTitle = 'Memory cards';

  // Levels page.
  static const String levelsGuide = 'جرّبوا أي مستوى، واختاروا اللي هيظهر للطفل.';
  static const String levelsTitle = 'المستويات';
  static const String levelsHelp =
      'اضغطوا على المستوى عشان تجرّبوه. وزرار "اختيار للطفل" بيحدد المستوى اللي الطفل هيلاقيه جاهز.';
  static const String chooseForChild = 'اختيار للطفل';
  static const String chosenForChild = 'مختار للطفل';

  // The names of the three levels, in order.
  static const List<String> levelNames = ['الأول', 'التاني', 'التالت'];

  static String levelTitle(int index) => 'المستوى ${levelNames[index]}';

  // Example: "6 كروت  ·  " and then the time, which is drawn with the timer
  // picture.
  static String cardsCount(int cards) => '$cards كروت';
  static const String summarySeparator = '  ·  ';

  // Screen reader labels of the levels page.
  static String tryLevelLabel(int index) => 'جرّب المستوى ${levelNames[index]}';
  static String chooseLevelLabel(int index) =>
      'اختيار المستوى ${levelNames[index]} للطفل';

  // Memory game page.
  static const String gameGuide = 'نقلب كارتين ونشوف لو زي بعض. خدنا وقتنا.';
  static const String gameTitle = 'نلاقي الكروت اللي زي بعض';
  static const String messageStart = 'الوقت بيبدأ لما تقلب أول كارت.';
  static const String messageFlipSecond = 'اقلب كارت تاني.';
  static const String messageMatch = 'زوج حلو!';
  static const String messageNoMatch = 'مش زي بعض. نجرّب تاني، مفيش مشكلة.';

  // End of the game.
  static const String won = 'خلصت! برافو';
  static const String timeUp = 'الوقت خلص. مفيش مشكلة!';
  static const String tryAgainQuestion = 'نجرّب تاني؟';
  static const String playAgain = 'نلعب تاني';
  static const String tryAgain = 'نجرّب تاني';
  static const String exit = 'خروج';

  // Shared.
  static const String back = 'رجوع';
}
