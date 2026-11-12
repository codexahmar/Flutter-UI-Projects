import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_assets.dart';
import '../themes/design_tokens.dart';
import 'pinterest_icons.dart';

class PinterestNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const PinterestNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const activeColor = AppTokens.lightTextPrimary;
    const inactiveColor = AppTokens.lightTextTertiary;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: AppTokens.shadowChrome,
        border: const Border(
          top: BorderSide(
            color: AppTokens.lightBorder,
            width: 0.6,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home Tab
              _NavItem(
                tooltip: 'Home',
                onTap: () => onTap(0),
                child: PinterestHomeIcon(
                  active: selectedIndex == 0,
                  color: selectedIndex == 0 ? activeColor : inactiveColor,
                  size: 24,
                ),
              ),

              // 2. Search Tab
              _NavItem(
                tooltip: 'Search',
                onTap: () => onTap(1),
                child: PinterestSearchIcon(
                  active: selectedIndex == 1,
                  color: selectedIndex == 1 ? activeColor : inactiveColor,
                  size: 24,
                ),
              ),

              // 3. Create Pin Action
              _NavItem(
                tooltip: 'Create',
                onTap: () => onTap(2),
                child: PinterestCreateIcon(
                  color: selectedIndex == 2 ? activeColor : inactiveColor,
                  size: 25,
                  strokeWidth: 2.15,
                ),
              ),

              // 4. Updates Tab (Distinct from top header Chat bubble)
              _NavItem(
                tooltip: 'Updates',
                onTap: () => onTap(3),
                child: PinterestBellIcon(
                  active: selectedIndex == 3,
                  color: selectedIndex == 3 ? activeColor : inactiveColor,
                  size: 24,
                ),
              ),

              // 5. Profile Tab (User Avatar with inset ring)
              _NavItem(
                itemKey: const ValueKey('profile_tab'),
                tooltip: 'Profile',
                onTap: () => onTap(4),
                child: Container(
                  padding: const EdgeInsets.all(AppTokens.space2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedIndex == 4 ? activeColor : AppTokens.lightBorder,
                      width: selectedIndex == 4 ? 1.8 : 0.8,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppAssets.profile,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final Key? itemKey;
  final String tooltip;
  final VoidCallback onTap;
  final Widget child;

  const _NavItem({
    this.itemKey,
    required this.tooltip,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: TactileScaleTap(
        key: itemKey,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(child: child),
        ),
      ),
    );
  }
}
