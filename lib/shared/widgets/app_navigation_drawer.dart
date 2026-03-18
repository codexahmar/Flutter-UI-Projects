import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return NavigationDrawer(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.18),
                child: Icon(Icons.person_rounded, color: colorScheme.primary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Ahmaryar Khan', style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Growth plan • Verified',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: Text('Home'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.show_chart_rounded),
          selectedIcon: Icon(Icons.query_stats_rounded),
          label: Text('Markets'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet_rounded),
          label: Text('Portfolio'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: Text('Profile'),
        ),
        const Divider(height: 36),
        ListTile(
          leading: const Icon(Icons.security_outlined),
          title: const Text('Security'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.headset_mic_outlined),
          title: const Text('Support'),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
