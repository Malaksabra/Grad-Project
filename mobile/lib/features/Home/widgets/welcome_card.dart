import 'package:flutter/material.dart';

import '../home_style.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(bottom: HomeStyle.cardDepth),
      decoration: BoxDecoration(
        color: HomeStyle.welcomeAccent,
        borderRadius: BorderRadius.circular(HomeStyle.cardRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              HomeStyle.welcomeGradientStart,
              HomeStyle.welcomeGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(HomeStyle.cardRadius),
        ),
        child: Row(
          children: [
            Image.asset(HomeAssets.bear, width: 80, height: 80),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أهلاً يا بطلة!',
                      style: textTheme.titleLarge?.copyWith(
                        fontFamily: HomeStyle.headingFont,
                        fontWeight: FontWeight.w700,
                        color: HomeStyle.primaryText,
                      ),
                    ),
                    Text(
                      'يلا نلعب ونتعلم سوا.',
                      style: textTheme.bodyMedium?.copyWith(
                        fontFamily: HomeStyle.bodyFont,
                        color: HomeStyle.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}