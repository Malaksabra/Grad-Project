import 'package:flutter/material.dart';

import 'home_progress.dart';
import 'home_style.dart';
import 'widgets/section_card.dart';
import 'widgets/welcome_card.dart';
// استيراد شاشة الطفل بالدوائر البصرية
import 'child_dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onSectionTap});

  final ValueChanged<HomeSection>? onSectionTap;

  @override
  Widget build(BuildContext context) {
    final progress = HomeProgress.instance;

    return Scaffold(
      backgroundColor: HomeStyle.screenBackground,
      appBar: AppBar(
        backgroundColor: HomeStyle.appBarBackground,
        scrolledUnderElevation: 0,
        centerTitle: true,
        // الـ leading بيبدأ من اليمين في RTL فالشمس هتظهر فوق يمين
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.light_mode_outlined,
            color: HomeStyle.primaryText,
          ),
        ),
        title: Text(
          'خطوة بخطوة',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: HomeStyle.headingFont,
            fontWeight: FontWeight.w700,
            color: HomeStyle.primaryText,
          ),
        ),
        // الـ actions بتنتهي عند الشمال في RTL فالنجوم هتظهر فوق شمال
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: HomeStyle.screenPadding,
            ),
            child: Center(
              child: ListenableBuilder(
                listenable: progress,
                builder: (context, _) => _StarsBadge(stars: progress.stars),
              ),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: progress,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(HomeStyle.screenPadding),
          children: [
            const WelcomeCard(),
            const SizedBox(height: HomeStyle.cardSpacing),

            // 🌟 كارت الانتقال لعالم الطفل (مضاف بكل هدوء وبنفس استايل التطبيق)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChildDashboardScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F6E8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF4CBB7F), width: 2),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFFE0B2),
                      radius: 22,
                      child: Text('👶', style: TextStyle(fontSize: 22)),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'دخول لوحة طفلي البصرية 🌟',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B4D2E),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'الدوائر البصرية والأنشطة',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF1B4D2E), size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: HomeStyle.cardSpacing),

            Text(
              'نبدأ بإيه؟',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: HomeStyle.headingFont,
                fontWeight: FontWeight.w700,
                color: HomeStyle.primaryText,
              ),
            ),
            const SizedBox(height: HomeStyle.cardSpacing),
            _buildSection(
              progress,
              HomeSection.communication,
              title: 'التواصل',
              description: 'أقول وأفهم',
              iconAsset: HomeAssets.communication,
              colors: HomeStyle.communication,
            ),
            _buildSection(
              progress,
              HomeSection.dailyRoutine,
              title: 'الروتين اليومي',
              description: 'يومي خطوة بخطوة',
              iconAsset: HomeAssets.routines,
              colors: HomeStyle.dailyRoutine,
            ),
            _buildSection(
              progress,
              HomeSection.socialSituations,
              title: 'المواقف الاجتماعية',
              description: 'ألعب مع الناس',
              iconAsset: HomeAssets.socialSituations,
              colors: HomeStyle.socialSituations,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      HomeProgress progress,
      HomeSection section, {
        required String title,
        required String description,
        required String iconAsset,
        required HomeSectionColors colors,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HomeStyle.cardSpacing),
      child: SectionCard(
        title: title,
        description: description,
        iconAsset: iconAsset,
        colors: colors,
        completed: progress.completedOf(section),
        total: progress.totalOf(section),
        onTap: onSectionTap == null ? null : () => onSectionTap!(section),
      ),
    );
  }
}

class _StarsBadge extends StatelessWidget {
  const _StarsBadge({required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HomeStyle.badgeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: HomeStyle.star),
          const SizedBox(width: 6),
          Text(
            '$stars',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: HomeStyle.headingFont,
              fontWeight: FontWeight.w700,
              color: HomeStyle.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}