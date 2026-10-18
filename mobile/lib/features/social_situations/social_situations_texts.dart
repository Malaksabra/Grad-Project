// Arabic texts of the social situations section, kept in one place.
class SocialSituationsTexts {
  const SocialSituationsTexts._();

  static const String sectionTitle =
      '\u0627\u0644\u0645\u0648\u0627\u0642\u0641 \u0627\u0644\u0627\u062C\u062A\u0645\u0627\u0639\u064A\u0629';
  static const String playWithFriend =
      '\u0623\u0644\u0639\u0628 \u0645\u0639 \u0635\u0627\u062D\u0628\u064A';
  static const String creativeTurns =
      '\u062F\u0648\u0631\u064A \u0648\u062F\u0648\u0631\u0643 \u0627\u0644\u0625\u0628\u062F\u0627\u0639\u064A';
  static const String share = '\u0623\u0634\u0627\u0631\u0643';
  static const String understandFeelings =
      '\u0623\u0641\u0647\u0645 \u0645\u0634\u0627\u0639\u0631 \u063A\u064A\u0631\u064A';

  static String progress({required int completed, required int total}) {
    return '\u062E\u0644\u0651\u0635\u062A $completed \u0645\u0646 $total';
  }
}
