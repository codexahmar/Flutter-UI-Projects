import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';

class AnalyticsPreviewCard extends StatelessWidget {
  const AnalyticsPreviewCard({
    super.key,
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
                '24h ${dailyPnl >= 0 ? '+' : ''}${formatCompactCurrency(dailyPnl)}',
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
