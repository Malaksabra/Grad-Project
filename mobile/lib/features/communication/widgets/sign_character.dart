import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../signs_data.dart';

/// Who is drawn: the child, the child's friend, or mama.
enum CharacterKind { me, friend, mama }

/// The sender of a situation is mama or the friend.
CharacterKind kindOfSender(String sender) {
  return sender == SignEmojis.mama ? CharacterKind.mama : CharacterKind.friend;
}

/// A cute drawn character that makes the sign with its own body: the arm
/// waves, the palm says "wait", the thumb jumps, the head bows to say thanks.
///
/// Everything moves on one slow, smooth loop (breathing, blinking, a gentle
/// sway), so the motion is soft instead of mechanical. When mama makes the
/// "wait" sign she holds a phone to her ear and calms the child with her
/// other hand. It stands still when the device asks for no animations.
class SignCharacter extends StatefulWidget {
  const SignCharacter({
    super.key,
    required this.kind,
    required this.pose,
    this.height = 170,
  });

  final CharacterKind kind;
  final SignPose pose;
  final double height;

  @override
  State<SignCharacter> createState() => _SignCharacterState();
}

class _SignCharacterState extends State<SignCharacter>
    with SingleTickerProviderStateMixin {
  // One slow loop: two gentle gesture cycles, one breath, one blink.
  static const Duration _duration = Duration(milliseconds: 2600);

  // A calm, mid-gesture moment used when animations are turned off.
  static const double _restingValue = 0.125;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = _restingValue;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width =
        widget.height * _CharacterPainter.canvasWidth / _CharacterPainter.canvasHeight;

    return SizedBox(
      width: width,
      height: widget.height,
      child: CustomPaint(
        painter: _CharacterPainter(
          kind: widget.kind,
          pose: widget.pose,
          animation: _controller,
        ),
      ),
    );
  }
}

enum _Hand { none, relaxed, open, thumbUp }

/// Draws the character on a 140 x 170 canvas, scaled to the widget size.
/// Angles are measured from "straight down"; a positive angle points to the
/// outside of the arm's side.
class _CharacterPainter extends CustomPainter {
  _CharacterPainter({
    required this.kind,
    required this.pose,
    required this.animation,
  }) : super(repaint: animation);

  final CharacterKind kind;
  final SignPose pose;
  final Animation<double> animation;

  static const double canvasWidth = 140;
  static const double canvasHeight = 170;

  // A big round head and a small body: that is what makes it cute.
  static const Offset _headCenter = Offset(70, 44);
  static const double _headRadius = 27;
  static const Offset _shoulderLeft = Offset(56, 80);
  static const Offset _shoulderRight = Offset(84, 80);
  static const double _upperLength = 22;
  static const double _foreLength = 22;

  static const Color _skin = Color(0xFFF6CDA8);
  static const Color _skinLight = Color(0xFFFFE0C4);
  static const Color _skinLine = Color(0xFFE3A982);
  static const Color _ink = Color(0xFF3B2A20);
  static const Color _pants = Color(0xFF4A6FA5);
  static const Color _shoe = Color(0xFF6B5444);
  static const Color _cheek = Color(0x80FF8FA3);
  static const Color _mouthInside = Color(0xFF8A3B3B);
  static const Color _tongue = Color(0xFFF28B9B);
  static const Color _phone = Color(0xFF6B7BA8);
  static const Color _bow = Color(0xFFFF8FB1);

  // Moving values, refreshed at the start of every paint. They all come from
  // the one loop, so every part of the body moves in rhythm.
  double _t = 0; // 0..1..0, a soft cosine; two cycles per loop
  double _breath = 0; // -1..1, one breath per loop
  double _blink = 0; // 0 = eyes open, 1 = closed

  bool get _isMama => kind == CharacterKind.mama;

  /// Mama's "wait" sign: she is on the phone, so she holds it to her ear and
  /// calms the child with her other hand.
  bool get _isPhone => _isMama && pose == SignPose.stopHand;

  Color get _hair => switch (kind) {
    CharacterKind.me => const Color(0xFF7A4A2B),
    CharacterKind.friend => const Color(0xFF2E2A33),
    CharacterKind.mama => const Color(0xFF5B3A29),
  };

  Color get _top => switch (kind) {
    CharacterKind.me => const Color(0xFF5AA9E6),
    CharacterKind.friend => const Color(0xFF6CC59A),
    CharacterKind.mama => const Color(0xFFB58AD8),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final v = animation.value;
    _t = 0.5 - 0.5 * math.cos(4 * math.pi * v);
    _breath = math.sin(2 * math.pi * v);
    _blink = math.max(0.0, 1 - (v - 0.48).abs() / 0.022);

    final hop = pose == SignPose.smile ? -5 * _t : 0.0;
    final shadowScale = 1 + hop / 30;

    canvas.save();
    canvas.scale(size.width / canvasWidth, size.height / canvasHeight);

    // The ground shadow stays; the body moves a little above it.
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(70, 160),
        width: 62 * shadowScale,
        height: 9 * shadowScale,
      ),
      Paint()..color = const Color(0x221E5A8C),
    );
    canvas.translate(0, hop + 0.8 * _breath);

    if (_isMama) _drawBackHair(canvas);
    _drawLegs(canvas);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(63, 62, 14, 14),
        const Radius.circular(6),
      ),
      Paint()..color = _skin,
    );
    _drawTorso(canvas);
    _drawArms(canvas);
    _drawHead(canvas);
    _drawFrontArms(canvas);

    // Mama's thank-you for waiting is a little floating heart.
    if (_isMama && pose == SignPose.smile) {
      _drawHeart(
        canvas,
        Offset(104, 26 - 6 * _t),
        6,
        Color.fromRGBO(240, 106, 141, 0.45 + 0.55 * _t),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CharacterPainter oldDelegate) {
    return oldDelegate.kind != kind || oldDelegate.pose != pose;
  }

  Paint _stroke(Color color, double width) {
    return Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
  }

  // ---- Body ----

  void _drawBackHair(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(40, 20, 100, 94),
        const Radius.circular(26),
      ),
      Paint()..color = _hair,
    );
  }

  void _drawLegs(Canvas canvas) {
    final top = _isMama ? 130.0 : 114.0;
    final legPaint = Paint()..color = _isMama ? _skin : _pants;

    for (final x in const [57.0, 72.0]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, top, 11, 150 - top),
          const Radius.circular(5.5),
        ),
        legPaint,
      );
      canvas.drawOval(Rect.fromLTWH(x - 3, 146, 17, 10), Paint()..color = _shoe);
      canvas.drawOval(
        Rect.fromLTWH(x - 1, 146.5, 9, 3.5),
        Paint()..color = const Color(0x55FFFFFF),
      );
    }
  }

  void _drawTorso(Canvas canvas) {
    final paint = Paint()..color = _top;
    final soft = Paint()..color = const Color(0x2EFFFFFF);

    if (_isMama) {
      // A dress that widens towards the bottom, with a belt and a soft hem.
      final dress = Path()
        ..moveTo(55, 70)
        ..lineTo(85, 70)
        ..lineTo(100, 136)
        ..quadraticBezierTo(70, 144, 40, 136)
        ..close();
      canvas.drawPath(dress, paint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(54, 86, 32, 5),
          const Radius.circular(2.5),
        ),
        soft,
      );
      canvas.drawPath(
        Path()
          ..moveTo(42, 133)
          ..quadraticBezierTo(70, 141, 98, 133),
        _stroke(const Color(0x66FFFFFF), 3),
      );
      // A round neckline.
      canvas.drawArc(
        Rect.fromCenter(center: const Offset(70, 69), width: 18, height: 14),
        0,
        math.pi,
        true,
        Paint()..color = _skin,
      );
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(49, 70, 42, 50),
          const Radius.circular(17),
        ),
        paint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(54, 76, 6, 28),
          const Radius.circular(3),
        ),
        soft,
      );
      // A little white collar.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(60, 67, 20, 8),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFFFFFFF),
      );
    }
  }

  // ---- Arms ----

  Offset _direction(int side, double angle) {
    return Offset(side * math.sin(angle), math.cos(angle));
  }

  /// An arm described by two angles: shoulder to elbow, elbow to hand.
  void _armByAngles(
    Canvas canvas,
    Offset shoulder,
    int side,
    double upper,
    double fore,
    _Hand hand, {
    double lift = 0,
    double scale = 1,
  }) {
    final elbow =
        shoulder + _direction(side, upper) * _upperLength + Offset(0, -lift);
    final foreDirection = _direction(side, fore);
    _armByPoints(
      canvas,
      shoulder,
      elbow,
      elbow + foreDirection * _foreLength,
      foreDirection,
      hand,
      side: side,
      scale: scale,
    );
  }

  /// An arm described by the three points it passes through. The sleeve is
  /// drawn over the forearm, so the elbow looks like one soft bend.
  void _armByPoints(
    Canvas canvas,
    Offset shoulder,
    Offset elbow,
    Offset hand,
    Offset foreDirection,
    _Hand shape, {
    int side = 1,
    double scale = 1,
  }) {
    canvas.drawLine(elbow, hand, _stroke(_skin, 9.5));
    canvas.drawLine(shoulder, elbow, _stroke(_top, 12));
    _drawHand(canvas, hand, foreDirection, shape, side, scale);
  }

  /// Hands are soft mittens with a thumb, not sticks. They are drawn upright
  /// (fingers towards -y) and then turned to follow the forearm.
  void _drawHand(
    Canvas canvas,
    Offset center,
    Offset direction,
    _Hand shape,
    int side,
    double scale,
  ) {
    if (shape == _Hand.none) return;

    final skin = Paint()..color = _skin;
    final line = _stroke(_skinLine, 1.1);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.atan2(direction.dx, -direction.dy));
    canvas.scale(scale);

    switch (shape) {
      case _Hand.none:
        break;
      case _Hand.relaxed:
        canvas.drawCircle(Offset.zero, 6.5, skin);
        canvas.drawCircle(const Offset(-2, -2), 2.2, Paint()..color = _skinLight);
      case _Hand.open:
        // Thumb first, so the palm covers its root.
        canvas.drawLine(
          Offset(-5.5 * side, 1),
          Offset(-10.5 * side, -5),
          _stroke(_skin, 5.5),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTRB(-7, -16, 7, 6),
            const Radius.circular(6.5),
          ),
          skin,
        );
        // Four fingers held together.
        for (final x in const [-3.5, 0.0, 3.5]) {
          canvas.drawLine(Offset(x, -15), Offset(x, -8), line);
        }
      case _Hand.thumbUp:
        canvas.drawLine(
          Offset(-1.5, -6),
          Offset(-1.5 + side * 1.5, -17),
          _stroke(_skin, 6.5),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTRB(-7.5, -8, 7.5, 6),
            const Radius.circular(6),
          ),
          skin,
        );
        for (final y in const [-3.5, -0.2, 3.1]) {
          canvas.drawLine(Offset(1, y), Offset(6, y), line);
        }
    }

    canvas.restore();
  }

  void _idleArm(Canvas canvas, Offset shoulder, int side, [double extra = 0]) {
    _armByAngles(
      canvas,
      shoulder,
      side,
      0.22 + extra + 0.02 * _breath,
      0.12,
      _Hand.relaxed,
    );
  }

  /// Arms that are behind the head.
  void _drawArms(Canvas canvas) {
    final t = _t;

    switch (pose) {
      case SignPose.wave:
        // The raised hand sways left and right, like a real wave.
        _idleArm(canvas, _shoulderLeft, -1);
        _armByAngles(
          canvas,
          _shoulderRight,
          1,
          2.35 + (t - 0.5) * 0.12,
          math.pi - 0.15 + (t - 0.5) * 0.9,
          _Hand.open,
        );
      case SignPose.stopHand when _isMama:
        // Her free hand rests in the air and pats gently: "wait a little".
        // The other arm holds the phone (drawn in front of the head).
        _armByPoints(
          canvas,
          _shoulderLeft,
          const Offset(41, 97),
          Offset(35, 78 + 4 * t),
          const Offset(-0.25, -1),
          _Hand.open,
          side: -1,
        );
      case SignPose.stopHand:
        // The flat hand is held up and pushes forward softly.
        _idleArm(canvas, _shoulderLeft, -1);
        _armByAngles(
          canvas,
          _shoulderRight,
          1,
          2.0,
          math.pi - 0.08 - 0.1 * t,
          _Hand.open,
          scale: 1 + 0.12 * t,
        );
      case SignPose.thumbsUp:
        // The fist with the thumb up bounces.
        _idleArm(canvas, _shoulderLeft, -1);
        _armByAngles(
          canvas,
          _shoulderRight,
          1,
          2.2,
          math.pi - 0.05,
          _Hand.thumbUp,
          lift: 5 * t,
        );
      case SignPose.thanks:
        // Both hands together in front of the chest.
        final handY = 94 - 3 * t;
        _armByPoints(
          canvas,
          _shoulderLeft,
          const Offset(46, 100),
          Offset(66, handY + 8),
          const Offset(0, -1),
          _Hand.none,
        );
        _armByPoints(
          canvas,
          _shoulderRight,
          const Offset(94, 100),
          Offset(74, handY + 8),
          const Offset(0, -1),
          _Hand.none,
        );
        _drawHand(
          canvas,
          Offset(70, handY),
          const Offset(0, -1),
          _Hand.open,
          1,
          1,
        );
      case SignPose.thinking:
        // One hand rests near the chin (drawn in front of the head).
        _idleArm(canvas, _shoulderLeft, -1);
      case SignPose.smile:
        // Happy arms that lift and open a little.
        _armByAngles(
          canvas,
          _shoulderLeft,
          -1,
          0.5 + 0.4 * t,
          0.3 + 0.4 * t,
          _Hand.relaxed,
        );
        _armByAngles(
          canvas,
          _shoulderRight,
          1,
          0.5 + 0.4 * t,
          0.3 + 0.4 * t,
          _Hand.relaxed,
        );
      case SignPose.idle:
        _idleArm(canvas, _shoulderLeft, -1);
        _idleArm(canvas, _shoulderRight, 1);
    }
  }

  /// Arms that must be seen on top of the head: the thinking hand at the
  /// chin, and mama's phone at her ear.
  void _drawFrontArms(Canvas canvas) {
    if (pose == SignPose.thinking) {
      _armByPoints(
        canvas,
        _shoulderRight,
        const Offset(96, 96),
        Offset(82, 69 - 1.5 * _t),
        const Offset(-0.4, -1),
        _Hand.relaxed,
      );
    }

    if (_isPhone) {
      const hand = Offset(100, 57);
      _armByPoints(
        canvas,
        _shoulderRight,
        const Offset(108, 84),
        hand,
        const Offset(-0.15, -1),
        _Hand.none,
      );

      // The phone, held at her ear.
      canvas.save();
      canvas.translate(103, 46);
      canvas.rotate(0.12);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 10, height: 22),
          const Radius.circular(3.5),
        ),
        Paint()..color = _phone,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: const Offset(0, -1), width: 6, height: 15),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFDDE5F7),
      );
      canvas.restore();

      // Her hand wraps around the phone.
      canvas.drawCircle(hand, 6, Paint()..color = _skin);
      canvas.drawLine(
        const Offset(97, 52),
        const Offset(100, 49),
        _stroke(_skin, 4.5),
      );
    }
  }

  // ---- Head ----

  void _drawHead(Canvas canvas) {
    final tilt = switch (pose) {
      SignPose.thinking => 0.1 + 0.03 * _t,
      SignPose.wave => (_t - 0.5) * 0.1,
      SignPose.smile => (_t - 0.5) * 0.12,
      SignPose.stopHand when _isMama => 0.09 + 0.02 * _t,
      _ => _breath * 0.012,
    };
    // Saying thanks, the head bows a little.
    final bow = pose == SignPose.thanks ? 5 * _t : 0.0;

    canvas.save();
    canvas.translate(_headCenter.dx, _headCenter.dy + bow);
    canvas.rotate(tilt);
    canvas.translate(-_headCenter.dx, -_headCenter.dy);

    final hair = Paint()..color = _hair;
    final skin = Paint()..color = _skin;

    // Hair behind the face, ears, then the face with a soft light.
    canvas.drawCircle(_headCenter.translate(0, -3.5), _headRadius + 2.5, hair);
    for (final x in const [43.0, 97.0]) {
      canvas.drawCircle(Offset(x, 49), 4.5, skin);
    }
    final faceRect = Rect.fromCircle(center: _headCenter, radius: _headRadius);
    canvas.drawCircle(
      _headCenter,
      _headRadius,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.5),
          radius: 1.0,
          colors: [_skinLight, _skin],
        ).createShader(faceRect),
    );
    canvas.drawCircle(const Offset(53, 56), 5.5, Paint()..color = _cheek);
    canvas.drawCircle(const Offset(87, 56), 5.5, Paint()..color = _cheek);

    _drawFace(canvas);
    _drawFringe(canvas);

    canvas.restore();
  }

  void _drawFringe(Canvas canvas) {
    final hair = Paint()..color = _hair;

    // The top of the head and a soft, side-swept fringe.
    final fringe = Path()
      ..moveTo(42, 46)
      ..cubicTo(40, 22, 58, 14, 70, 14)
      ..cubicTo(82, 14, 100, 22, 98, 46)
      ..cubicTo(96, 36, 88, 31, 78, 30)
      ..quadraticBezierTo(68, 36, 58, 33)
      ..quadraticBezierTo(48, 33, 42, 46)
      ..close();
    canvas.drawPath(fringe, hair);

    switch (kind) {
      case CharacterKind.me:
        // A little curl on top.
        canvas.drawPath(
          Path()
            ..moveTo(68, 16)
            ..quadraticBezierTo(70, 3, 80, 7)
            ..quadraticBezierTo(74, 8, 74, 16)
            ..close(),
          hair,
        );
      case CharacterKind.friend:
        canvas.drawPath(
          Path()
            ..moveTo(72, 16)
            ..quadraticBezierTo(70, 3, 60, 7)
            ..quadraticBezierTo(66, 8, 66, 16)
            ..close(),
          hair,
        );
      case CharacterKind.mama:
        // A pink bow in her hair.
        final bow = Paint()..color = _bow;
        canvas.drawCircle(const Offset(84.5, 23), 3.4, bow);
        canvas.drawCircle(const Offset(91.5, 27), 3.4, bow);
        canvas.drawCircle(
          const Offset(88, 25),
          2.4,
          Paint()..color = const Color(0xFFE5668F),
        );
    }
  }

  void _drawFace(Canvas canvas) {
    final happy = pose == SignPose.smile;
    final look = pose == SignPose.thinking ? const Offset(1.5, -2) : Offset.zero;

    for (final x in const [58.0, 82.0]) {
      _drawEye(canvas, Offset(x, 47) + look, happy);
    }

    if (!happy) {
      final brow = _stroke(_hair, 2);
      canvas.drawLine(const Offset(54, 38), const Offset(62, 37.5), brow);
      if (pose == SignPose.thinking) {
        // One eyebrow goes up while thinking.
        canvas.drawLine(const Offset(78, 35), const Offset(86, 32.5), brow);
      } else {
        canvas.drawLine(const Offset(78, 37.5), const Offset(86, 38), brow);
      }
    }

    final ink = _stroke(_ink, 2.4);

    switch (pose) {
      case SignPose.smile:
        final rect = Rect.fromCenter(
          center: const Offset(70, 56),
          width: 17,
          height: 12,
        );
        final mouth = Path()
          ..addArc(rect, 0, math.pi)
          ..close();
        canvas.drawPath(mouth, Paint()..color = _mouthInside);
        canvas.save();
        canvas.clipPath(mouth);
        canvas.drawOval(
          Rect.fromCenter(center: const Offset(70, 62), width: 10, height: 7),
          Paint()..color = _tongue,
        );
        canvas.restore();
      case SignPose.thinking:
        canvas.drawLine(const Offset(65, 58), const Offset(73, 57), ink);
      case SignPose.wave || SignPose.thumbsUp || SignPose.thanks:
        canvas.drawArc(
          Rect.fromCenter(center: const Offset(70, 55), width: 15, height: 9),
          0.25,
          math.pi - 0.5,
          false,
          ink,
        );
      case SignPose.stopHand when _isMama:
        // She is talking on the phone: the mouth opens and closes.
        canvas.drawOval(
          Rect.fromCenter(
            center: const Offset(70, 57.5),
            width: 7,
            height: 3 + 5 * _t,
          ),
          Paint()..color = _mouthInside,
        );
      case SignPose.stopHand || SignPose.idle:
        canvas.drawArc(
          Rect.fromCenter(center: const Offset(70, 55.5), width: 11, height: 7),
          0.25,
          math.pi - 0.5,
          false,
          ink,
        );
    }
  }

  /// Big shiny eyes that blink. Happy eyes are two closed arcs.
  void _drawEye(Canvas canvas, Offset c, bool happy) {
    if (happy) {
      canvas.drawArc(
        Rect.fromCenter(center: c.translate(0, 2.5), width: 9, height: 9),
        math.pi,
        math.pi,
        false,
        _stroke(_ink, 2.8),
      );
      return;
    }

    final height = 10.5 * (1 - 0.88 * _blink);
    canvas.drawOval(
      Rect.fromCenter(center: c, width: 8.5, height: height),
      Paint()..color = _ink,
    );
    if (_blink < 0.4) {
      canvas.drawCircle(c.translate(-1.7, -2.4), 2.0, Paint()..color = Colors.white);
      canvas.drawCircle(
        c.translate(1.5, 2.2),
        0.9,
        Paint()..color = const Color(0xB3FFFFFF),
      );
    }
  }

  void _drawHeart(Canvas canvas, Offset c, double s, Color color) {
    final heart = Path()
      ..moveTo(c.dx, c.dy + s * 0.9)
      ..cubicTo(
        c.dx - s * 1.3,
        c.dy - s * 0.1,
        c.dx - s * 0.6,
        c.dy - s * 1.1,
        c.dx,
        c.dy - s * 0.4,
      )
      ..cubicTo(
        c.dx + s * 0.6,
        c.dy - s * 1.1,
        c.dx + s * 1.3,
        c.dy - s * 0.1,
        c.dx,
        c.dy + s * 0.9,
      )
      ..close();
    canvas.drawPath(heart, Paint()..color = color);
  }
}
