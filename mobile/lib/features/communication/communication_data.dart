import 'communication_models.dart';
import 'signs_data.dart';
import 'communication_texts.dart';

const String communicationSectionEmoji = '💬';

/// The cards on the home page of the communication section.
const List<CommunicationActivity> communicationActivities = [
  CommunicationActivity(title: CommunicationTexts.whatIWant, emoji: '🍽️'),
  CommunicationActivity(
    title: CommunicationTexts.signs,
    emoji: SignEmojis.sectionCard,
  ),
];

/// The category buttons of "what I want", in display order.
/// The first four are things the child wants, then help, then pain.
final List<NeedCategory> needCategories = [
  _wantCategory(
    title: CommunicationTexts.foodAndDrink,
    emoji: '🍎',
    items: const [
      NeedItem(emoji: '🍎', label: 'تفاح', sentence: 'تفاح'),
      NeedItem(emoji: '🍌', label: 'موز', sentence: 'موز'),
      NeedItem(emoji: '🥤', label: 'عصير', sentence: 'عصير'),
      NeedItem(emoji: '💧', label: 'مية', sentence: 'مية'),
      NeedItem(emoji: '🍪', label: 'بسكوت', sentence: 'بسكوت'),
      NeedItem(emoji: '🥛', label: 'لبن', sentence: 'لبن'),
    ],
  ),
  _wantCategory(
    title: CommunicationTexts.toys,
    emoji: '⚽',
    items: const [
      NeedItem(emoji: '🐻', label: 'دبدوب', sentence: 'الدبدوب'),
      NeedItem(emoji: '⚽', label: 'كورة', sentence: 'الكورة'),
      NeedItem(emoji: '🚗', label: 'عربية', sentence: 'العربية'),
      NeedItem(emoji: '🎨', label: 'ألوان', sentence: 'الألوان'),
      NeedItem(emoji: '🎵', label: 'موسيقى', sentence: 'موسيقى'),
      NeedItem(emoji: '🎈', label: 'بالون', sentence: 'بالون'),
    ],
  ),
  _wantCategory(
    title: CommunicationTexts.places,
    emoji: '🏠',
    items: const [
      NeedItem(emoji: '🚽', label: 'الحمام', sentence: 'أروح الحمام'),
      NeedItem(emoji: '🛏️', label: 'أنام', sentence: 'أنام'),
      NeedItem(emoji: '🌳', label: 'الحديقة', sentence: 'أروح الحديقة'),
      NeedItem(emoji: '🏠', label: 'البيت', sentence: 'أروح البيت'),
      NeedItem(emoji: '🚪', label: 'بره', sentence: 'أخرج بره'),
      NeedItem(emoji: '🛋️', label: 'أقعد', sentence: 'أقعد'),
    ],
  ),
  _wantCategory(
    title: CommunicationTexts.comfort,
    emoji: '🤗',
    items: const [
      NeedItem(emoji: '🤗', label: 'حضن', sentence: 'حضن'),
      NeedItem(emoji: '🤫', label: 'هدوء', sentence: 'هدوء'),
      NeedItem(emoji: '😴', label: 'راحة', sentence: 'أرتاح'),
      NeedItem(emoji: '👩', label: 'ماما', sentence: 'ماما'),
      NeedItem(emoji: '👨', label: 'بابا', sentence: 'بابا'),
      NeedItem(emoji: '⏸️', label: 'استراحة', sentence: 'استراحة'),
    ],
  ),
  // The help sentences have no "I", so they sound the same for boys and girls.
  const NeedCategory(
    title: CommunicationTexts.askForHelp,
    emoji: '🙋',
    actionLabel: CommunicationTexts.tellMama,
    teddyHint: CommunicationTexts.teddyHelp,
    mamaIntro: CommunicationTexts.mamaHelpIntro,
    items: [
      NeedItem(emoji: '🙋', label: 'ساعدني', sentence: 'ساعدني'),
      NeedItem(emoji: '🧰', label: 'افتح لي', sentence: 'افتح لي'),
      NeedItem(emoji: '🤲', label: 'هات لي', sentence: 'هات لي'),
      NeedItem(emoji: '❓', label: 'اشرح لي', sentence: 'اشرح لي'),
      NeedItem(emoji: '✋', label: 'استنى', sentence: 'استنى شوية'),
      NeedItem(emoji: '👀', label: 'وريني', sentence: 'وريني'),
    ],
  ),
  const NeedCategory(
    title: CommunicationTexts.tellPain,
    emoji: '🤕',
    actionLabel: CommunicationTexts.tellMama,
    teddyHint: CommunicationTexts.teddyPain,
    mamaIntro: CommunicationTexts.mamaPainIntro,
    tail: CommunicationTexts.painTail,
    canSayPlease: false,
    items: [
      NeedItem(emoji: '🤕', label: 'راسي', sentence: 'راسي'),
      NeedItem(emoji: '👂', label: 'ودني', sentence: 'ودني'),
      NeedItem(emoji: '🦷', label: 'سناني', sentence: 'سناني'),
      NeedItem(emoji: '🤢', label: 'بطني', sentence: 'بطني'),
      NeedItem(emoji: '💪', label: 'إيدي', sentence: 'إيدي'),
      NeedItem(emoji: '🦵', label: 'رجلي', sentence: 'رجلي'),
    ],
  ),
];

/// The four "I want ..." categories share the same words and buttons.
NeedCategory _wantCategory({
  required String title,
  required String emoji,
  required List<NeedItem> items,
}) {
  return NeedCategory(
    title: title,
    emoji: emoji,
    items: items,
    lead: CommunicationTexts.iWant,
    actionLabel: CommunicationTexts.giveMe,
    teddyHint: CommunicationTexts.teddyNeeds,
    mamaIntro: CommunicationTexts.mamaNeedsIntro,
  );
}
