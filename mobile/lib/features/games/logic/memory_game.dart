import 'dart:math';

/// What happened after the child tapped a card.
enum FlipOutcome {
  /// Nothing changed: the game is over, the board is waiting, or the card is
  /// already turned.
  ignored,

  /// The first card of a pair was turned.
  firstCard,

  /// The second card is the same as the first one.
  match,

  /// The second card is different. The screen should wait a moment, then call
  /// [MemoryGame.hideMismatch].
  mismatch,
}

enum MemoryStatus { playing, won, timeUp }

class MemoryCard {
  MemoryCard({required this.id, required this.image});

  final int id;

  /// Which picture is on the card. Two cards with the same image match.
  final String image;

  bool isFaceUp = false;
  bool isMatched = false;
}

/// The rules of the memory game. It has no widgets and no texts, so it can be
/// tested alone. The screen owns the real timers: it calls [tick] every second
/// and [hideMismatch] after a short pause.
class MemoryGame {
  MemoryGame({
    required List<String> images,
    required this.pairs,
    required this.seconds,
    Random? random,
  }) : _images = List.of(images),
       _random = random ?? Random() {
    if (pairs < 1) {
      throw ArgumentError.value(pairs, 'pairs', 'must be at least 1');
    }
    if (seconds < 1) {
      throw ArgumentError.value(seconds, 'seconds', 'must be at least 1');
    }
    if (_images.toSet().length != _images.length) {
      throw ArgumentError.value(images, 'images', 'must not repeat a picture');
    }
    if (pairs > _images.length) {
      throw ArgumentError.value(
        pairs,
        'pairs',
        'needs ${_images.length} pictures at most',
      );
    }
    _deal();
  }

  final int pairs;

  /// The full time of the game, in seconds.
  final int seconds;

  final List<String> _images;
  final Random _random;

  List<MemoryCard> _cards = [];
  int? _firstIndex;

  // The two cards of a mismatch, waiting to be turned back.
  int? _mismatchFirst;
  int? _mismatchSecond;

  bool _started = false;
  MemoryStatus _status = MemoryStatus.playing;
  int _remaining = 0;

  List<MemoryCard> get cards => List.unmodifiable(_cards);
  MemoryStatus get status => _status;
  int get remainingSeconds => _remaining;

  /// The clock starts when the child turns the first card.
  bool get hasStarted => _started;

  /// True while a mismatch waits to be turned back. Taps are ignored then.
  bool get isLocked => _mismatchFirst != null;

  /// From 1.0 (full time) down to 0.0 (time is up), for the time bar.
  double get remainingFraction => _remaining / seconds;

  FlipOutcome flip(int index) {
    RangeError.checkValidIndex(index, _cards);
    if (_status != MemoryStatus.playing || isLocked) {
      return FlipOutcome.ignored;
    }
    final card = _cards[index];
    if (card.isFaceUp || card.isMatched) return FlipOutcome.ignored;

    _started = true;
    card.isFaceUp = true;

    final first = _firstIndex;
    if (first == null) {
      _firstIndex = index;
      return FlipOutcome.firstCard;
    }
    _firstIndex = null;

    if (_cards[first].image == card.image) {
      _cards[first].isMatched = true;
      card.isMatched = true;
      if (_cards.every((c) => c.isMatched)) _status = MemoryStatus.won;
      return FlipOutcome.match;
    }

    _mismatchFirst = first;
    _mismatchSecond = index;
    return FlipOutcome.mismatch;
  }

  /// Turns the two cards of a mismatch face down and unlocks the board.
  void hideMismatch() {
    final first = _mismatchFirst;
    final second = _mismatchSecond;
    if (first == null || second == null) return;
    _cards[first].isFaceUp = false;
    _cards[second].isFaceUp = false;
    _mismatchFirst = null;
    _mismatchSecond = null;
  }

  /// One second passed. Does nothing before the first card or after the end.
  void tick() {
    if (_status != MemoryStatus.playing || !_started) return;
    _remaining--;
    if (_remaining <= 0) {
      _remaining = 0;
      _status = MemoryStatus.timeUp;
    }
  }

  /// Starts a new round with a new shuffle and the full time.
  void restart() => _deal();

  void _deal() {
    final picked = (List.of(_images)..shuffle(_random)).take(pairs).toList();
    final deck = [...picked, ...picked]..shuffle(_random);
    _cards = [
      for (var i = 0; i < deck.length; i++) MemoryCard(id: i, image: deck[i]),
    ];
    _firstIndex = null;
    _mismatchFirst = null;
    _mismatchSecond = null;
    _started = false;
    _status = MemoryStatus.playing;
    _remaining = seconds;
  }
}
