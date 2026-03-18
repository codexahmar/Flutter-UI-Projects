import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
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
      duration: const Duration(milliseconds: 2300),
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
                      IconButton.outlined(
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
                            Text(
                              'Atlas Dashboard',
                              style: textTheme.titleLarge,
                            ),
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
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.00,
                        end: 0.30,
                        child: WalletSummaryCard(
                          totalBalance: provider.totalBalance,
                          invested: provider.investedCapital,
                          unrealized: provider.unrealizedPnl,
                          roi: provider.roiPercent,
                          dailyPnl: provider.dailyPnl,
                          assetsCount: provider.assets.length,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.18,
                        end: 0.48,
                        child: const QuickActionsSection(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.34,
                        end: 0.60,
                        child: const HomeSectionHeader(
                          title: 'Analytics',
                          subtitle: 'Clear portfolio values (7D)',
                          actionText: 'Details',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.50,
                        end: 0.80,
                        child: AnalyticsPreviewCard(
                          points: provider.analyticsSeriesK,
                          roi: provider.roiPercent,
                          dailyPnl: provider.dailyPnl,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AnimatedSection(
                        progress: _staggerController,
                        start: 0.70,
                        end: 0.90,
                        child: HomeSectionHeader(
                          title: 'Top Holdings',
                          subtitle: '${provider.assets.length} assets',
                          actionText: 'See all',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
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
