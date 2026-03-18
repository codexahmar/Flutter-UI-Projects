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
    final average = points.reduce((a, b) => a + b) / points.length;
    final trendUp = points.last >= points.first;
    final trendColor = trendUp ? AppColors.success : AppColors.danger;
    final smoothed = _movingAverage(points, window: 3);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ],
        ),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -20,
            child: _GlowBlob(
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: -45,
            left: -25,
            child: _GlowBlob(
              size: 120,
              color: trendColor.withValues(alpha: 0.08),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Row(
                  children: [
                    _StatPill(
                      label: 'Now',
                      value: '\$${current.toStringAsFixed(1)}K',
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    _StatPill(
                      label: 'High',
                      value: '\$${max.toStringAsFixed(1)}K',
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: _StatPill(
                        label: 'Low',
                        value: '\$${min.toStringAsFixed(1)}K',
                        alignEnd: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                height: 170,
                child: LineChart(
                  LineChartData(
                    minX: -0.35,
                    maxX: points.length - 0.65,
                    minY: min - 1,
                    maxY: max + 1,
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: ((max - min) / 3).clamp(0.5, 20),
                      drawVerticalLine: true,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (_) => FlLine(
                        strokeWidth: 1,
                        color: colorScheme.outline.withValues(alpha: 0.16),
                      ),
                      getDrawingVerticalLine: (_) => FlLine(
                        strokeWidth: 1,
                        color: colorScheme.outline.withValues(alpha: 0.08),
                      ),
                    ),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: average,
                          dashArray: [6, 4],
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.35,
                          ),
                          strokeWidth: 1.2,
                        ),
                      ],
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
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            const labels = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ];
                            final index = value.round();
                            if ((value - index).abs() > 0.001) {
                              return const SizedBox.shrink();
                            }
                            if (index < 0 || index >= labels.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  labels[index],
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(fontSize: 11),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      getTouchedSpotIndicator: (barData, indicators) {
                        return indicators
                            .map(
                              (_) => TouchedSpotIndicatorData(
                                FlLine(
                                  color: trendColor.withValues(alpha: 0.45),
                                  strokeWidth: 1.2,
                                  dashArray: [4, 3],
                                ),
                                FlDotData(
                                  getDotPainter: (spot, percent, bar, index) =>
                                      FlDotCirclePainter(
                                        radius: 5,
                                        color: trendColor,
                                        strokeWidth: 2,
                                        strokeColor: colorScheme.surface,
                                      ),
                                ),
                              ),
                            )
                            .toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        tooltipBorder: BorderSide.none,
                        getTooltipColor: (_) =>
                            colorScheme.surfaceContainerHighest,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots
                              .map(
                                (spot) => LineTooltipItem(
                                  '\$${spot.y.toStringAsFixed(2)}K',
                                  Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
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
                        color: trendColor.withValues(alpha: 0.18),
                        barWidth: 9,
                        isCurved: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      LineChartBarData(
                        spots: List.generate(
                          smoothed.length,
                          (i) => FlSpot(i.toDouble(), smoothed[i]),
                        ),
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.38,
                        ),
                        barWidth: 2,
                        isCurved: true,
                        dashArray: [8, 5],
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      LineChartBarData(
                        spots: List.generate(
                          points.length,
                          (i) => FlSpot(i.toDouble(), points[i]),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            trendColor.withValues(alpha: 0.9),
                          ],
                        ),
                        barWidth: 3.2,
                        isCurved: true,
                        dotData: FlDotData(
                          show: true,
                          checkToShowDot: (spot, barData) {
                            return spot.x == (points.length - 1).toDouble();
                          },
                          getDotPainter: (spot, percent, bar, index) =>
                              FlDotCirclePainter(
                                radius: 4,
                                color: trendColor,
                                strokeWidth: 2,
                                strokeColor: colorScheme.surface,
                              ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              trendColor.withValues(alpha: 0.26),
                              trendColor.withValues(alpha: 0.02),
                            ],
                          ),
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
                    '7D ${roi >= 0 ? '+' : ''}${roi.toStringAsFixed(2)}%',
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
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, this.size = 140});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

List<double> _movingAverage(List<double> values, {int window = 3}) {
  if (values.isEmpty || window <= 1) {
    return values;
  }

  final output = <double>[];
  for (var i = 0; i < values.length; i++) {
    final start = math.max(0, i - window + 1);
    final slice = values.sublist(start, i + 1);
    final avg = slice.reduce((a, b) => a + b) / slice.length;
    output.add(avg);
  }
  return output;
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
