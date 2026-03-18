import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/mock/crypto_assets_mock.dart';
import '../../../models/crypto_asset.dart';
import '../../../shared/widgets/crypto_icon_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final assets = CryptoAssetsMock.portfolioAssets;
    final totalBalance = CryptoAssetsMock.totalBalance;
    final invested = CryptoAssetsMock.investedCapital;
    final unrealized = CryptoAssetsMock.unrealizedPnl;
    final roi = CryptoAssetsMock.roiPercent;
    final dailyPnl = CryptoAssetsMock.dailyPnl;
    final analyticsSeries = CryptoAssetsMock.analyticsSeriesK;

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
                  onPressed: widget.onOpenMenu,
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
              _AnimatedSection(
                progress: _staggerController,
                start: 0.00,
                end: 0.30,
                child: _WalletSummaryCard(
                  totalBalance: totalBalance,
                  invested: invested,
                  unrealized: unrealized,
                  roi: roi,
                  dailyPnl: dailyPnl,
                  assetsCount: assets.length,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _AnimatedSection(
                progress: _staggerController,
                start: 0.18,
                end: 0.48,
                child: const _QuickActionsSection(),
              ),
              const SizedBox(height: AppSpacing.lg),
              _AnimatedSection(
                progress: _staggerController,
                start: 0.34,
                end: 0.60,
                child: const _SectionHeader(
                  title: 'Analytics',
                  subtitle: 'Clear portfolio values (7D)',
                  actionText: 'Details',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _AnimatedSection(
                progress: _staggerController,
                start: 0.50,
                end: 0.80,
                child: _AnalyticsPreviewCard(
                  points: analyticsSeries,
                  roi: roi,
                  dailyPnl: dailyPnl,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _AnimatedSection(
                progress: _staggerController,
                start: 0.70,
                end: 0.90,
                child: _SectionHeader(
                  title: 'Top Holdings',
                  subtitle: '${assets.length} assets',
                  actionText: 'See all',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _AnimatedSection(
                progress: _staggerController,
                start: 0.82,
                end: 1.00,
                child: _AssetHoldingsList(assets: assets),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalletSummaryCard extends StatelessWidget {
  const _WalletSummaryCard({
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
                _formatCurrency(totalBalance),
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
                    '24h ${dailyPnl >= 0 ? '+' : ''}${_formatCurrency(dailyPnl)}',
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
                      value: _formatCurrency(invested),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MetricTile(
                      label: 'Unrealized',
                      value:
                          '${unrealized >= 0 ? '+' : ''}${_formatCurrency(unrealized)}',
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

class _AnimatedSection extends StatelessWidget {
  const _AnimatedSection({
    required this.progress,
    required this.start,
    required this.end,
    required this.child,
  });

  final Animation<double> progress;
  final double start;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fadeCurve = CurvedAnimation(
      parent: progress,
      curve: Interval(start, end, curve: Curves.easeOutQuart),
    );
    final dropCurve = CurvedAnimation(
      parent: progress,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: progress,
      child: child,
      builder: (context, animatedChild) {
        final fadeT = fadeCurve.value;
        final dropT = dropCurve.value;
        const dropDistance = -78.0;
        const initialScale = 0.93;
        final scale = initialScale + (1 - initialScale) * fadeT;
        final dy = dropDistance * (1 - dropT);

        return Opacity(
          opacity: fadeT,
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: animatedChild,
            ),
          ),
        );
      },
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
  const _AnalyticsPreviewCard({
    required this.points,
    required this.roi,
    required this.dailyPnl,
  });

  final List<double> points;
  final double roi;
  final double dailyPnl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final min = points.reduce(math.min);
    final max = points.reduce(math.max);
    final current = points.last;

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: [
                _StatPill(
                  label: 'Current',
                  value: '\$${current.toStringAsFixed(1)}K',
                ),
                const SizedBox(width: AppSpacing.xs),
                _StatPill(
                  label: '7D High',
                  value: '\$${max.toStringAsFixed(1)}K',
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StatPill(
                    label: '7D Low',
                    value: '\$${min.toStringAsFixed(1)}K',
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 170,
            child: LineChart(
              LineChartData(
                minY: min - 1,
                maxY: max + 1,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: ((max - min) / 3).clamp(0.5, 20),
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
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBorder: BorderSide.none,
                    getTooltipColor: (_) => colorScheme.surfaceContainerHighest,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots
                          .map(
                            (spot) => LineTooltipItem(
                              '\$${spot.y.toStringAsFixed(2)}K',
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                          .toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      points.length,
                      (i) => FlSpot(i.toDouble(), points[i]),
                    ),
                    color: colorScheme.primary,
                    barWidth: 3,
                    isCurved: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, line, index) =>
                          FlDotCirclePainter(
                            radius: 2.4,
                            color: colorScheme.primary,
                            strokeWidth: 1.2,
                            strokeColor: colorScheme.surface,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: colorScheme.primary.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '7D change ${roi >= 0 ? '+' : ''}${roi.toStringAsFixed(2)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: roi >= 0 ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '24h ${dailyPnl >= 0 ? '+' : ''}${_formatCurrency(dailyPnl)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      ),
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall),
          Text(
            value,
            style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
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
  if (absolute >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (absolute >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(1)}K';
  }

  return '\$${value.toStringAsFixed(2)}';
}
