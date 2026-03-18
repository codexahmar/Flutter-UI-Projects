import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';

class WalletSummaryCard extends StatelessWidget {
  const WalletSummaryCard({
    super.key,
    required this.totalBalance,
    required this.invested,
    required this.unrealized,
    required this.roi,
    required this.dailyPnl,
    required this.assetsCount,
  });

  final double totalBalance;
  final double invested;
  final double unrealized;
  final double roi;
  final double dailyPnl;
  final int assetsCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1539), Color(0xFF153A8A), Color(0xFF0A122D)],
          stops: [0.0, 0.58, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withValues(alpha: 0.22),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -50,
            child: _GlowOrb(
              size: 180,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: _GlowOrb(
              size: 190,
              color: const Color(0xFF60A5FA).withValues(alpha: 0.14),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Wallet',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$assetsCount assets',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                formatCompactCurrency(totalBalance),
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  letterSpacing: -1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(
                    dailyPnl >= 0
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: dailyPnl >= 0 ? AppColors.success : AppColors.danger,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '24h ${dailyPnl >= 0 ? '+' : ''}${formatCompactCurrency(dailyPnl)}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(color: Colors.white.withValues(alpha: 0.16), height: 1),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      label: 'Invested',
                      value: formatCompactCurrency(invested),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MetricTile(
                      label: 'Unrealized',
                      value:
                          '${unrealized >= 0 ? '+' : ''}${formatCompactCurrency(unrealized)}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MetricTile(
                      label: 'ROI',
                      value: '${roi >= 0 ? '+' : ''}${roi.toStringAsFixed(2)}%',
                      valueColor: roi >= 0
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: Colors.white.withValues(alpha: 0.07),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.68),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
