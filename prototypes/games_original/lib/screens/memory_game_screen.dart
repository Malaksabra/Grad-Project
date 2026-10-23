import 'dart:async';
import 'package:flutter/material.dart';
import 'game_settings.dart';
import 'package:project_games/theme.dart';

const _pool = [
  'assets/apple.jpg',
  'assets/banana.jpg',
  'assets/mango.jpg',
  'assets/orange.jpg',
  'assets/strawberry.jpg',
  'assets/watermelon.jpg',
];

class MemoryCard {
  final int id;
  final String image;
  bool isFaceUp = false;
  bool isMatched = false;
  MemoryCard(this.id, this.image);
}

enum _Status { playing, won, timeUp }

class MemoryGameScreen extends StatefulWidget {
  final int level; // 0 / 1 / 2
  final int seconds; // وقت المستوى
  final VoidCallback onExit; // رجوع لشاشة المستويات
  const MemoryGameScreen({
    super.key,
    required this.level,
    required this.seconds,
    required this.onExit,
  });

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<MemoryCard> cards;
  int? firstIndex;
  bool locked = false;
  bool started = false;
  _Status status = _Status.playing;
  late int remaining;
  String message = '';
  Timer? _tick;
  Timer? _flip;

  int get pairs => kLevelPairs[widget.level];

  @override
  void initState() {
    super.initState();
    _newRound();
  }

  @override
  void dispose() {
    _tick?.cancel();
    _flip?.cancel();
    super.dispose();
  }

  void _newRound() {
    _tick?.cancel();
    _flip?.cancel();
    final picked = ([..._pool]..shuffle()).take(pairs).toList();
    final deck = [...picked, ...picked]..shuffle();
    cards = [for (var i = 0; i < deck.length; i++) MemoryCard(i, deck[i])];
    firstIndex = null;
    locked = false;
    started = false;
    status = _Status.playing;
    remaining = widget.seconds;
    message = 'الوقت بيبدأ لما تقلب أول كارت.';
  }

  void _startClock() {
    started = true;
    _tick = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        remaining--;
        if (remaining <= 0) {
          remaining = 0;
          status = _Status.timeUp;
          t.cancel();
        }
      });
    });
  }

  void _onTap(int i) {
    final c = cards[i];
    if (status != _Status.playing || locked || c.isFaceUp || c.isMatched) {
      return;
    }
    if (!started) _startClock();

    setState(() {
      c.isFaceUp = true;
      if (message.startsWith('الوقت')) message = 'اقلب كارت تاني.';
    });

    if (firstIndex == null) {
      firstIndex = i;
      return;
    }
    final first = firstIndex!;
    firstIndex = null;

    if (cards[first].image == c.image) {
      setState(() {
        cards[first].isMatched = true;
        c.isMatched = true;
        message = 'زوج حلو!';
        if (cards.every((x) => x.isMatched)) {
          status = _Status.won;
          _tick?.cancel();
        }
      });
    } else {
      setState(() {
        locked = true;
        message = 'مش زي بعض. نجرّب تاني، مفيش مشكلة.';
      });
      _flip = Timer(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        setState(() {
          cards[first].isFaceUp = false;
          c.isFaceUp = false;
          locked = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cols = widget.level == 0 ? 3 : 4;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const GuideRow(text: 'نقلب كارتين ونشوف لو زي بعض. خدنا وقتنا.'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kSurface2,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0x733DBDB0), width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('نلاقي الكروت اللي زي بعض',
                        style: displayStyle(size: 19.2)),
                    const Spacer(),
                    Text('⏱ ${fmtTime(remaining)}',
                        style: displayStyle(size: 20, color: gameHue.hi)),
                  ],
                ),
                const SizedBox(height: 10),
                _TimeBar(value: remaining / widget.seconds),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: cols,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: widget.level == 0 ? 0.9 : 0.8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < cards.length; i++)
                      _CardView(card: cards[i], onTap: () => _onTap(i)),
                  ],
                ),
                const SizedBox(height: 16),
                if (status == _Status.playing)
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 27),
                    child: Text(message, style: bodyStyle(color: kFgSoft)),
                  ),
                if (status != _Status.playing)
                  _endPanel(won: status == _Status.won),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _endPanel({required bool won}) {
    return Column(
      children: [
        if (won)
          const Icon(Icons.star_rounded, size: 78, color: kStar)
        else
          const Text('⏰', style: TextStyle(fontSize: 56)),
        Text(won ? 'خلصت! برافو' : 'الوقت خلص. مفيش مشكلة!',
            textAlign: TextAlign.center, style: displayStyle(size: 24)),
        if (!won)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('نجرّب تاني؟', style: bodyStyle(color: kFgSoft)),
          ),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            DBtn(won ? 'نلعب تاني' : 'نجرّب تاني',
                primary: true, big: true, onTap: () => setState(_newRound)),
            DBtn('خروج', big: true, onTap: widget.onExit),
          ],
        ),
      ],
    );
  }
}

class _TimeBar extends StatelessWidget {
  final double value;
  const _TimeBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: kLine, width: 2),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: gameHue.hs,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}

class _CardView extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  const _CardView({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final shown = card.isFaceUp || card.isMatched;
    return GestureDetector(
      onTap: card.isMatched ? null : onTap,
      child: ThickBox(
        fill: shown ? gameHue.h : Colors.white,
        border: shown ? gameHue.hi : gameHue.hs,
        radius: BorderRadius.circular(24),
        bottom: 5,
        padding: const EdgeInsets.all(6),
        child: shown
            ? ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox.expand(
            child: Image.asset(card.image, fit: BoxFit.cover),
          ),
        )
            : Center(
          child: Text('❓',
              style: bodyStyle(size: 36, weight: FontWeight.w500)),
        ),
      ),
    );
  }
}