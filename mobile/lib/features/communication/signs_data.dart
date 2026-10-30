import 'communication_texts.dart';

/// Every emoji of the signs page is here, so changing a picture takes one
/// line. Replace them with images once the team has them.
class SignEmojis {
  const SignEmojis._();

  // The card on the home page of the communication section.
  static const String sectionCard = '👋';

  // The characters.
  static const String me = '🧒';
  static const String friend = '🧒';
  static const String mama = '👩';
  static const String thinking = '🤔';

  // The signs.
  static const String wave = '👋';
  static const String smile = '😊';
  static const String stopHand = '✋';
  static const String thumbsUp = '👍';
  static const String waiting = '⏳';
  static const String thanks = '🙏';
}

/// What a character does with its body. The drawn characters of the signs
/// page animate these poses.
enum SignPose { idle, wave, smile, stopHand, thumbsUp, thanks, thinking }

/// The pose for a sign picture. Pictures with no motion of their own, such
/// as "waiting", leave the character standing calmly.
SignPose poseOf(String sign) {
  return switch (sign) {
    SignEmojis.wave => SignPose.wave,
    SignEmojis.smile => SignPose.smile,
    SignEmojis.stopHand => SignPose.stopHand,
    SignEmojis.thumbsUp => SignPose.thumbsUp,
    SignEmojis.thanks => SignPose.thanks,
    SignEmojis.thinking => SignPose.thinking,
    _ => SignPose.idle,
  };
}

/// One picture card, for example "hello" or "wave back".
class SignOption {
  const SignOption(this.emoji, this.label);

  final String emoji;
  final String label;
}

/// One situation: someone makes a sign, the child says what it means,
/// then picks the sign to answer with.
class SignSituation {
  const SignSituation({
    required this.sender,
    required this.sign,
    required this.lookCaption,
    required this.signCaption,
    required this.meaningOptions,
    required this.correctMeaning,
    required this.replyOptions,
    required this.correctReply,
    required this.senderReaction,
    required this.successText,
  });

  final String sender;
  final String sign;

  // The clip shows: first the look, then the sign, then the child thinks.
  final String lookCaption;
  final String signCaption;

  final List<SignOption> meaningOptions;
  final int correctMeaning;
  final List<SignOption> replyOptions;
  final int correctReply;

  // What the sender shows after the child answers.
  final String senderReaction;
  final String successText;

  SignOption get meaning => meaningOptions[correctMeaning];
  SignOption get reply => replyOptions[correctReply];
}

/// The situations in order. A new situation is one new item here.
/// No word is gendered, so it sounds the same for boys and girls.
const List<SignSituation> signSituations = [
  SignSituation(
    sender: SignEmojis.friend,
    sign: SignEmojis.wave,
    lookCaption: 'صاحبك شافك من بعيد.',
    signCaption: 'صاحبك لوّح لك بإيده.',
    meaningOptions: [
      SignOption('🙂', 'أهلاً'),
      SignOption('✋', 'استنى'),
      SignOption('😢', 'زعل'),
    ],
    correctMeaning: 0,
    replyOptions: [
      SignOption(SignEmojis.wave, 'ألوّح له'),
      SignOption('🙈', 'أبص بعيد'),
      SignOption('🤐', 'أسكت'),
    ],
    correctReply: 0,
    senderReaction: SignEmojis.smile,
    successText: 'لوّحت له وهو فرحان إنك رديت عليه.',
  ),
  SignSituation(
    sender: SignEmojis.friend,
    sign: SignEmojis.smile,
    lookCaption: 'صاحبك بيبص عليك.',
    signCaption: 'صاحبك ابتسم لك.',
    meaningOptions: [
      SignOption('🍽️', 'جوع'),
      SignOption('🙂', 'فرحان'),
      SignOption('😴', 'نوم'),
    ],
    correctMeaning: 1,
    replyOptions: [
      SignOption(SignEmojis.smile, 'أبتسم له'),
      SignOption('😠', 'أزعق'),
      SignOption('🏃', 'أجري'),
    ],
    correctReply: 0,
    senderReaction: SignEmojis.smile,
    successText: 'ابتسمت له، وبقيتوا مبسوطين مع بعض.',
  ),
  SignSituation(
    sender: SignEmojis.mama,
    sign: SignEmojis.stopHand,
    lookCaption: 'ماما بتكلم بابا في التليفون.',
    signCaption: 'ماما رفعت إيدها قدام.',
    meaningOptions: [
      SignOption('🏃', 'تعال'),
      SignOption('😴', 'نوم'),
      SignOption(SignEmojis.waiting, 'استنى شوية'),
    ],
    correctMeaning: 2,
    replyOptions: [
      SignOption(SignEmojis.waiting, 'أستنى مكاني'),
      SignOption('📣', 'أنادي بصوت عالي'),
      SignOption('🏃', 'أجري عليها'),
    ],
    correctReply: 0,
    senderReaction: SignEmojis.smile,
    successText: 'استنيت مكانك بهدوء، وماما قالت لك: برافو!',
  ),
  SignSituation(
    sender: SignEmojis.friend,
    sign: SignEmojis.thumbsUp,
    lookCaption: 'صاحبك شاف رسمتك.',
    signCaption: 'صاحبك رفع صباعه لفوق.',
    meaningOptions: [
      SignOption('👏', 'برافو، حلو'),
      SignOption('😢', 'زعل'),
      SignOption(SignEmojis.stopHand, 'وقّف'),
    ],
    correctMeaning: 0,
    replyOptions: [
      SignOption(SignEmojis.thanks, 'أقول شكراً'),
      SignOption('😠', 'أزعل'),
      SignOption('🙈', 'أستخبى'),
    ],
    correctReply: 0,
    senderReaction: SignEmojis.smile,
    successText: 'قلت شكراً، وصاحبك فرح.',
  ),
];
