import '../theme/section_colors.dart';

const String _imagesFolder = 'assets/images/navigation';

/// The main sections of the app, in tab bar order.
/// The first tab appears on the right because the app is right-to-left.
enum AppTab {
  home(
    label: '\u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629',
    imagePath: '$_imagesFolder/home.png',
    palette: SectionColors.home,
  ),
  communication(
    label: '\u0627\u0644\u062A\u0648\u0627\u0635\u0644',
    imagePath: '$_imagesFolder/communication.png',
    palette: SectionColors.communication,
  ),
  routines(
    label:
        '\u0627\u0644\u0631\u0648\u062A\u064A\u0646 \u0627\u0644\u064A\u0648\u0645\u064A',
    imagePath: '$_imagesFolder/routines.png',
    palette: SectionColors.routines,
  ),
  socialSituations(
    label:
        '\u0627\u0644\u0645\u0648\u0627\u0642\u0641 \u0627\u0644\u0627\u062C\u062A\u0645\u0627\u0639\u064A\u0629',
    imagePath: '$_imagesFolder/social_situations.png',
    palette: SectionColors.socialSituations,
  ),
  play(
    label: '\u0627\u0644\u0644\u0639\u0628',
    imagePath: '$_imagesFolder/play.png',
    palette: SectionColors.play,
  );

  const AppTab({
    required this.label,
    required this.imagePath,
    required this.palette,
  });

  final String label;
  final String imagePath;
  final SectionPalette palette;
}
