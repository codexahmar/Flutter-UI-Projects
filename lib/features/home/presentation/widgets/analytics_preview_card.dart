import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/services/mock_crypto_data_service.dart';

class AnalyticsPreviewCard extends StatefulWidget {
  const AnalyticsPreviewCard({
    super.key,
    required this.chartData,
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
  });

  final ChartDataModel chartData;
  final ChartTimeframe selectedTimeframe;
  final ValueChanged<ChartTimeframe> onTimeframeChanged;

  @override
  State<AnalyticsPreviewCard> createState() => _AnalyticsPreviewCardState();
}

class _AnalyticsPreviewCardState extends State<AnalyticsPreviewCard> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final points = widget.chartData.points;
    final labels = widget.chartData.labels;
    final min = widget.chartData.low;
    final max = widget.chartData.high;
    final isGain = widget.chartData.changePercent >= 0;
    final chartColor = isGain ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    final displayValue = _touchedIndex != null &&
            _touchedIndex! >= 0 &&
            _touchedIndex! < points.length
        ? points[_touchedIndex!] * 1000
        : points.last * 1000;

    final displayLabel = _touchedIndex != null &&
            _touchedIndex! >= 0 &&
            _touchedIndex! < labels.length
        ? labels[_touchedIndex!]
        : 'Current';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: colorScheme.surface,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: isDark ? 0.3 : 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Value & Stats + Timeframe Badges
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Interactive Timeframe Selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ChartTimeframe.values.map((tf) {
                      final isSelected = tf == widget.selectedTimeframe;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: InkWell(
                          onTap: () {
                            setState(() => _touchedIndex = null);
                            widget.onTimeframeChanged(tf);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                      ? AppColors.brandBlue.withValues(alpha: 0.22)
                                      : AppColors.brandBlue)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.grey.withValues(alpha: 0.1)),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.brandBlue.withValues(
                                        alpha: isDark ? 0.8 : 1.0,
                                      )
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tf.label,
                              style: textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? (isDark ? Colors.white : Colors.white)
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Scrubber / Value Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              formatCurrency(displayValue),
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (_touchedIndex != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  displayLabel,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              isGain
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              size: 16,
                              color: chartColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${isGain ? '+' : ''}${widget.chartData.changePercent.toStringAsFixed(2)}% (${isGain ? '+' : ''}${formatCompactCurrency(widget.chartData.changeAmount)})',
                              style: textTheme.bodySmall?.copyWith(
                                color: chartColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '• ${widget.selectedTimeframe.description}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Period High / Low
                    Row(
                      children: [
                        _StatChip(
                          label: 'H',
                          value: '\$${max.toStringAsFixed(1)}K',
                          color: const Color(0xFF10B981),
                        ),
                        const SizedBox(width: 6),
                        _StatChip(
                          label: 'L',
                          value: '\$${min.toStringAsFixed(1)}K',
                          color: const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // High Fidelity Crypto Area Line Chart
          SizedBox(
            height: 175,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (points.length - 1).toDouble(),
                minY: min - ((max - min) * 0.15).clamp(0.2, 5.0),
                maxY: max + ((max - min) * 0.12).clamp(0.2, 5.0),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: ((max - min) / 3).clamp(0.5, 30.0),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colorScheme.outline.withValues(alpha: isDark ? 0.12 : 0.25),
                    strokeWidth: 1,
                    dashArray: [4, 4],
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
                      reservedSize: 26,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        // Skip dense labels to keep clean crypto aesthetic
                        if (labels.length > 7 && idx % 2 != 0 && idx != labels.length - 1) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 6,
                          child: Text(
                            labels[idx],
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 10.5,
                              color: colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.8,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchCallback: (event, response) {
                    if (event is FlTapUpEvent || event is FlPanEndEvent) {
                      setState(() => _touchedIndex = null);
                    } else if (response?.lineBarSpots != null &&
                        response!.lineBarSpots!.isNotEmpty) {
                      setState(() {
                        _touchedIndex = response.lineBarSpots!.first.x.toInt();
                      });
                    }
                  },
                  getTouchedSpotIndicator: (barData, indicators) {
                    return indicators.map((_) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: chartColor.withValues(alpha: 0.65),
                          strokeWidth: 1.5,
                          dashArray: [5, 4],
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) =>
                              FlDotCirclePainter(
                            radius: 5.5,
                            color: chartColor,
                            strokeWidth: 2.5,
                            strokeColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    tooltipBorder: BorderSide(
                      color: chartColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                    getTooltipColor: (_) => isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFF0F172A),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final idx = spot.x.toInt();
                        final timeLabel = idx < labels.length ? labels[idx] : '';
                        return LineTooltipItem(
                          '\$${(spot.y * 1000).toStringAsFixed(2)}\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: timeLabel,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      points.length,
                      (i) => FlSpot(i.toDouble(), points[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    preventCurveOverShooting: true,
                    barWidth: 2.8,
                    gradient: LinearGradient(
                      colors: [
                        chartColor,
                        chartColor.withValues(alpha: 0.85),
                      ],
                    ),
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) =>
                          spot.x == (points.length - 1).toDouble(),
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 4.5,
                        color: chartColor,
                        strokeWidth: 2,
                        strokeColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          chartColor.withValues(alpha: isDark ? 0.28 : 0.20),
                          chartColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 10.5,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
