import 'package:flutter/material.dart';

import '../communication_colors.dart';
import '../communication_texts.dart';

/// The teddy at the top of a page: it talks to the child in a speech bubble,
/// and the speaker button reads the message out loud.
class TeddyGuide extends StatelessWidget {
  const TeddyGuide({
    super.key,
    required this.message,
    required this.onListen,
    this.hue = CommunicationHue.blue,
  });

  final String message;
  final VoidCallback onListen;
  final CommunicationHue hue;

  static const double _teddySize = 84;
  static const double _gap = 12;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox.square(dimension: _teddySize, child: _Teddy()),
        const SizedBox(width: _gap),
        Expanded(
          child: _SpeechBubble(message: message, onListen: onListen, hue: hue),
        ),
      ],
    );
  }
}

/// The bubble with the teddy's words and the speaker button.
class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({
    required this.message,
    required this.onListen,
    required this.hue,
  });

  final String message;
  final VoidCallback onListen;
  final CommunicationHue hue;

  static const double _radius = 24;
  static const double _borderWidth = 2;
  static const double _padding = 12;
  static const Duration _fadeDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: hue.edge,
          width: _borderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Row(
          children: [
            Expanded(
              // The text fades when the teddy has something new to say.
              child: AnimatedSwitcher(
                duration: _fadeDuration,
                child: Text(
                  message,
                  key: ValueKey(message),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: hue.text,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onListen,
              tooltip: CommunicationTexts.listen,
              color: hue.text,
              icon: const Icon(Icons.volume_up_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

/// The teddy's face, drawn in code so no image file is needed.
class _Teddy extends StatelessWidget {
  const _Teddy();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(painter: _TeddyPainter());
  }
}

class _TeddyPainter extends CustomPainter {
  const _TeddyPainter();

  // The drawing is made on a 120 x 120 board and scaled to the widget size.
  static const double _board = 120;
  static const double _earRadius = 17;
  static const double _faceRadius = 44;
  static const double _faceBorderWidth = 3;
  static const double _cheekRadius = 8;
  static const double _cheekAlpha = 0.55;
  static const double _eyeRadius = 5;
  static const double _mouthWidth = 3;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _board);

    _circle(canvas, const Offset(28, 30), _earRadius, CommunicationColors.teddyEar);
    _circle(canvas, const Offset(92, 30), _earRadius, CommunicationColors.teddyEar);

    const faceCenter = Offset(60, 66);
    _circle(canvas, faceCenter, _faceRadius, CommunicationColors.teddyFace);
    canvas.drawCircle(
      faceCenter,
      _faceRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _faceBorderWidth
        ..color = CommunicationColors.teddyEar,
    );

    final cheekColor = CommunicationColors.teddyCheek.withValues(
      alpha: _cheekAlpha,
    );
    _circle(canvas, const Offset(36, 76), _cheekRadius, cheekColor);
    _circle(canvas, const Offset(84, 76), _cheekRadius, cheekColor);

    _oval(canvas, const Offset(60, 80), 38, 28, Colors.white);
    _circle(canvas, const Offset(45, 58), _eyeRadius, CommunicationColors.teddyEye);
    _circle(canvas, const Offset(75, 58), _eyeRadius, CommunicationColors.teddyEye);
    _oval(canvas, const Offset(60, 74), 12, 8, CommunicationColors.teddyNose);

    canvas.drawPath(
      Path()
        ..moveTo(51, 85)
        ..quadraticBezierTo(60, 93, 69, 85),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _mouthWidth
        ..strokeCap = StrokeCap.round
        ..color = CommunicationColors.teddyNose,
    );
  }

  void _circle(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(center, radius, Paint()..color = color);
  }

  void _oval(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    Color color,
  ) {
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
