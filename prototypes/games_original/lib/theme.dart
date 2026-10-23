import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kFg = Color(0xFF22304A);
const kFgSoft = Color(0xFF5A6A86);
const kLine = Color(0xFFE2EDF8);
const kSurface2 = Color(0xFFF2F7FC);
const kStar = Color(0xFFF5C73B);

class Hue {
  final Color h, hs, hi;
  const Hue(this.h, this.hs, this.hi);
}

const commHue = Hue(Color(0xFFE2F2FE), Color(0xFF52AEE5), Color(0xFF154C73));
const routineHue = Hue(Color(0xFFE4F9EC), Color(0xFF4CBF84), Color(0xFF135434));
const socialHue = Hue(Color(0xFFFFE4EF), Color(0xFFE873A2), Color(0xFF781F45));
const gameHue = Hue(Color(0xFFDDF6F3), Color(0xFF3DBDB0), Color(0xFF0E5A53));

TextStyle bodyStyle({
  double size = 17,
  FontWeight weight = FontWeight.w400,
  Color color = kFg,
}) =>
    GoogleFonts.readexPro(
        fontSize: size, fontWeight: weight, color: color, height: 1.65);

TextStyle displayStyle({double size = 19, Color color = kFg}) =>
    GoogleFonts.balooBhaijaan2(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.35);

/// صندوق بحافة سميكة من تحت (زي border-bottom في الـCSS)
class ThickBox extends StatelessWidget {
  final Color fill, border;
  final BorderRadius radius;
  final double top, side, bottom;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;
  final Widget? child;

  const ThickBox({
    super.key,
    required this.fill,
    required this.border,
    required this.radius,
    this.top = 2,
    this.side = 2,
    this.bottom = 5,
    this.padding = EdgeInsets.zero,
    this.constraints,
    this.child,
  });

  static BorderRadius _shrink(BorderRadius b, double d) {
    Radius s(Radius r) => Radius.circular(math.max(0, r.x - d));
    return BorderRadius.only(
      topLeft: s(b.topLeft),
      topRight: s(b.topRight),
      bottomLeft: s(b.bottomLeft),
      bottomRight: s(b.bottomRight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      decoration: BoxDecoration(color: border, borderRadius: radius),
      padding: EdgeInsets.fromLTRB(side, top, side, bottom),
      child: Container(
        decoration:
        BoxDecoration(color: fill, borderRadius: _shrink(radius, side)),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// زرار الـprototype (.btn)
class DBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool primary, big;
  final Hue hue;

  const DBtn(
      this.label, {
        super.key,
        this.onTap,
        this.primary = false,
        this.big = false,
        this.hue = gameHue,
      });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? .45 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: ThickBox(
          fill: primary ? hue.hi : Colors.white,
          border: primary ? hue.hi : hue.hs,
          radius: BorderRadius.circular(999),
          bottom: 5,
          constraints: BoxConstraints(minHeight: big ? 60 : 52),
          padding: EdgeInsets.symmetric(horizontal: big ? 30 : 22),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: bodyStyle(
                size: big ? 18.4 : 16.3,
                weight: FontWeight.w500,
                color: primary ? Colors.white : kFg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// زرار دائري (.iconbtn)
class IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String label;
  const IconBtn(
      {super.key, required this.icon, required this.onTap, this.label = ''});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: ThickBox(
          fill: Colors.white,
          border: kLine,
          radius: BorderRadius.circular(23),
          bottom: 4,
          constraints: BoxConstraints.tight(const Size(46, 46)),
          child: Center(child: Icon(icon, color: kFg, size: 26)),
        ),
      ),
    );
  }
}

/// شريط التطبيق العلوي
class AppBarX extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;
  const AppBarX({super.key, required this.title, this.onBack, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kLine)),
      ),
      child: Row(
        children: [
          onBack == null
              ? const SizedBox(width: 46)
              : IconBtn(
              icon: Icons.chevron_right_rounded,
              label: 'رجوع',
              onTap: onBack!),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: displayStyle(size: 20),
            ),
          ),
          trailing ?? const SizedBox(width: 46),
        ],
      ),
    );
  }
}

/// التابات السفلية
class BottomTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  const BottomTabs({super.key, required this.selected, required this.onTap});

  static const items = [
    ['🏠', 'الرئيسية'],
    ['💬', 'التواصل'],
    ['🗓️', 'الروتين'],
    ['🤝', 'المواقف'],
    ['🎮', 'الألعاب'],
  ];
  static const hues = [commHue, commHue, routineHue, socialHue, gameHue];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kLine, width: 2)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  decoration: BoxDecoration(
                    color: i == selected ? hues[i].h : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(items[i][0], style: const TextStyle(fontSize: 24)),
                      Text(
                        items[i][1],
                        textAlign: TextAlign.center,
                        style: bodyStyle(
                          size: 12.5,
                          weight:
                          i == selected ? FontWeight.w600 : FontWeight.w500,
                          color: i == selected ? hues[i].hi : kFgSoft,
                        ).copyWith(height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// الدبدوب + فقاعة الكلام
class GuideRow extends StatelessWidget {
  final String text;
  final Hue hue;
  const GuideRow({super.key, required this.text, this.hue = gameHue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Mascot(size: 76),
          const SizedBox(width: 14),
          Expanded(
            child: ThickBox(
              fill: Colors.white,
              border: hue.hs,
              radius: BorderRadius.circular(24),
              bottom: 4,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(text, style: bodyStyle(size: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class Mascot extends StatelessWidget {
  final double size;
  const Mascot({super.key, required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _MascotPainter());
}

class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    c.scale(s.width / 120);
    final fill = Paint()..style = PaintingStyle.fill;
    const natStrong = Color(0xFFE89C47);
    const natInk = Color(0xFF703C08);

    fill.color = natStrong;
    c.drawCircle(const Offset(28, 30), 17, fill);
    c.drawCircle(const Offset(92, 30), 17, fill);

    fill.color = const Color(0xFFFFF4E6);
    c.drawCircle(const Offset(60, 66), 44, fill);
    c.drawCircle(
        const Offset(60, 66),
        44,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = natStrong);

    fill.color = const Color(0x8CE873A2);
    c.drawCircle(const Offset(36, 76), 8, fill);
    c.drawCircle(const Offset(84, 76), 8, fill);

    fill.color = Colors.white;
    c.drawOval(
        Rect.fromCenter(center: const Offset(60, 80), width: 38, height: 28),
        fill);

    fill.color = kFg;
    c.drawCircle(const Offset(45, 58), 5, fill);
    c.drawCircle(const Offset(75, 58), 5, fill);

    fill.color = natInk;
    c.drawOval(
        Rect.fromCenter(center: const Offset(60, 74), width: 12, height: 8),
        fill);

    c.drawPath(
        Path()
          ..moveTo(51, 85)
          ..quadraticBezierTo(60, 93, 69, 85),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = natInk);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}