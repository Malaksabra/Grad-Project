// Arabic texts of the communication section, kept in one place.
class CommunicationTexts {
  const CommunicationTexts._();

  static const String sectionTitle = 'التواصل';
  static const String whatIWant = 'أقول نفسي في إيه';
  static const String signs = 'الإشارات';

  // Category buttons.
  static const String foodAndDrink = 'أكل وشرب';
  static const String toys = 'ألعاب';
  static const String places = 'أماكن';
  static const String comfort = 'راحة';
  static const String askForHelp = 'أطلب مساعدة';
  static const String tellPain = 'أقول إيه بيوجعني';

  // Pieces of the sentence the child builds.
  static const String iWant = 'أنا عايز';
  static const String painTail = 'بتوجعني';
  static const String please = 'لو سمحت';

  // Buttons and labels.
  static const String pickCard = 'اختار كارت';
  static const String giveMe = 'اديني';
  static const String tellMama = 'أقول لماما';
  static const String sound = 'صوت';
  static const String listen = 'اسمع';
  static const String anotherThing = 'حاجة تانية';

  // What the teddy says before a card is picked, per category.
  static const String teddyNeeds = 'يلا نختار الكارت اللي نفسنا فيه ونقول لماما.';
  static const String teddyHelp = 'لو محتاجين مساعدة، نختار الكارت المناسب ونقول لماما.';
  static const String teddyPain = 'نقول فين بيوجعنا، وأنا هبلّغ ماما.';

  // What mama answers, per category.
  static const String mamaNeedsIntro = 'حاضر!';
  static const String mamaHelpIntro = 'أنا معاك!';
  static const String mamaPainIntro = 'أنا سامعاك، هنريّحك.';

  // The signs page.
  static const String stepWatch = 'أتفرّج';
  static const String stepUnderstand = 'أفهم';
  static const String stepReply = 'أرد';
  static const String teddyWatch = 'نتفرّج الأول: إيه اللي بيحصل؟';
  static const String teddyMeaning = 'إيه معنى الإشارة دي؟';
  static const String teddyReply = 'دورك! اختار إشارة ترد بيها.';
  static const String teddyResult = 'برافو! شوف ردك عمل إيه.';
  static const String teddyFinished = 'عرفنا نفهم الإشارات ونرد عليها!';
  static const String watchHint = 'الإشارة دي ليها معنى. إيه هو؟';
  static const String replyQuestion = 'تعمل إيه عشان ترد عليه؟';
  static const String correct = 'صح!';
  static const String tryAgain = 'مش ده. نجرّب كارت تاني، إحنا قدها.';
  static const String goReply = 'أرد عليه';
  static const String seeResult = 'شوف اللي حصل';
  static const String nextSituation = 'الموقف اللي بعده';
  static const String finish = 'خلصنا';
  static const String allDone = 'خلصت كل المواقف! برافو';
  static const String again = 'نعيد تاني';
  static const String play = 'شغّل';
  static const String pause = 'وقّف';
  static const String replay = 'شوف تاني';

  static String meaningQuestion(String sign) => 'إيه معنى $sign ؟';

  static String meaningIs(String meaning) => 'معناها: $meaning';

  static String situationOf({required int number, required int total}) {
    return 'الموقف $number من $total';
  }

  static String teddyReady(String actionLabel) {
    return 'حلو! دوس على "$actionLabel".';
  }

  static String mamaReply({required String intro, required String sentence}) {
    return 'ماما: $intro سمعتك: $sentence';
  }

  static String progress({required int completed, required int total}) {
    return 'خلّصت $completed من $total';
  }
}
