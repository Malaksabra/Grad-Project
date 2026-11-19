// Arabic texts of the games section, kept in one place.
class GamesTexts {
  const GamesTexts._();

  // Games list page.
  static const String sectionTitle = 'الألعاب';
  static const String sectionSubtitle = 'ألعب وأفكّر';
  static const String memoryCardsTitle = 'Memory cards';
  static const String puzzleTitle = 'Puzzle';
  static const String oddOneOutTitle = 'Odd one out';

  // Levels page.
  static const String levelsGuide =
      'جرّبوا أي مستوى، واختاروا اللي هيظهر للطفل.';
  static const String levelsTitle = 'المستويات';
  static const String levelsHelp =
      'اضغطوا على المستوى عشان تجرّبوه. وزرار "اختيار للطفل" بيحدد اللعبة والمستوى اللي الطفل هيلاقيهم جاهزين.';
  static const String chooseForChild = 'اختيار للطفل';
  static const String chosenForChild = 'مختار للطفل';

  // The names of the three levels, in order.
  static const List<String> levelNames = ['الأول', 'التاني', 'التالت'];

  static String levelTitle(int index) => 'المستوى ${levelNames[index]}';

  // Example: "6 كروت  ·  " and then the time, which is drawn with the timer
  // picture.
  static String cardsCount(int cards) => '$cards كروت';
  static String piecesCount(int pieces) => '$pieces قطع';
  static String roundsCount(int rounds) => '$rounds جولات';
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

  // Puzzle game page.
  static const String puzzleGuide =
      'نختار قطعة وبعدين قطعة تانية، ونبدّلهم لحد ما الصورة تتظبط.';
  static const String puzzleGameTitle = 'نركّب الصورة';
  static const String puzzleMessageStart = 'الوقت بيبدأ لما تختار أول قطعة.';
  static const String puzzleMessageSecond = 'اختار قطعة تانية عشان تتبدّل.';
  static const String puzzleMessageSwapped = 'كمّل، إنت بتقرّب!';
  static const String puzzleMessageCancel = 'تمام، اختار قطعة تانية.';

  // "Pick the different one" game page.
  static const String oddGuide = 'ندوّر على الصورة المختلفة ونضغط عليها.';
  static const String oddGameTitle = 'مين المختلف؟';
  static const String oddMessageStart = 'اضغط على الصورة المختلفة.';
  static const String oddMessageCorrect = 'برافو! ده المختلف.';
  static const String oddMessageWrong = 'مش دي. جرّب تاني، مفيش مشكلة.';
  static String roundOf(int round, int rounds) => 'الجولة $round من $rounds';

  // End of the game.
  static const String won = 'خلصت! برافو';
  static const String timeUp = 'الوقت خلص. مفيش مشكلة!';
  static const String tryAgainQuestion = 'نجرّب تاني؟';
  // Shown to the child instead of the question above, because the child
  // plays only once a day.
  static const String timeUpTomorrow = 'هنلعب تاني بكرة.';
  static const String playAgain = 'نلعب تاني';
  static const String tryAgain = 'نجرّب تاني';
  static const String exit = 'خروج';

  // The child's page after the game of the day is finished.
  static const String childDoneTitle = 'خلصت لعب النهاردة! برافو';
  static const String childDoneSubtitle = 'هنلعب تاني بكرة.';

  // The note for the parents on the levels page.
  static const String finishedNotice =
      'الطفل خلّص لعب النهاردة. أي اختيار جديد هيظهر له بكرة.';

  // Shared.
  static const String back = 'رجوع';
}
