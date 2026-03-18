import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Security controls, limits, and account preferences.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('Verification Status'),
            subtitle: const Text('Level 2 verified'),
            trailing: TextButton(onPressed: () {}, child: const Text('View')),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.lock_outline_rounded),
            title: const Text('Security'),
            subtitle: const Text('2FA, device sessions, passcode'),
            trailing: TextButton(onPressed: () {}, child: const Text('Manage')),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Alerts'),
            subtitle: const Text('Price alerts and execution updates'),
            trailing: TextButton(
              onPressed: () {},
              child: const Text('Configure'),
            ),
          ),
        ),
      ],
    );
  }
}
