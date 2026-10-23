import 'communication_colors.dart';
import 'communication_texts.dart';

/// One card inside the communication section.
class CommunicationActivity {
  const CommunicationActivity({
    required this.title,
    required this.emoji,
    this.hue = CommunicationHue.blue,
  });

  final String title;

  // Colors of the card. Blue unless a card needs another color family.
  final CommunicationHue hue;

  // Temporary picture until the team adds the final images
  // to assets/images/communication.
  final String emoji;
}

/// One card the child can pick, for example an apple or "my head".
class NeedItem {
  const NeedItem({
    required this.emoji,
    required this.label,
    required this.sentence,
  });

  final String emoji;
  final String label;

  // The words this card adds to the sentence, for example "apple".
  final String sentence;
}

/// One button above the cards, such as "food and drink" or "my pain".
/// It also knows how its sentence is built and what the teddy and mama say.
class NeedCategory {
  const NeedCategory({
    required this.title,
    required this.emoji,
    required this.items,
    required this.actionLabel,
    required this.teddyHint,
    required this.mamaIntro,
    this.lead = '',
    this.tail = '',
    this.canSayPlease = true,
  });

  final String title;
  final String emoji;
  final List<NeedItem> items;

  // Text of the main button, for example "give me".
  final String actionLabel;

  // What the teddy says until a card is picked.
  final String teddyHint;

  // First words of mama's answer.
  final String mamaIntro;

  // Words before the card, such as "I want".
  final String lead;

  // Words after the card, such as "hurts".
  final String tail;

  // False when "please" makes no sense, for example "my head hurts".
  final bool canSayPlease;

  /// Builds what the child says, for example "أنا عايز تفاح لو سمحت".
  String sentenceFor(NeedItem item, {required bool isPolite}) {
    final words = [
      lead,
      item.sentence,
      tail,
      if (isPolite && canSayPlease) CommunicationTexts.please,
    ];
    return words.where((word) => word.isNotEmpty).join(' ');
  }
}
