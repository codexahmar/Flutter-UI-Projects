import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/design_tokens.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    final activeColor = isDark ? Colors.white : Colors.black;
    final inactiveColor = isDark ? AppTokens.darkTextTertiary : AppTokens.lightTextTertiary;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home Tab
              IconButton(
                icon: Icon(
                  selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
                  size: 28,
                  color: selectedIndex == 0 ? activeColor : inactiveColor,
                ),
                tooltip: 'Home',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onTap(0);
                },
              ),

              // 2. Search Tab
              IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  size: 28,
                  color: selectedIndex == 1 ? activeColor : inactiveColor,
                ),
                tooltip: 'Search',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onTap(1);
                },
              ),

              // 3. Create Pin Action
              IconButton(
                icon: Icon(
                  Icons.add_rounded,
                  size: 32,
                  color: selectedIndex == 2 ? activeColor : inactiveColor,
                ),
                tooltip: 'Create',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onTap(2);
                },
              ),

              // 4. Updates / Inbox Tab
              IconButton(
                icon: Icon(
                  selectedIndex == 3 ? Icons.chat_bubble_rounded : Icons.chat_bubble_outline_rounded,
                  size: 26,
                  color: selectedIndex == 3 ? activeColor : inactiveColor,
                ),
                tooltip: 'Updates',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onTap(3);
                },
              ),

              // 5. Profile Tab (User Avatar)
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(4);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedIndex == 4 ? activeColor : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.jpg',
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
