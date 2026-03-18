import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

import '../../../core/theme/app_spacing.dart';
import '../../home/presentation/home_screen.dart';
import '../../markets/presentation/markets_screen.dart';
import '../../portfolio/presentation/portfolio_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<_ShellScaffoldState> _shellKey =
      GlobalKey<_ShellScaffoldState>();
  late KFDrawerController _drawerController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ShellScaffold(
        key: _shellKey,
        onTabChanged: (index) {
          if (!mounted) {
            return;
          }
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.person_rounded,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Ahmaryar Khan', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Pro investor plan',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _DrawerTab(
                    label: 'Home',
                    icon: Icons.home_rounded,
                    selected: _selectedIndex == 0,
                    onTap: () => _selectFromDrawer(0),
                  ),
                  _DrawerTab(
                    label: 'Markets',
                    icon: Icons.query_stats_rounded,
                    selected: _selectedIndex == 1,
                    onTap: () => _selectFromDrawer(1),
                  ),
                  _DrawerTab(
                    label: 'Portfolio',
                    icon: Icons.account_balance_wallet_rounded,
                    selected: _selectedIndex == 2,
                    onTap: () => _selectFromDrawer(2),
                  ),
                  _DrawerTab(
                    label: 'Profile',
                    icon: Icons.person_rounded,
                    selected: _selectedIndex == 3,
                    onTap: () => _selectFromDrawer(3),
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
    _shellKey.currentState?.selectTab(index);
    setState(() => _selectedIndex = index);
    KFDrawer.of(context)?.toggle();
  }
}

class ShellScaffold extends StatefulWidget {
  const ShellScaffold({super.key, required this.onTabChanged});

  final ValueChanged<int> onTabChanged;

  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  int _selectedIndex = 0;

  void selectTab(int index) {
    if (_selectedIndex == index) {
      return;
    }
    setState(() => _selectedIndex = index);
    widget.onTabChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenMenu: _toggleDrawer),
      const MarketsScreen(),
      const PortfolioScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
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
            selectedIndex: _selectedIndex,
            onDestinationSelected: selectTab,
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
  }

  void _toggleDrawer() {
    KFDrawer.of(context)?.toggle();
  }
}

class _DrawerTab extends StatelessWidget {
  const _DrawerTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.14)
                  : Colors.transparent,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
