// Arabic texts of the communication section, kept in one place.
class CommunicationTexts {
  const CommunicationTexts._();

  // Home page.
  static const String sectionTitle = 'التواصل';
  static const String whatIWant = 'أقول نفسي في إيه';
  static const String signs = 'الإشارات';

  // Categories of "what I want".
  static const String foodAndDrink = 'أكل وشرب';
  static const String toys = 'ألعاب';
  static const String places = 'أماكن';
  static const String comfort = 'راحة';
  static const String askForHelp = 'أطلب مساعدة';
  static const String tellPain = 'أقول إيه بيوجعني';

  // Sentence parts and buttons.
  static const String iWant = 'أنا عايز';
  static const String pickCard = 'اختار كارت';
  static const String please = 'لو سمحت';
  static const String painTail = 'بتوجعني';
  static const String giveMe = 'اديني';
  static const String tellMama = 'أقول لماما';
  static const String sound = 'صوت';
  static const String listen = 'اسمع';
  static const String anotherThing = 'حاجة تانية';
  static const String again = 'نعيد';

  // What the teddy says.
  static const String teddyNeeds = 'دوس على الكارت اللي عايزه، وبعدين دوس اديني.';
  static const String teddyHelp = 'اختار إزاي أقدر أساعدك.';
  static const String teddyPain = 'قولي فين بيوجعك.';

  // First words of mama's answer.
  static const String mamaNeedsIntro = 'ماما: حاضر! سمعتك:';
  static const String mamaHelpIntro = 'ماما: أنا جاية أساعدك. سمعتك:';
  static const String mamaPainIntro = 'ماما: أنا سامعاك.';

  static String mamaReply({required String intro, required String sentence}) {
    return '$intro $sentence';
  }

  static String progress({required int completed, required int total}) {
    return 'خلّصت $completed من $total';
  }

  // Signs page.
  static const String stepWatch = 'أتفرج';
  static const String stepUnderstand = 'أفهم';
  static const String stepReply = 'أرد';

  static const String teddyWatch = 'اتفرج كويس على اللي بيحصل.';
  static const String teddyMeaning = 'الإشارة دي معناها إيه؟';
  static const String teddyReply = 'دلوقتي ترد بإيه؟';
  static const String teddyResult = 'شوف إيه اللي حصل بعد ردك.';
  static const String teddyFinished = 'برافو! خلّصت كل المواقف.';

  static const String watchHint = 'بيفكر...';
  static const String play = 'شغّل';
  static const String pause = 'إيقاف';
  static const String replay = 'تاني';

  static const String goReply = 'أرد عليه';
  static const String seeResult = 'أشوف النتيجة';
  static const String nextSituation = 'الموقف اللي بعده';
  static const String finish = 'خلّصت';
  static const String allDone = 'برافو! عرفت كل الإشارات.';

  static const String replyQuestion = 'هترد بإيه؟';
  static const String correct = 'صح، برافو!';
  static const String tryAgain = 'جرّب تاني';

  static String meaningQuestion(String sign) => 'يعني إيه $sign؟';
  static String meaningIs(String meaning) => 'يعني: $meaning';

  static String situationOf({required int number, required int total}) {
    return 'الموقف $number من $total';
  }
}
