import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      ('Deposit', Icons.add_card_rounded),
      ('Withdraw', Icons.call_received_rounded),
      ('Swap', Icons.swap_horiz_rounded),
      ('Send', Icons.north_east_rounded),
    ];

    return Row(
      children: actions
          .map(
            (action) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == actions.last ? 0 : AppSpacing.xs,
                ),
                child: _ActionButton(label: action.$1, icon: action.$2),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
