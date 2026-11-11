import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../themes/design_tokens.dart';

class PinterestUpdatesScreen extends StatelessWidget {
  const PinterestUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final updates = [
      _UpdateItem(
        title: 'Studio Ark saved your pin to Architecture',
        time: '2h',
        image: AppAssets.image5,
      ),
      _UpdateItem(
        title: 'New ideas for you: 15 Minimalist Streetwear Looks',
        time: '5h',
        image: AppAssets.image1,
      ),
      _UpdateItem(
        title: 'Julian V added a pin to Studio & Lights',
        time: '1d',
        image: AppAssets.image2,
      ),
      _UpdateItem(
        title: 'Trending in Tokyo: Neon Cyberpunk aesthetics',
        time: '2d',
        image: AppAssets.image3,
      ),
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppTokens.space16, AppTokens.space16, AppTokens.space16, 96),
      children: [
        Text(
          'Updates',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTokens.space16),
        ...updates.map((u) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppTokens.space16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    u.image,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: AppTokens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        u.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTokens.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _UpdateItem {
  final String title;
  final String time;
  final String image;

  _UpdateItem({required this.title, required this.time, required this.image});
}
