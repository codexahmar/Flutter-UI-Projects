import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/mock/crypto_assets_mock.dart';
import '../../../models/crypto_asset.dart';
import '../../../shared/widgets/crypto_icon_avatar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final assets = CryptoAssetsMock.portfolioAssets;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                IconButton.filledTonal(
                  onPressed: onOpenMenu,
                  icon: const Icon(Icons.menu_rounded),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: textTheme.bodySmall),
                      const SizedBox(height: 2),
                      Text('Atlas Dashboard', style: textTheme.titleLarge),
                    ],
                  ),
                ),
                IconButton.outlined(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList.list(
            children: [
              _BalanceCard(
                totalBalance: CryptoAssetsMock.totalBalance,
                assetsCount: assets.length,
              ),
              const SizedBox(height: AppSpacing.md),
              const _QuickActionsSection(),
              const SizedBox(height: AppSpacing.lg),
              const _SectionHeader(
                title: 'Analytics',
                subtitle: 'Portfolio movement (7D)',
                actionText: 'Details',
              ),
              const SizedBox(height: AppSpacing.sm),
              const _AnalyticsPreviewCard(),
              const SizedBox(height: AppSpacing.lg),
              _SectionHeader(
                title: 'Top Holdings',
                subtitle: '${assets.length} assets',
                actionText: 'See all',
              ),
              const SizedBox(height: AppSpacing.sm),
              _AssetHoldingsList(assets: assets),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.totalBalance, required this.assetsCount});

  final double totalBalance;
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
          colors: [Color(0xFF0F1C47), Color(0xFF163C94), Color(0xFF0F172A)],
          stops: [0.0, 0.58, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withValues(alpha: 0.25),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -54,
            right: -38,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -72,
            left: -28,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Portfolio value',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                    child: Text(
                      '$assetsCount assets',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _formatCurrency(totalBalance),
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  letterSpacing: -1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '24h PnL  +\$1,184.33',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(color: Colors.white.withValues(alpha: 0.16), height: 1),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invested',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$92.4K',
                        style: textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unrealized',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '+\$8.9K',
                        style: textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      color: AppColors.success.withValues(alpha: 0.16),
                    ),
                    child: Text(
                      '+9.6% ROI',
                      style: textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
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

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

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

class _AnalyticsPreviewCard extends StatelessWidget {
  const _AnalyticsPreviewCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
      ),
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minY: 30,
            maxY: 95,
            gridData: FlGridData(
              show: true,
              horizontalInterval: 15,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(
                strokeWidth: 1,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 24,
                  getTitlesWidget: (value, _) {
                    const labels = [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun',
                    ];
                    final index = value.toInt();
                    if (index < 0 || index >= labels.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      labels[index],
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 48),
                  FlSpot(1, 52),
                  FlSpot(2, 49),
                  FlSpot(3, 68),
                  FlSpot(4, 63),
                  FlSpot(5, 72),
                  FlSpot(6, 83),
                ],
                color: colorScheme.primary,
                barWidth: 3,
                isCurved: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: colorScheme.primary.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetHoldingsList extends StatelessWidget {
  const _AssetHoldingsList({required this.assets});

  final List<CryptoAsset> assets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: assets
          .take(6)
          .map(
            (asset) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _AssetRow(asset: asset),
            ),
          )
          .toList(),
    );
  }
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({required this.asset});

  final CryptoAsset asset;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final value = asset.price * asset.holdings;
    final isGain = asset.change >= 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          CryptoIconAvatar(
            symbol: asset.symbol,
            brandColor: asset.color,
            iconUrl: asset.iconUrl,
            size: 44,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${asset.holdings.toStringAsFixed(2)} ${asset.symbol}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(value),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                '${isGain ? '+' : ''}${asset.change.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isGain ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionText,
  });

  final String title;
  final String subtitle;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(subtitle, style: textTheme.bodySmall),
            ],
          ),
        ),
        TextButton(onPressed: () {}, child: Text(actionText)),
      ],
    );
  }
}

String _formatCurrency(double value) {
  final absolute = value.abs();
  if (absolute >= 1000) {
    final shortValue = (value / 1000).toStringAsFixed(1);
    return '\$${shortValue}K';
  }

  return '\$${value.toStringAsFixed(2)}';
}
