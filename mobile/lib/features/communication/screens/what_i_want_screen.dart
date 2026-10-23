import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_data.dart';
import '../communication_models.dart';
import '../communication_texts.dart';
import '../services/speech_service.dart';
import '../widgets/action_buttons.dart';
import '../widgets/need_card_grid.dart';
import '../widgets/selection_strip.dart';
import '../widgets/teddy_guide.dart';
import 'need_result_screen.dart';

/// The page where the child says what they want, asks for help,
/// or tells what hurts. Each one is a category of cards.
class WhatIWantScreen extends StatefulWidget {
  const WhatIWantScreen({super.key});

  @override
  State<WhatIWantScreen> createState() => _WhatIWantScreenState();
}

class _WhatIWantScreenState extends State<WhatIWantScreen> {
  static const double _screenPadding = 20;
  static const double _gap = 16;
  static const double _chipGap = 8;

  final SpeechService _speech = FlutterTtsSpeechService();

  int _categoryIndex = 0;
  NeedItem? _selectedItem;
  bool _isPolite = false;

  NeedCategory get _category => needCategories[_categoryIndex];

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  String _sentenceOf(NeedItem item) {
    return _category.sentenceFor(item, isPolite: _isPolite);
  }

  void _selectCategory(int index) {
    if (index == _categoryIndex) return;
    setState(() {
      _categoryIndex = index;
      // A card from another category must not stay picked.
      _selectedItem = null;
      _isPolite = false;
    });
  }

  /// Opens the result page, then clears the choice for the next request.
  Future<void> _tellMama(NeedItem item) async {
    final sentence = _sentenceOf(item);
    final mamaReply = CommunicationTexts.mamaReply(
      intro: _category.mamaIntro,
      sentence: sentence,
    );

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NeedResultScreen(
          item: item,
          sentence: sentence,
          mamaReply: mamaReply,
          speechService: _speech,
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      _selectedItem = null;
      _isPolite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = _category;
    final selectedItem = _selectedItem;
    final teddyMessage = selectedItem == null
        ? category.teddyHint
        : CommunicationTexts.teddyReady(category.actionLabel);

    return Scaffold(
      appBar: AppBar(
        title: const Text(CommunicationTexts.whatIWant),
        backgroundColor: CommunicationColors.background,
        foregroundColor: CommunicationColors.text,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(_screenPadding),
          children: [
            TeddyGuide(
              message: teddyMessage,
              onListen: () => _speech.speak(teddyMessage),
            ),
            const SizedBox(height: _gap),
            SelectionStrip(
              category: category,
              selectedItem: selectedItem,
              isPolite: _isPolite,
              onPoliteToggled: () => setState(() => _isPolite = !_isPolite),
            ),
            const SizedBox(height: _gap),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PrimaryActionButton(
                    label: category.actionLabel,
                    onPressed: selectedItem == null
                        ? null
                        : () => _tellMama(selectedItem),
                  ),
                ),
                const SizedBox(width: _chipGap),
                Expanded(
                  child: SoundButton(
                    onPressed: selectedItem == null
                        ? null
                        : () => _speech.speak(_sentenceOf(selectedItem)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: _gap),
            Wrap(
              spacing: _chipGap,
              runSpacing: _chipGap,
              children: [
                for (var index = 0; index < needCategories.length; index++)
                  CategoryChip(
                    title: needCategories[index].title,
                    emoji: needCategories[index].emoji,
                    isSelected: index == _categoryIndex,
                    onTap: () => _selectCategory(index),
                  ),
              ],
            ),
            const SizedBox(height: _gap),
            NeedCardGrid(
              items: category.items,
              selectedItem: selectedItem,
              onItemSelected: (item) => setState(() => _selectedItem = item),
            ),
          ],
        ),
      ),
    );
  }
}
