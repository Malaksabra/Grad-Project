import 'package:flutter/material.dart';

import '../../features/Home/home_progress.dart';

/// Top bar for section pages: back-to-home button and the shared stars badge.
class SectionTopBar extends StatelessWidget {
  const SectionTopBar({super.key, required this.onBack, this.title});

  final VoidCallback onBack;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // First child = right side in RTL.
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF1E2A44),
            ),
            onPressed: onBack,
          ),
          Expanded(
            child: Center(
              child: Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2A44),
                ),
              ),
            ),
          ),
          ListenableBuilder(
            listenable: HomeProgress.instance,
            builder: (context, _) {
              final stars = HomeProgress.instance.stars;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFDCE8F5), width: 2),
                ),
                child: Row(
                  children: [
                    Text(
                      '$stars',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      stars > 0
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: const Color(0xFFF5B82E),
                      size: 24,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Same bar, but usable as Scaffold(appBar: ...) so the page body stays untouched.
/// The text size is capped here so the fixed-height bar never overflows.
class SectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SectionAppBar({super.key, required this.onBack, this.title});

  final VoidCallback onBack;
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.2,
      child: Material(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: SectionTopBar(onBack: onBack, title: title),
        ),
      ),
    );
  }
}