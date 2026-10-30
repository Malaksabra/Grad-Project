import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_data.dart';
import '../communication_models.dart';
import '../communication_texts.dart';
import '../services/flutter_tts_speech_service.dart';
import '../services/speech_service.dart';
import '../widgets/action_buttons.dart';
import '../widgets/need_card_grid.dart';
import '../widgets/selection_strip.dart';
import '../widgets/teddy_guide.dart';
import 'need_result_screen.dart';
import 'pain_screens.dart';

/// The page where the child says what they want: needs, help and pain.
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

  /// The pain category has its own flow with body areas.
  bool get _isPainCategory => _category.title == CommunicationTexts.tellPain;

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  String _sentenceOf(NeedItem item) {
    return _category.sentenceFor(item, isPolite: _isPolite);
  }

  void _selectCategory(int index) {
    setState(() {
      _categoryIndex = index;
      _selectedItem = null;
      _isPolite = false;
    });
  }

  /// Opens the result page, then clears the choice for the next request.
  Future<void> _sendToMama(NeedItem item) async {
    final category = _category;
    final sentence = _sentenceOf(item);

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NeedResultScreen(
          item: item,
          sentence: sentence,
          mamaIntro: category.mamaIntro,
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
    final teddyMessage = (selectedItem == null || _isPainCategory)
        ? category.teddyHint
        : _sentenceOf(selectedItem);

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
            if (_isPainCategory)
              PainBodyMap(speechService: _speech)
            else ...[
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
                          : () => _sendToMama(selectedItem),
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
              NeedCardGrid(
                items: category.items,
                selectedItem: selectedItem,
                onItemSelected: (item) => setState(() => _selectedItem = item),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
