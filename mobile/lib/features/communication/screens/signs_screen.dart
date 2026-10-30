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

class _StepChips extends StatelessWidget {
  const _StepChips({required this.current});

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
          maxLines: 1, // FIX: Prevents vertical expansion
          overflow: TextOverflow.ellipsis, // FIX: Prevents horizontal overflow
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDone ? Colors.white : _hue.text,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

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
              child: Text(
                bubble ?? '.',
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
                softWrap: true, // FIX: Allows text to wrap instead of pushing width
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(emoji, style: const TextStyle(fontSize: 60)),
      ],
    );
  }
}

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
                        borderRadius: BorderRadius.circular(5),
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

// These dummy classes are to make the code compile in the editor
// if you haven't shared ChoiceGrid or SignHeader.
class _ChoiceGrid extends StatelessWidget {
  final Widget header;
  final String question;
  final List options;
  final int correctIndex;
  final String nextLabel;
  final VoidCallback onNext;
  const _ChoiceGrid({super.key, required this.header, required this.question, required this.options, required this.correctIndex, required this.nextLabel, required this.onNext});
  @override Widget build(BuildContext context) => const SizedBox();
}
class _SignHeader extends StatelessWidget {
  final SignSituation situation;
  final String? meaning;
  const _SignHeader({super.key, required this.situation, this.meaning});
  @override Widget build(BuildContext context) => const SizedBox();
}