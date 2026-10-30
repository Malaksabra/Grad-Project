import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_texts.dart';
import '../services/speech_service.dart';
import '../widgets/action_buttons.dart';

// The "my pain" flow, all in one file:
// 1. PainBodyMap: a body figure, shown inside the "what I want" page.
//    A tap on the head, belly, an arm or a leg opens that area.
// 2. PainAreaScreen: the parts of one area and how much it hurts.
// 3. PainResultScreen: mama answers.

/// One picture card, for example "my eye" or "a lot".
class PainOption {
  const PainOption(this.emoji, this.label);

  final String emoji;
  final String label;
}

/// The places on the body figure that can be tapped.
enum BodyZone { head, torso, arms, legs }

/// One body area with the parts that can hurt inside it.
class PainArea {
  const PainArea({
    required this.zone,
    required this.emoji,
    required this.label,
    required this.parts,
  });

  // The place on the body figure that opens this area.
  final BodyZone zone;
  final String emoji;
  final String label;
  final List<PainOption> parts;
}

/// The body areas in display order. A new area or part is one new item here.
const List<PainArea> painAreas = [
  PainArea(
    zone: BodyZone.head,
    emoji: '🙂',
    label: 'وشي',
    parts: [
      PainOption('🤕', 'راسي'),
      PainOption('👁️', 'عيني'),
      PainOption('👂', 'ودني'),
      PainOption('👃', 'مناخيري'),
      PainOption('🦷', 'سناني'),
    ],
  ),
  PainArea(
    zone: BodyZone.torso,
    emoji: '',
    label: 'بطني',
    parts: [
      PainOption('🤢', 'بطني'),
      PainOption('🧍', 'ضهري'),
    ],
  ),
  PainArea(
    zone: BodyZone.arms,
    emoji: '',
    label: 'إيدي',
    parts: [
      PainOption('💪', 'دراعي'),
      PainOption('✋', 'إيدي'),
      PainOption('👆', 'صوابعي'),
    ],
  ),
  PainArea(
    zone: BodyZone.legs,
    emoji: '',
    label: 'رجلي',
    parts: [
      PainOption('🦵', 'رجلي'),
      PainOption('🦶', 'قدمي'),
    ],
  ),
];

/// How much it hurts.
const List<PainOption> painLevels = [
  PainOption('🙂', 'شوية'),
  PainOption('😟', 'متوسط'),
  PainOption('😣', 'كتير'),
];

const String _pickArea = 'دوس على المكان اللي بيوجعك';
const String _wherePart = '1. فين بيوجعني؟';
const String _howMuch = '2. قد إيه بيوجعني؟';
const String _pickBoth = 'اختار المكان وقد إيه';
const String _again = 'نعيد';
const String _calmDown = 'نقعد في مكان هادي ونتنفس براحة.';

/// What the child says, for example "راسي بتوجعني كتير".
String _painSentence(PainOption part, PainOption level) {
  return '${part.label} بتوجعني ${level.label}';
}

/// What mama answers, for example "ماما: أنا سامعاك. راسي بتوجعك كتير. ...".
String _mamaReply(PainOption part, PainOption level) {
  return 'ماما: أنا سامعاك. ${part.label} بتوجعك ${level.label}. هنريّحك.';
}

/// A body figure. A tap on the head, belly, an arm or a leg opens the page
/// of that area, where the child picks the exact part and how much it hurts.
class PainBodyMap extends StatelessWidget {
  const PainBodyMap({super.key, required this.speechService});

  final SpeechService speechService;

  // The figure is drawn on a fixed canvas and scaled to the screen width.
  static const double _canvasWidth = 200;
  static const double _canvasHeight = 340;
  static const double _maxFigureWidth = 280;
  static const double _gap = 12;

  static const double _emojiSize = 28;

  void _openArea(BuildContext context, BodyZone zone) {
    final area = painAreas.firstWhere((area) => area.zone == zone);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PainAreaScreen(area: area, speechService: speechService),
      ),
    );
  }

  /// One tappable piece of the figure, placed on the canvas.
  Widget _piece(
    BuildContext context, {
    required BodyZone zone,
    required Rect rect,
    double radius = 16,
    bool isCircle = false,
    Widget? child,
  }) {
    final label = painAreas.firstWhere((area) => area.zone == zone).label;
    return Positioned.fromRect(
      rect: rect,
      child: _BodyPiece(
        label: label,
        radius: radius,
        isCircle: isCircle,
        onTap: () => _openArea(context, zone),
        child: child,
      ),
    );
  }

  Widget _emoji(BodyZone zone) {
    final emoji = painAreas.firstWhere((area) => area.zone == zone).emoji;
    return Text(emoji, style: const TextStyle(fontSize: _emojiSize));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _pickArea,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: CommunicationColors.text),
        ),
        const SizedBox(height: _gap),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxFigureWidth),
            child: AspectRatio(
              aspectRatio: _canvasWidth / _canvasHeight,
              child: FittedBox(
                child: SizedBox(
                  width: _canvasWidth,
                  height: _canvasHeight,
                  child: Stack(
                    children: [
                      // Legs.
                      _piece(
                        context,
                        zone: BodyZone.legs,
                        rect: const Rect.fromLTWH(52, 226, 44, 112),
                        radius: 22,
                        child: _emoji(BodyZone.legs),
                      ),
                      _piece(
                        context,
                        zone: BodyZone.legs,
                        rect: const Rect.fromLTWH(104, 226, 44, 112),
                        radius: 22,
                        child: _emoji(BodyZone.legs),
                      ),
                      // Arms.
                      _piece(
                        context,
                        zone: BodyZone.arms,
                        rect: const Rect.fromLTWH(4, 104, 40, 112),
                        child: _emoji(BodyZone.arms),
                      ),
                      _piece(
                        context,
                        zone: BodyZone.arms,
                        rect: const Rect.fromLTWH(156, 104, 40, 112),
                        child: _emoji(BodyZone.arms),
                      ),
                      // Belly and back.
                      _piece(
                        context,
                        zone: BodyZone.torso,
                        rect: const Rect.fromLTWH(50, 98, 100, 128),
                        radius: 30,
                        child: _emoji(BodyZone.torso),
                      ),
                      // Head with a simple face.
                      _piece(
                        context,
                        zone: BodyZone.head,
                        rect: const Rect.fromLTWH(55, 0, 90, 90),
                        isCircle: true,
                        child: const _Face(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One piece of the body figure: a white shape with a blue outline.
class _BodyPiece extends StatelessWidget {
  const _BodyPiece({
    required this.label,
    required this.radius,
    required this.isCircle,
    required this.onTap,
    this.child,
  });

  final String label;
  final double radius;
  final bool isCircle;
  final VoidCallback onTap;
  final Widget? child;

  static const double _borderWidth = 3;
  static const Color _pressColor = Color(0x668FC1EA);

  @override
  Widget build(BuildContext context) {
    const side = BorderSide(
      color: CommunicationColors.edge,
      width: _borderWidth,
    );
    final ShapeBorder shape = isCircle
        ? const CircleBorder(side: side)
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: side,
          );

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.white,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          splashColor: _pressColor,
          highlightColor: _pressColor,
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Two eyes and a mouth for the head of the body figure.
class _Face extends StatelessWidget {
  const _Face();

  static const double _eyeSize = 9;
  static const Color _color = CommunicationColors.edge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        children: [
          Positioned(left: 28, top: 36, child: _dot()),
          Positioned(left: 53, top: 36, child: _dot()),
          Positioned(
            left: 33,
            top: 54,
            child: Container(
              width: 24,
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _color, width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: _eyeSize,
      height: _eyeSize,
      decoration: const BoxDecoration(color: _color, shape: BoxShape.circle),
    );
  }
}

/// The second page: pick the part, then how much it hurts.
class PainAreaScreen extends StatefulWidget {
  const PainAreaScreen({
    super.key,
    required this.area,
    required this.speechService,
  });

  final PainArea area;
  final SpeechService speechService;

  @override
  State<PainAreaScreen> createState() => _PainAreaScreenState();
}

class _PainAreaScreenState extends State<PainAreaScreen> {
  static const double _screenPadding = 20;
  static const double _gap = 16;
  static const double _buttonGap = 8;

  PainOption? _part;
  PainOption? _level;

  /// Opens the result page. "Again" there brings the child back to the
  /// body areas; going back with the arrow stays here.
  Future<void> _tellMama(PainOption part, PainOption level) async {
    final startAgain = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PainResultScreen(
          part: part,
          level: level,
          speechService: widget.speechService,
        ),
      ),
    );
    if (startAgain == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final part = _part;
    final level = _level;
    // Both picks together, or null while one of them is missing.
    final choice = (part != null && level != null) ? (part, level) : null;
    final headingStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: CommunicationColors.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text(CommunicationTexts.tellPain),
        backgroundColor: CommunicationColors.background,
        foregroundColor: CommunicationColors.text,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(_screenPadding),
          children: [
            Text(_wherePart, style: headingStyle),
            const SizedBox(height: _gap),
            _PickGrid(
              options: widget.area.parts,
              selected: part,
              onSelected: (option) => setState(() => _part = option),
            ),
            const SizedBox(height: _gap),
            Text(_howMuch, style: headingStyle),
            const SizedBox(height: _gap),
            _PickGrid(
              options: painLevels,
              selected: level,
              onSelected: (option) => setState(() => _level = option),
            ),
            const SizedBox(height: _gap),
            _Strip(
              text: choice == null
                  ? _pickBoth
                  : _painSentence(choice.$1, choice.$2),
            ),
            const SizedBox(height: _gap),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PrimaryActionButton(
                    label: CommunicationTexts.tellMama,
                    onPressed: choice == null
                        ? null
                        : () => _tellMama(choice.$1, choice.$2),
                  ),
                ),
                const SizedBox(width: _buttonGap),
                Expanded(
                  child: SoundButton(
                    onPressed: choice == null
                        ? null
                        : () => widget.speechService.speak(
                            _painSentence(choice.$1, choice.$2),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The last page, after everything is chosen: mama answers.
class PainResultScreen extends StatelessWidget {
  const PainResultScreen({
    super.key,
    required this.part,
    required this.level,
    required this.speechService,
  });

  final PainOption part;
  final PainOption level;
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(CommunicationTexts.tellPain),
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
                  '${part.emoji} ${level.emoji}',
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
                      _mamaReply(part, level),
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        color: CommunicationColors.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: _gap),
                Text(
                  _calmDown,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: CommunicationColors.text,
                  ),
                ),
                const SizedBox(height: _gap),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PrimaryActionButton(
                        label: _again,
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ),
                    const SizedBox(width: _buttonGap),
                    Expanded(
                      child: SoundButton(
                        onPressed: () => speechService.speak(
                          _painSentence(part, level),
                        ),
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

/// Picture cards, three in a row. The page scrolls, not the grid.
class _PickGrid extends StatelessWidget {
  const _PickGrid({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<PainOption> options;
  final PainOption? selected;
  final ValueChanged<PainOption> onSelected;

  static const double _gap = 12;
  static const double _baseCardHeight = 112;
  static const int _columnCount = 3;

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.textScalerOf(context).scale(_baseCardHeight);

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columnCount,
        mainAxisSpacing: _gap,
        crossAxisSpacing: _gap,
        mainAxisExtent: cardHeight,
      ),
      children: [
        for (final option in options)
          _PainCard(
            option: option,
            isSelected: option == selected,
            onTap: () => onSelected(option),
          ),
      ],
    );
  }
}

/// One tappable card with a solid bottom edge, like the other cards of the
/// communication section.
class _PainCard extends StatelessWidget {
  const _PainCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final PainOption option;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _radius = 24;
  static const double _borderWidth = 2;
  static const double _edgeHeight = 5;
  static const double _emojiSize = 40;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? CommunicationColors.background : Colors.white,
        borderRadius: borderRadius,
        border: Border.all(
          color: isSelected
              ? CommunicationColors.text
              : CommunicationColors.edge,
          width: _borderWidth,
        ),
        // A shadow without blur gives the card its solid bottom edge.
        boxShadow: const [
          BoxShadow(
            color: CommunicationColors.edge,
            offset: Offset(0, _edgeHeight),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(option.emoji, style: const TextStyle(fontSize: _emojiSize)),
              Text(
                option.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: CommunicationColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The sentence the child is building, shown before it is sent.
class _Strip extends StatelessWidget {
  const _Strip({required this.text});

  final String text;

  static const double _radius = 24;
  static const double _borderWidth = 2;
  static const double _padding = 16;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: CommunicationColors.edge, width: _borderWidth),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: CommunicationColors.text),
        ),
      ),
    );
  }
}
