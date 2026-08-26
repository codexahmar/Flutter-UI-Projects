import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_controller.dart';
import 'providers/home_provider.dart';
import 'widgets/analytics_preview_card.dart';
import 'widgets/animated_section.dart';
import 'widgets/asset_holdings_list.dart';
import 'widgets/home_section_header.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/wallet_summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onOpenMenu});

  final VoidCallback onOpenMenu;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    _homeProvider = HomeProvider()..load();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _homeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider<HomeProvider>.value(
      value: _homeProvider,
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
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
                      // Menu Drawer Trigger
                      IconButton.outlined(
                        onPressed: widget.onOpenMenu,
                        icon: const Icon(Icons.menu_rounded),
                        style: IconButton.styleFrom(
                          side: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'CryptoVista Wallet',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Theme Toggle Switch Button
                      const _ThemeToggleSwitch(),
                      const SizedBox(width: AppSpacing.xs),
                      // Notifications
                      IconButton.outlined(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No new alerts at this time'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.notifications_none_rounded),
                        style: IconButton.styleFrom(
                          side: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  sliver: SliverList.list(
                    children: [
                      // 1. Web3 Crypto Wallet Card (No circular blobs)
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.00,
                        end: 0.30,
                        child: WalletSummaryCard(
                          totalBalance: provider.totalBalance,
                          btcEquivalent: provider.btcEquivalent,
                          invested: provider.investedCapital,
                          unrealized: provider.unrealizedPnl,
                          roi: provider.roiPercent,
                          dailyPnl: provider.dailyPnl,
                          assetsCount: provider.assets.length,
                          walletAddress: provider.walletAddress,
                          fullWalletAddress: provider.fullWalletAddress,
                          isBalanceHidden: provider.isBalanceHidden,
                          onToggleVisibility: provider.toggleBalanceVisibility,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // 2. Quick Actions (Send, Receive, Buy, Swap)
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.18,
                        end: 0.48,
                        child: const QuickActionsSection(),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // 3. Analytics Chart Header
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.34,
                        end: 0.60,
                        child: HomeSectionHeader(
                          title: 'Portfolio Analytics',
                          subtitle:
                              'Performance (${provider.selectedTimeframe.label})',
                          actionText: 'Details',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 4. Overhauled Crypto Analytics Card (Timeframe switcher & dynamic curve)
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.50,
                        end: 0.80,
                        child: AnalyticsPreviewCard(
                          chartData: provider.chartData,
                          selectedTimeframe: provider.selectedTimeframe,
                          onTimeframeChanged: provider.setTimeframe,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // 5. Holdings Section Header
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.70,
                        end: 0.90,
                        child: HomeSectionHeader(
                          title: 'Top Crypto Holdings',
                          subtitle: '${provider.assets.length} assets in wallet',
                          actionText: 'See all',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // 6. Holdings List
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.82,
                        end: 1.00,
                        child: AssetHoldingsList(assets: provider.assets),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Animated Sun / Moon Theme Switcher for crypto UI
class _ThemeToggleSwitch extends StatelessWidget {
  const _ThemeToggleSwitch();

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<AppThemeController>();
    final isDark = themeController.isDarkMode(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: isDark ? 'Switch to Light mode' : 'Switch to Dark mode',
      child: InkWell(
        onTap: () => themeController.toggleTheme(context),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            color: colorScheme.surface,
            border: Border.all(
              color: isDark
                  ? const Color(0xFFF59E0B).withValues(alpha: 0.35)
                  : AppColors.brandBlue.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? const Color(0xFFF59E0B).withValues(alpha: 0.1)
                    : AppColors.brandBlue.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) {
                  return RotationTransition(
                    turns: anim,
                    child: FadeTransition(opacity: anim, child: child),
                  );
                },
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey<bool>(isDark),
                  size: 18,
                  color: isDark ? const Color(0xFFF59E0B) : AppColors.brandBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
