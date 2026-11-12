import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        'Send',
        Icons.arrow_upward_rounded,
        const Color(0xFF38BDF8),
        () => _showActionSheet(context, 'Send Crypto'),
      ),
      (
        'Receive',
        Icons.arrow_downward_rounded,
        const Color(0xFF10B981),
        () => _showActionSheet(context, 'Receive Crypto'),
      ),
      (
        'Buy',
        Icons.add_shopping_cart_rounded,
        const Color(0xFFF59E0B),
        () => _showActionSheet(context, 'Buy / Deposit'),
      ),
      (
        'Swap',
        Icons.swap_horiz_rounded,
        const Color(0xFFA855F7),
        () => _showActionSheet(context, 'Swap Tokens'),
      ),
    ];

    return Row(
      children: actions
          .map(
            (action) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == actions.last ? 0 : AppSpacing.xs,
                ),
                child: _ActionButton(
                  label: action.$1,
                  icon: action.$2,
                  accentColor: action.$3,
                  onTap: action.$4,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  static void _showActionSheet(BuildContext context, String actionName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.flash_on_rounded, color: Colors.amber, size: 18),
            const SizedBox(width: 8),
            Text(
              '$actionName gateway ready',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          color: colorScheme.surface,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: isDark ? 0.22 : 0.15),
                    accentColor.withValues(alpha: isDark ? 0.08 : 0.05),
                  ],
                ),
                border: Border.all(
                  color: accentColor.withValues(alpha: isDark ? 0.4 : 0.3),
                  width: 1,
                ),
              ),
              child: Icon(icon, size: 20, color: accentColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
