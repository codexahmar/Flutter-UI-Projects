import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme_controller.dart';
import '../../home/presentation/home_screen.dart';
import '../../markets/presentation/markets_screen.dart';
import '../../portfolio/presentation/portfolio_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import 'widgets/drawer_tab.dart';
import 'widgets/theme_mode_tile.dart';
import 'widgets/utility_tile.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final ValueNotifier<int> _selectedTab = ValueNotifier<int>(0);
  final ValueNotifier<int> _homeReplayToken = ValueNotifier<int>(0);
  late final KFDrawerController _drawerController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ShellScaffold(
        selectedTab: _selectedTab,
        homeReplayToken: _homeReplayToken,
        onOpenMenu: _toggleDrawer,
        onTabChanged: (index) {
          if (!mounted) {
            return;
          }
          if (_selectedIndex != 0 && index == 0) {
            _homeReplayToken.value = _homeReplayToken.value + 1;
          }
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  @override
  void dispose() {
    _selectedTab.dispose();
    _homeReplayToken.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final themeController = context.watch<AppThemeController>();

    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.92),
            ],
          ),
        ),
        header: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.82,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.35,
                      ),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: colorScheme.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ahmaryar Khan', style: textTheme.titleSmall),
                            const SizedBox(height: 2),
                            Text(
                              'Portfolio  ${_selectedIndex == 0 ? 'Overview' : 'Active'}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Pro investor plan',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Main',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  DrawerTab(
                    label: 'Home',
                    icon: Icons.home_rounded,
                    selected: _selectedIndex == 0,
                    onTap: () => _selectFromDrawer(0),
                  ),
                  DrawerTab(
                    label: 'Markets',
                    icon: Icons.query_stats_rounded,
                    selected: _selectedIndex == 1,
                    onTap: () => _selectFromDrawer(1),
                  ),
                  DrawerTab(
                    label: 'Portfolio',
                    icon: Icons.account_balance_wallet_rounded,
                    selected: _selectedIndex == 2,
                    onTap: () => _selectFromDrawer(2),
                  ),
                  DrawerTab(
                    label: 'Profile',
                    icon: Icons.person_rounded,
                    selected: _selectedIndex == 3,
                    onTap: () => _selectFromDrawer(3),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Utilities',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  UtilityTile(
                    icon: Icons.notifications_active_outlined,
                    label: 'Price Alerts',
                    onTap: () {},
                  ),
                  UtilityTile(
                    icon: Icons.security_rounded,
                    label: 'Security',
                    onTap: () {},
                  ),
                  UtilityTile(
                    icon: Icons.support_agent_rounded,
                    label: 'Support',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Appearance',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ThemeModeTile(
                    label: 'System',
                    icon: Icons.settings_suggest_rounded,
                    selected:
                        themeController.preference == AppThemePreference.system,
                    onTap: () => _selectTheme(AppThemePreference.system),
                  ),
                  ThemeModeTile(
                    label: 'Light',
                    icon: Icons.light_mode_rounded,
                    selected:
                        themeController.preference == AppThemePreference.light,
                    onTap: () => _selectTheme(AppThemePreference.light),
                  ),
                  ThemeModeTile(
                    label: 'Dark',
                    icon: Icons.dark_mode_rounded,
                    selected:
                        themeController.preference == AppThemePreference.dark,
                    onTap: () => _selectTheme(AppThemePreference.dark),
                  ),
                ],
              ),
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
          ),
        ),
      ),
    );
  }

  void _selectFromDrawer(int index) {
    if (_selectedIndex != 0 && index == 0) {
      _homeReplayToken.value = _homeReplayToken.value + 1;
    }
    _selectedTab.value = index;
    setState(() => _selectedIndex = index);
    _drawerController.close?.call();
  }

  void _selectTheme(AppThemePreference preference) {
    context.read<AppThemeController>().setPreference(preference);
  }

  void _toggleDrawer() {
    _drawerController.toggle?.call();
  }
}

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({
    super.key,
    required this.selectedTab,
    required this.homeReplayToken,
    required this.onOpenMenu,
    required this.onTabChanged,
  });

  final ValueNotifier<int> selectedTab;
  final ValueNotifier<int> homeReplayToken;
  final VoidCallback onOpenMenu;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<int, int>(
      first: selectedTab,
      second: homeReplayToken,
      builder: (context, selectedIndex, replayToken, _) {
        final page = _buildPage(selectedIndex, replayToken);

        return Scaffold(
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0.06, 0),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey('screen-$selectedIndex-$replayToken'),
                child: page,
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  if (selectedTab.value == index) {
                    return;
                  }
                  selectedTab.value = index;
                  onTabChanged(index);
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.candlestick_chart_outlined),
                    selectedIcon: Icon(Icons.candlestick_chart_rounded),
                    label: 'Markets',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.account_balance_wallet_outlined),
                    selectedIcon: Icon(Icons.account_balance_wallet_rounded),
                    label: 'Portfolio',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage(int selectedIndex, int replayToken) {
    switch (selectedIndex) {
      case 0:
        return HomeScreen(
          key: ValueKey('home-$replayToken'),
          onOpenMenu: onOpenMenu,
        );
      case 1:
        return const MarketsScreen();
      case 2:
        return const PortfolioScreen();
      case 3:
      default:
        return const ProfileScreen();
    }
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
  });

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext, A, B, Widget?) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, firstValue, child) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, secondValue, _) {
            return builder(context, firstValue, secondValue, child);
          },
        );
      },
    );
  }
}
