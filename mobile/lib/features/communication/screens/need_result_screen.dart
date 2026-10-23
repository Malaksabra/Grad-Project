import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_models.dart';
import '../communication_texts.dart';
import '../services/speech_service.dart';
import '../widgets/action_buttons.dart';

/// Shown after the child says it: mama answers and the sentence can be
/// heard again.
class NeedResultScreen extends StatelessWidget {
  const NeedResultScreen({
    super.key,
    required this.item,
    required this.sentence,
    required this.mamaReply,
    required this.speechService,
  });

  final NeedItem item;
  final String sentence;
  final String mamaReply;
  final SpeechService speechService;

  static const double _screenPadding = 20;
  static const double _gap = 24;
  static const double _buttonGap = 8;
  static const double _emojiSize = 96;
  static const double _bubbleRadius = 24;
  static const double _bubbleBorderWidth = 2;
  static const double _bubblePadding = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(CommunicationTexts.whatIWant),
        backgroundColor: CommunicationColors.background,
        foregroundColor: CommunicationColors.text,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(_screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item.emoji,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: _emojiSize),
                ),
                const SizedBox(height: _gap),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: CommunicationColors.background,
                    borderRadius: BorderRadius.circular(_bubbleRadius),
                    border: Border.all(
                      color: CommunicationColors.edge,
                      width: _bubbleBorderWidth,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(_bubblePadding),
                    child: Text(
                      mamaReply,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: CommunicationColors.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: _gap),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PrimaryActionButton(
                        label: CommunicationTexts.anotherThing,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: _buttonGap),
                    Expanded(
                      child: SoundButton(
                        onPressed: () => speechService.speak(sentence),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
