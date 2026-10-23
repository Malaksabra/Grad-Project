import 'package:flutter/material.dart';

import '../games_colors.dart';
import '../games_styles.dart';
import 'thick_box.dart';

/// The teddy bear with a speech bubble that tells the parent what to do.
class GuideRow extends StatelessWidget {
  const GuideRow({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const Mascot(size: 76),
          const SizedBox(width: 14),
          Expanded(
            child: ThickBox(
              fill: Colors.white,
              border: GamesColors.edge,
              radius: BorderRadius.circular(24),
              bottom: 4,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(text, style: GamesStyles.body(size: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

/// The teddy bear, drawn with code (no picture file).
class Mascot extends StatelessWidget {
  const Mascot({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(size, size),
        painter: const _MascotPainter(),
      ),
    );
  }
}

// The drawing is made on a 120 x 120 canvas and scaled to the real size.
class _MascotPainter extends CustomPainter {
  const _MascotPainter();

  static const Color _fur = Color(0xFFE89C47);
  static const Color _furLight = Color(0xFFFFF4E6);
  static const Color _ink = Color(0xFF703C08);
  static const Color _cheek = Color(0x8CE873A2);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 120);
    final fill = Paint()..style = PaintingStyle.fill;

    // Ears.
    fill.color = _fur;
    canvas.drawCircle(const Offset(28, 30), 17, fill);
    canvas.drawCircle(const Offset(92, 30), 17, fill);

    // Head.
    fill.color = _furLight;
    canvas.drawCircle(const Offset(60, 66), 44, fill);
    canvas.drawCircle(
      const Offset(60, 66),
      44,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = _fur,
    );

    // Cheeks.
    fill.color = _cheek;
    canvas.drawCircle(const Offset(36, 76), 8, fill);
    canvas.drawCircle(const Offset(84, 76), 8, fill);

    // Muzzle.
    fill.color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(60, 80), width: 38, height: 28),
      fill,
    );

    // Eyes.
    fill.color = GamesColors.ink;
    canvas.drawCircle(const Offset(45, 58), 5, fill);
    canvas.drawCircle(const Offset(75, 58), 5, fill);

    // Nose.
    fill.color = _ink;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(60, 74), width: 12, height: 8),
      fill,
    );

    // Smile.
    canvas.drawPath(
      Path()
        ..moveTo(51, 85)
        ..quadraticBezierTo(60, 93, 69, 85),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = _ink,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
