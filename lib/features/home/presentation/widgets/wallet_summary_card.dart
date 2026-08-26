import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    this.btcEquivalent = 0.0,
    this.walletAddress = '0x71C8...49B2',
    this.fullWalletAddress = '0x71C824a68C3202C26e3860F5f7FE0F4bCd3149B2',
    this.isBalanceHidden = false,
    this.onToggleVisibility,
  });

  final double totalBalance;
  final double invested;
  final double unrealized;
  final double roi;
  final double dailyPnl;
  final int assetsCount;
  final double btcEquivalent;
  final String walletAddress;
  final String fullWalletAddress;
  final bool isBalanceHidden;
  final VoidCallback? onToggleVisibility;

  void _copyAddress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: fullWalletAddress));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: AppSpacing.xs),
            const Text(
              'Wallet address copied to clipboard',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: AppColors.brandBlue.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dailyPnlPercent = totalBalance > 0
        ? (dailyPnl / (totalBalance - dailyPnl)) * 100
        : 0.0;
    final isGain = dailyPnl >= 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [
                  Color(0xFF0F172A),
                  Color(0xFF162038),
                  Color(0xFF0D1527),
                ]
              : const [
                  Color(0xFF1E293B),
                  Color(0xFF0F172A),
                  Color(0xFF090E17),
                ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: isDark ? 0.6 : 0.25),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.15),
            blurRadius: 36,
            spreadRadius: -4,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          children: [
            // Subtle Cyber Grid & Light Shimmer Lines (Crypto Theme)
            Positioned.fill(
              child: CustomPaint(
                painter: _CryptoCardBackgroundPainter(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Network Pill + Address Copy + Privacy Toggle
                  Row(
                    children: [
                      // Network Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: const Color(0xFF10B981).withValues(alpha: 0.14),
                          border: Border.all(
                            color: const Color(0xFF10B981).withValues(alpha: 0.35),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF10B981),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF10B981),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Ethereum Mainnet',
                              style: textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF34D399),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Wallet Address Pill with Copy
                      InkWell(
                        onTap: () => _copyAddress(context),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                walletAddress,
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.copy_rounded,
                                size: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      // Privacy Toggle Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onToggleVisibility,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: Icon(
                              isBalanceHidden
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Balance Label & Holdings count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Portfolio Balance',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$assetsCount Assets',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Large Balance Display
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Text(
                      isBalanceHidden
                          ? '\$ •••••••••'
                          : formatCurrency(totalBalance),
                      key: ValueKey<bool>(isBalanceHidden),
                      style: textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: isBalanceHidden ? 2 : -0.8,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Crypto Equivalent + 24h P&L Pill
                  Row(
                    children: [
                      // BTC Equivalent
                      Text(
                        isBalanceHidden
                            ? '≈ •••••• BTC'
                            : '≈ ${btcEquivalent.toStringAsFixed(4)} BTC',
                        style: textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFF7931A).withValues(alpha: 0.95),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // 24h Change Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isGain
                              ? const Color(0xFF10B981).withValues(alpha: 0.16)
                              : const Color(0xFFEF4444).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isGain
                                ? const Color(0xFF10B981).withValues(alpha: 0.35)
                                : const Color(0xFFEF4444).withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isGain
                                  ? Icons.arrow_drop_up_rounded
                                  : Icons.arrow_drop_down_rounded,
                              size: 16,
                              color: isGain
                                  ? const Color(0xFF34D399)
                                  : const Color(0xFFF87171),
                            ),
                            Text(
                              '${isGain ? '+' : ''}${dailyPnlPercent.toStringAsFixed(2)}% (${isGain ? '+' : ''}${formatCompactCurrency(dailyPnl)})',
                              style: textTheme.bodySmall?.copyWith(
                                color: isGain
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFFF87171),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.02),
                          Colors.white.withValues(alpha: 0.14),
                          Colors.white.withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Bottom 3 Glassmorphism Metric Tiles
                  Row(
                    children: [
                      Expanded(
                        child: _MetricTile(
                          label: 'Invested',
                          value: isBalanceHidden
                              ? '\$ ••••'
                              : formatCompactCurrency(invested),
                          icon: Icons.account_balance_rounded,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _MetricTile(
                          label: 'Unrealized P&L',
                          value: isBalanceHidden
                              ? '••••'
                              : '${unrealized >= 0 ? '+' : ''}${formatCompactCurrency(unrealized)}',
                          valueColor: unrealized >= 0
                              ? const Color(0xFF34D399)
                              : const Color(0xFFF87171),
                          icon: Icons.show_chart_rounded,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _MetricTile(
                          label: 'All-Time ROI',
                          value: '${roi >= 0 ? '+' : ''}${roi.toStringAsFixed(2)}%',
                          valueColor: roi >= 0
                              ? const Color(0xFF34D399)
                              : const Color(0xFFF87171),
                          icon: Icons.percent_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.valueColor,
    required this.icon,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 11,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Subtle holographic crypto card geometry painter (replaces generic circular blobs)
class _CryptoCardBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Subtle isometric grid lines
    const step = 45.0;
    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.7, size.height),
        paint,
      );
    }

    // Top-right holographic crypto corner accent
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF38BDF8).withValues(alpha: 0.12),
          const Color(0xFF6366F1).withValues(alpha: 0.04),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.9, size.height * 0.1),
          radius: size.width * 0.45,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.1),
      size.width * 0.45,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
