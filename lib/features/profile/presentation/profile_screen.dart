import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/animated_entrance.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AnimatedEntrance(
          child: Text('Profile', style: textTheme.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.xs),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 70),
          child: Text(
            'Manage account, security, and notification preferences.',
            style: textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 120),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isLight
                      ? const Color(0xFFE7EEFF)
                      : colorScheme.primary.withValues(alpha: 0.22),
                  isLight
                      ? const Color(0xFFDDF8F1)
                      : colorScheme.secondary.withValues(alpha: 0.18),
                ],
              ),
              border: Border.all(
                color: isLight
                    ? colorScheme.primary.withValues(alpha: 0.25)
                    : colorScheme.outline.withValues(alpha: 0.22),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isLight
                      ? colorScheme.primary.withValues(alpha: 0.14)
                      : colorScheme.primary.withValues(alpha: 0.18),
                  child: Icon(
                    Icons.person_rounded,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ahmaryar Khan', style: textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        'Pro Investor Plan',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: isLight
                              ? const Color(0xFFDCFCE7)
                              : Colors.green.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Verified Level 2',
                          style: textTheme.bodySmall?.copyWith(
                            color: isLight
                                ? const Color(0xFF166534)
                                : Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 170),
          child: const Row(
            children: [
              Expanded(
                child: _ProfileStatCard(
                  label: 'Devices',
                  value: '3',
                  icon: Icons.devices_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _ProfileStatCard(
                  label: 'Alerts',
                  value: '12',
                  icon: Icons.notifications_active_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _ProfileStatCard(
                  label: 'Sessions',
                  value: '2',
                  icon: Icons.shield_outlined,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 230),
          child: Text('Security', style: textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpacing.xs),
        const AnimatedEntrance(
          delay: Duration(milliseconds: 260),
          child: _ProfileOptionTile(
            icon: Icons.verified_user_outlined,
            title: 'Verification Status',
            subtitle: 'Level 2 verified and trading enabled',
            actionText: 'View',
          ),
        ),
        const AnimatedEntrance(
          delay: Duration(milliseconds: 290),
          child: _ProfileOptionTile(
            icon: Icons.lock_outline_rounded,
            title: 'Security Controls',
            subtitle: '2FA, passcode, trusted devices',
            actionText: 'Manage',
          ),
        ),
        const AnimatedEntrance(
          delay: Duration(milliseconds: 320),
          child: _ProfileOptionTile(
            icon: Icons.credit_card_rounded,
            title: 'Withdrawal Limits',
            subtitle: 'Daily limit and whitelist rules',
            actionText: 'Update',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 350),
          child: Text('Preferences', style: textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpacing.xs),
        const AnimatedEntrance(
          delay: Duration(milliseconds: 380),
          child: _ProfileOptionTile(
            icon: Icons.notifications_active_outlined,
            title: 'Alerts',
            subtitle: 'Price alerts and execution updates',
            actionText: 'Configure',
          ),
        ),
        const AnimatedEntrance(
          delay: Duration(milliseconds: 410),
          child: _ProfileOptionTile(
            icon: Icons.language_rounded,
            title: 'Language & Region',
            subtitle: 'English (US), USD',
            actionText: 'Edit',
          ),
        ),
        const AnimatedEntrance(
          delay: Duration(milliseconds: 440),
          child: _ProfileOptionTile(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: 'Theme and visual options',
            actionText: 'Open',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedEntrance(
          delay: const Duration(milliseconds: 470),
          child: Card(
            color: isLight
                ? const Color(0xFFFFF4DA)
                : colorScheme.errorContainer.withValues(alpha: 0.55),
            child: ListTile(
              leading: Icon(
                Icons.warning_amber_rounded,
                color: isLight ? const Color(0xFFB45309) : colorScheme.error,
              ),
              title: Text(
                'Backup Recovery Codes',
                style: textTheme.titleSmall?.copyWith(
                  color: isLight ? const Color(0xFF7C2D12) : null,
                ),
              ),
              subtitle: Text(
                'Last backup: 48 days ago',
                style: textTheme.bodySmall?.copyWith(
                  color: isLight ? const Color(0xFF9A3412) : null,
                ),
              ),
              trailing: TextButton(
                onPressed: () {},
                child: Text(
                  'Backup',
                  style: TextStyle(
                    color: isLight ? const Color(0xFFB45309) : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: textTheme.titleMedium),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: TextButton(onPressed: () {}, child: Text(actionText)),
      ),
    );
  }
}
