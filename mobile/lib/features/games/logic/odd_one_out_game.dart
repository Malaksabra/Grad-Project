import 'dart:math';

/// What happened after the child tapped a picture.
enum PickOutcome {
  /// Nothing changed: the game is over, the round is solved, or this picture
  /// was already tried.
  ignored,

  /// The child found the different picture.
  correct,

  /// This is not the different picture. The child can try another one.
  wrong,
}

enum OddOneOutStatus { playing, won, timeUp }

class OddItem {
  OddItem({required this.image, required this.isOdd});

  final String image;

  /// True for the one picture that is different from the others.
  final bool isOdd;

  bool isWrongPick = false;
  bool isCorrectPick = false;
}

/// The rules of the "pick the different one" game. Each round shows pictures
/// from one group (for example fruits) and one picture from the other group
/// (for example a vegetable). It has no widgets and no texts, so it can be
/// tested alone. After a correct pick, the screen waits a moment and calls
/// [nextRound]. The screen owns the real timer and calls [tick] every second.
class OddOneOutGame {
  OddOneOutGame({
    required List<String> groupA,
    required List<String> groupB,
    required this.itemsPerRound,
    required this.rounds,
    required this.seconds,
    Random? random,
  }) : _groupA = List.of(groupA),
       _groupB = List.of(groupB),
       _random = random ?? Random() {
    if (itemsPerRound < 3) {
      throw ArgumentError.value(itemsPerRound, 'itemsPerRound', 'at least 3');
    }
    if (rounds < 1) {
      throw ArgumentError.value(rounds, 'rounds', 'must be at least 1');
    }
    if (seconds < 1) {
      throw ArgumentError.value(seconds, 'seconds', 'must be at least 1');
    }
    // Either group can be the many, so both must have enough pictures.
    final needed = itemsPerRound - 1;
    if (_groupA.length < needed || _groupB.length < needed) {
      throw ArgumentError('each group needs $needed pictures at least');
    }
    _deal();
  }

  final int itemsPerRound;
  final int rounds;

  /// The full time of the game, in seconds.
  final int seconds;

  final List<String> _groupA;
  final List<String> _groupB;
  final Random _random;

  List<OddItem> _items = [];
  int _round = 0;
  bool _isRoundSolved = false;
  OddOneOutStatus _status = OddOneOutStatus.playing;
  bool _started = false;
  int _remaining = 0;

  int get remainingSeconds => _remaining;

  /// The clock starts when the child picks the first picture.
  bool get hasStarted => _started;

  /// From 1.0 (full time) down to 0.0 (time is up), for the time bar.
  double get remainingFraction => _remaining / seconds;

  List<OddItem> get items => List.unmodifiable(_items);

  /// The number of the current round, from 0.
  int get round => _round;

  OddOneOutStatus get status => _status;

  /// True after the different picture was found, until [nextRound].
  bool get isRoundSolved => _isRoundSolved;

  PickOutcome pick(int index) {
    RangeError.checkValidIndex(index, _items);
    if (_status != OddOneOutStatus.playing || _isRoundSolved) {
      return PickOutcome.ignored;
    }
    final item = _items[index];
    if (item.isWrongPick) return PickOutcome.ignored;

    _started = true;
    if (!item.isOdd) {
      item.isWrongPick = true;
      return PickOutcome.wrong;
    }
    item.isCorrectPick = true;
    _isRoundSolved = true;
    if (_round == rounds - 1) _status = OddOneOutStatus.won;
    return PickOutcome.correct;
  }

  /// One second passed. Does nothing before the first pick or after the end.
  void tick() {
    if (_status != OddOneOutStatus.playing || !_started) return;
    _remaining--;
    if (_remaining <= 0) {
      _remaining = 0;
      _status = OddOneOutStatus.timeUp;
    }
  }

  /// Moves to the next round. Does nothing unless the round is solved and
  /// there is a next round.
  void nextRound() {
    if (!_isRoundSolved || _status != OddOneOutStatus.playing) return;
    _round++;
    _dealRound();
  }

  /// Starts again from the first round, with new pictures and the full time.
  void restart() => _deal();

  void _deal() {
    _round = 0;
    _status = OddOneOutStatus.playing;
    _started = false;
    _remaining = seconds;
    _dealRound();
  }

  void _dealRound() {
    final manyIsA = _random.nextBool();
    final many = List.of(manyIsA ? _groupA : _groupB)..shuffle(_random);
    final few = List.of(manyIsA ? _groupB : _groupA)..shuffle(_random);
    _items = [
      for (final image in many.take(itemsPerRound - 1))
        OddItem(image: image, isOdd: false),
      OddItem(image: few.first, isOdd: true),
    ]..shuffle(_random);
    _isRoundSolved = false;
  }
}
