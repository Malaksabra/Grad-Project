import 'dart:async';

import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_texts.dart';
import '../services/speech_service.dart';
import '../signs_data.dart';
import '../widgets/action_buttons.dart';
import '../widgets/teddy_guide.dart';

// The signs page uses the blue of the communication section.
const CommunicationHue _hue = CommunicationHue.blue;
const double _gap = 16;
const double _panelRadius = 26;
const double _borderWidth = 2;

/// Understand a sign and answer it, in one flow: watch the clip, say what
/// the sign means, pick the sign to answer with, then see what happens.
class SignsScreen extends StatefulWidget {
  const SignsScreen({super.key});

  @override
  State<SignsScreen> createState() => _SignsScreenState();
}

enum _Step { watch, meaning, reply, result }

class _SignsScreenState extends State<SignsScreen> {
  static const double _stageRadius = 30;
  static const double _stageBorderAlpha = 0.45;

  final SpeechService _speech = FlutterTtsSpeechService();

  int _index = 0;
  _Step _step = _Step.watch;
  bool _isFinished = false;

  SignSituation get _situation => signSituations[_index];
  bool get _isLastSituation => _index == signSituations.length - 1;

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  void _goTo(_Step step) => setState(() => _step = step);

  void _onClipFinished() {
    // Replaying the clip later must not send the child back a step.
    if (_step == _Step.watch) _goTo(_Step.meaning);
  }

  void _nextSituation() {
    setState(() {
      if (_isLastSituation) {
        _isFinished = true;
      } else {
        _index++;
        _step = _Step.watch;
      }
    });
  }

  void _restart() {
    setState(() {
      _index = 0;
      _step = _Step.watch;
      _isFinished = false;
    });
  }

  String get _teddyMessage {
    if (_isFinished) return CommunicationTexts.teddyFinished;
    return switch (_step) {
      _Step.watch => CommunicationTexts.teddyWatch,
      _Step.meaning => CommunicationTexts.teddyMeaning,
      _Step.reply => CommunicationTexts.teddyReply,
      _Step.result => CommunicationTexts.teddyResult,
    };
  }

  @override
  Widget build(BuildContext context) {
    final message = _teddyMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text(CommunicationTexts.signs),
        backgroundColor: _hue.background,
        foregroundColor: _hue.text,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TeddyGuide(
              message: message,
              hue: _hue,
              onListen: () => _speech.speak(message),
            ),
            const SizedBox(height: _gap),
            DecoratedBox(
              decoration: BoxDecoration(
                color: CommunicationColors.stage,
                borderRadius: BorderRadius.circular(_stageRadius),
                border: Border.all(
                  color: _hue.edge.withValues(alpha: _stageBorderAlpha),
                  width: _borderWidth,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(_gap),
                child: _isFinished ? _buildFinished() : _buildSituation(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSituation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          CommunicationTexts.situationOf(
            number: _index + 1,
            total: signSituations.length,
          ),
          style: TextStyle(color: _hue.text),
        ),
        const SizedBox(height: 8),
        _StepChips(current: _step.index),
        const SizedBox(height: _gap),
        // The key restarts the clip for every new situation.
        _Clip(
          key: ValueKey(_index),
          situation: _situation,
          onFinished: _onClipFinished,
        ),
        const SizedBox(height: _gap),
        _buildStepBody(),
      ],
    );
  }

  Widget _buildStepBody() {
    final situation = _situation;

    return switch (_step) {
      _Step.watch => const SizedBox.shrink(),
      _Step.meaning => _ChoiceGrid(
        key: ValueKey('meaning-$_index'),
        header: _SignHeader(situation: situation),
        question: CommunicationTexts.meaningQuestion(situation.sign),
        options: situation.meaningOptions,
        correctIndex: situation.correctMeaning,
        nextLabel: CommunicationTexts.goReply,
        onNext: () => _goTo(_Step.reply),
      ),
      _Step.reply => _ChoiceGrid(
        key: ValueKey('reply-$_index'),
        header: _SignHeader(
          situation: situation,
          meaning: situation.meaning.label,
        ),
        question: CommunicationTexts.replyQuestion,
        options: situation.replyOptions,
        correctIndex: situation.correctReply,
        nextLabel: CommunicationTexts.seeResult,
        onNext: () => _goTo(_Step.result),
      ),
      _Step.result => _buildResult(situation),
    };
  }

  Widget _buildResult(SignSituation situation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Panel(
          caption: situation.successText,
          child: _Stage(
            senderEmoji: situation.sender,
            senderBubble: situation.senderReaction,
            myBubble: situation.reply.emoji,
          ),
        ),
        const SizedBox(height: _gap),
        PrimaryActionButton(
          label: _isLastSituation
              ? CommunicationTexts.finish
              : CommunicationTexts.nextSituation,
          onPressed: _nextSituation,
          hue: _hue,
        ),
      ],
    );
  }

  Widget _buildFinished() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '⭐',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 64),
        ),
        const SizedBox(height: 8),
        Text(
          CommunicationTexts.allDone,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: _hue.text),
        ),
        const SizedBox(height: _gap),
        PrimaryActionButton(
          label: CommunicationTexts.again,
          onPressed: _restart,
          hue: _hue,
        ),
      ],
    );
  }
}

/// The three small steps above the clip: watch, understand, reply.
class _StepChips extends StatelessWidget {
  const _StepChips({required this.current});

  // 0 = watch, 1 = understand, 2 = reply, 3 = all done.
  final int current;

  static const List<String> _labels = [
    CommunicationTexts.stepWatch,
    CommunicationTexts.stepUnderstand,
    CommunicationTexts.stepReply,
  ];
  static const Color _idleEdge = Color(0xFFE2EDF8);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _chip(context, i)),
        ],
      ],
    );
  }

  Widget _chip(BuildContext context, int i) {
    final isDone = i < current;
    final isCurrent = i == current;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDone ? _hue.text : (isCurrent ? _hue.background : Colors.white),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDone ? _hue.text : (isCurrent ? _hue.edge : _idleEdge),
          width: _borderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Text(
          '${i + 1} ${_labels[i]}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDone ? Colors.white : _hue.text,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// A white rounded box with a blue edge and an optional caption.
class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.caption});

  final Widget child;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(_panelRadius);

    return ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: Border.all(color: _hue.edge, width: _borderWidth),
        ),
        child: Column(
          children: [
            child,
            if (caption != null)
              Padding(
                padding: const EdgeInsets.all(_gap),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    caption!,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: _hue.text),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Two characters side by side, each with an optional speech bubble.
/// The sender is on the right (first in Arabic), the child on the left.
class _Stage extends StatelessWidget {
  const _Stage({required this.senderEmoji, this.senderBubble, this.myBubble});

  final String senderEmoji;
  final String? senderBubble;
  final String? myBubble;

  static const double _minHeight = 210;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _minHeight),
      color: _hue.background,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, _gap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _Character(senderEmoji, senderBubble)),
          Expanded(child: _Character(SignEmojis.me, myBubble)),
        ],
      ),
    );
  }
}

class _Character extends StatelessWidget {
  const _Character(this.emoji, this.bubble);

  final String emoji;
  final String? bubble;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The bubble keeps its space even when empty, so nothing jumps.
        Visibility(
          visible: bubble != null,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Text(bubble ?? '.', style: const TextStyle(fontSize: 24)),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(emoji, style: const TextStyle(fontSize: 60)),
      ],
    );
  }
}

/// The short clip: look, sign, think. It starts by itself, can be paused
/// and replayed, and tells the page when it reaches the end.
class _Clip extends StatefulWidget {
  const _Clip({super.key, required this.situation, required this.onFinished});

  final SignSituation situation;
  final VoidCallback onFinished;

  @override
  State<_Clip> createState() => _ClipState();
}

class _ClipState extends State<_Clip> {
  static const Duration _frameDuration = Duration(milliseconds: 2900);
  static const Duration _startDelay = Duration(milliseconds: 500);
  static const int _signFrame = 1;
  static const int _thinkFrame = 2;
  static const int _lastFrame = _thinkFrame;

  Timer? _timer;
  int _frame = 0;
  bool _isPlaying = false;

  bool get _isFinished => _frame == _lastFrame && !_isPlaying;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_startDelay, _play);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _play() {
    if (!mounted) return;
    setState(() {
      if (_frame == _lastFrame) _frame = 0;
      _isPlaying = true;
    });
    _schedule();
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isPlaying = false);
  }

  void _schedule() {
    _timer = Timer(_frameDuration, () {
      if (!mounted) return;
      if (_frame == _lastFrame) {
        setState(() => _isPlaying = false);
        widget.onFinished();
      } else {
        setState(() => _frame++);
        _schedule();
      }
    });
  }

  String get _caption => switch (_frame) {
    _signFrame => widget.situation.signCaption,
    _thinkFrame => CommunicationTexts.watchHint,
    _ => widget.situation.lookCaption,
  };

  @override
  Widget build(BuildContext context) {
    final situation = widget.situation;
    final (icon, tooltip) = _isPlaying
        ? (Icons.pause_rounded, CommunicationTexts.pause)
        : _isFinished
        ? (Icons.replay_rounded, CommunicationTexts.replay)
        : (Icons.play_arrow_rounded, CommunicationTexts.play);

    return _Panel(
      caption: _caption,
      child: Column(
        children: [
          _Stage(
            senderEmoji: situation.sender,
            senderBubble: _frame == _signFrame ? situation.sign : null,
            myBubble: _frame == _thinkFrame ? SignEmojis.thinking : null,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(_gap, 0, _gap, _gap),
            child: Row(
              children: [
                IconButton.filled(
                  tooltip: tooltip,
                  style: IconButton.styleFrom(backgroundColor: _hue.text),
                  onPressed: _isPlaying ? _pause : _play,
                  icon: Icon(icon),
                ),
                const SizedBox(width: 12),
                for (var i = 0; i <= _lastFrame; i++)
                  Expanded(
                    child: Container(
                      height: 10,
                      margin: EdgeInsets.only(left: i < _lastFrame ? 6 : 0),
                      decoration: BoxDecoration(
                        color: i <= _frame
                            ? _hue.edge
                            : CommunicationColors.stage,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The sender and the sign, shown above a question as a reminder.
class _SignHeader extends StatelessWidget {
  const _SignHeader({required this.situation, this.meaning});

  final SignSituation situation;

  // Shown next to the pictures once the child knows what the sign means.
  final String? meaning;

  static const TextStyle _emojiStyle = TextStyle(fontSize: 48);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(situation.sender, style: _emojiStyle),
            const SizedBox(width: 14),
            Text(situation.sign, style: _emojiStyle),
            if (meaning != null) ...[
              const SizedBox(width: 14),
              Flexible(
                child: Text(
                  CommunicationTexts.meaningIs(meaning!),
                  style: TextStyle(color: _hue.text),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A question with picture cards. A wrong card fades and the child tries
/// again; the right card is marked and a button appears to go on.
class _ChoiceGrid extends StatefulWidget {
  const _ChoiceGrid({
    super.key,
    required this.header,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.nextLabel,
    required this.onNext,
  });

  final Widget header;
  final String question;
  final List<SignOption> options;
  final int correctIndex;
  final String nextLabel;
  final VoidCallback onNext;

  @override
  State<_ChoiceGrid> createState() => _ChoiceGridState();
}

class _ChoiceGridState extends State<_ChoiceGrid> {
  static const double _baseCardHeight = 112;
  static const int _columnCount = 3;

  final Set<int> _wrong = {};
  bool _isRight = false;

  void _pick(int index) {
    if (_isRight) return;
    setState(() {
      if (index == widget.correctIndex) {
        _isRight = true;
      } else {
        _wrong.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.textScalerOf(context).scale(_baseCardHeight);
    final note = _isRight
        ? CommunicationTexts.correct
        : (_wrong.isEmpty ? '' : CommunicationTexts.tryAgain);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.header,
        const SizedBox(height: 12),
        Text(
          widget.question,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: _hue.text),
        ),
        const SizedBox(height: 12),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _columnCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: cardHeight,
          ),
          children: [
            for (var i = 0; i < widget.options.length; i++)
              _SignCard(
                option: widget.options[i],
                isRight: _isRight && i == widget.correctIndex,
                isWrong: _wrong.contains(i),
                onTap: () => _pick(i),
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Announced to screen readers when it changes.
        Semantics(
          liveRegion: true,
          child: Text(note, style: TextStyle(color: _hue.text)),
        ),
        if (_isRight) ...[
          const SizedBox(height: 8),
          PrimaryActionButton(
            label: widget.nextLabel,
            onPressed: widget.onNext,
            hue: _hue,
          ),
        ],
      ],
    );
  }
}

/// One tappable picture card with a solid bottom edge.
class _SignCard extends StatelessWidget {
  const _SignCard({
    required this.option,
    required this.isRight,
    required this.isWrong,
    required this.onTap,
  });

  final SignOption option;
  final bool isRight;
  final bool isWrong;
  final VoidCallback onTap;

  static const double _radius = 24;
  static const double _edgeHeight = 5;
  static const double _wrongOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);

    return Opacity(
      opacity: isWrong ? _wrongOpacity : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isRight ? _hue.background : Colors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: isRight ? _hue.text : _hue.edge,
            width: _borderWidth,
          ),
          // A shadow without blur gives the card its solid bottom edge.
          boxShadow: [
            BoxShadow(color: _hue.edge, offset: const Offset(0, _edgeHeight)),
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
                Text(option.emoji, style: const TextStyle(fontSize: 40)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    option.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: _hue.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
