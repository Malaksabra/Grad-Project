import 'dart:math';

/// What happened after the child tapped a piece.
enum PuzzleTapOutcome {
  /// Nothing changed: the game is over.
  ignored,

  /// The first piece was chosen.
  selected,

  /// The same piece was tapped again, so it is not chosen anymore.
  deselected,

  /// Two pieces changed places, but the picture is not finished.
  swapped,

  /// Two pieces changed places and the picture is finished.
  solved,
}

enum PuzzleStatus { playing, won, timeUp }

/// The rules of the puzzle game. The picture is cut into [rows] x [columns]
/// pieces and shuffled. The child chooses one piece and then another one, and
/// they change places. It has no widgets and no texts, so it can be tested
/// alone. The screen owns the real timer and calls [tick] every second.
///
/// Positions and pieces are numbered row by row, from 0. The piece number
/// is also the place where that piece belongs.
class PuzzleGame {
  PuzzleGame({
    required List<String> images,
    required this.rows,
    required this.columns,
    required this.seconds,
    Random? random,
  }) : _images = List.of(images),
       _random = random ?? Random() {
    if (rows < 1 || columns < 1 || rows * columns < 2) {
      throw ArgumentError('the puzzle needs at least two pieces');
    }
    if (seconds < 1) {
      throw ArgumentError.value(seconds, 'seconds', 'must be at least 1');
    }
    if (_images.isEmpty) {
      throw ArgumentError.value(images, 'images', 'must not be empty');
    }
    _deal();
  }

  final int rows;
  final int columns;

  /// The full time of the game, in seconds.
  final int seconds;

  final List<String> _images;
  final Random _random;

  String _image = '';
  List<int> _pieceAt = [];
  int? _selected;

  bool _started = false;
  PuzzleStatus _status = PuzzleStatus.playing;
  int _remaining = 0;

  int get pieceCount => rows * columns;

  /// The picture that is cut into pieces.
  String get image => _image;

  PuzzleStatus get status => _status;
  int get remainingSeconds => _remaining;

  /// The clock starts when the child chooses the first piece.
  bool get hasStarted => _started;

  /// The position of the chosen piece, or null if none is chosen.
  int? get selectedPosition => _selected;

  /// From 1.0 (full time) down to 0.0 (time is up), for the time bar.
  double get remainingFraction => _remaining / seconds;

  /// Which piece is at [position].
  int pieceAt(int position) => _pieceAt[position];

  bool get isSolved {
    for (var i = 0; i < _pieceAt.length; i++) {
      if (_pieceAt[i] != i) return false;
    }
    return true;
  }

  PuzzleTapOutcome tap(int position) {
    RangeError.checkValidIndex(position, _pieceAt);
    if (_status != PuzzleStatus.playing) return PuzzleTapOutcome.ignored;

    _started = true;
    final first = _selected;
    if (first == null) {
      _selected = position;
      return PuzzleTapOutcome.selected;
    }
    if (first == position) {
      _selected = null;
      return PuzzleTapOutcome.deselected;
    }

    final moved = _pieceAt[first];
    _pieceAt[first] = _pieceAt[position];
    _pieceAt[position] = moved;
    _selected = null;

    if (isSolved) {
      _status = PuzzleStatus.won;
      return PuzzleTapOutcome.solved;
    }
    return PuzzleTapOutcome.swapped;
  }

  /// One second passed. Does nothing before the first tap or after the end.
  void tick() {
    if (_status != PuzzleStatus.playing || !_started) return;
    _remaining--;
    if (_remaining <= 0) {
      _remaining = 0;
      _status = PuzzleStatus.timeUp;
    }
  }

  /// Starts a new round with a new picture, a new shuffle and the full time.
  void restart() => _deal();

  void _deal() {
    _image = _images[_random.nextInt(_images.length)];
    _pieceAt = List.generate(pieceCount, (i) => i);
    // A shuffle that leaves the picture finished is shuffled again.
    do {
      _pieceAt.shuffle(_random);
    } while (isSolved);
    _selected = null;
    _started = false;
    _status = PuzzleStatus.playing;
    _remaining = seconds;
  }
}
