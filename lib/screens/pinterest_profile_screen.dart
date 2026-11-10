import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/pin_card.dart';
import '../widgets/pin_detail_modal.dart';

class PinterestProfileScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;
  final List<PinItem> pins;
  final VoidCallback onToggleSave;

  const PinterestProfileScreen({
    super.key,
    required this.themeMode,
    required this.onThemeToggle,
    required this.pins,
    required this.onToggleSave,
  });

  @override
  State<PinterestProfileScreen> createState() => _PinterestProfileScreenState();
}

class _PinterestProfileScreenState extends State<PinterestProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final savedPins = widget.pins.where((p) => p.isSaved).toList();
    final leftSaved = <PinItem>[];
    final rightSaved = <PinItem>[];
    for (int i = 0; i < savedPins.length; i++) {
      if (i % 2 == 0) {
        leftSaved.add(savedPins[i]);
      } else {
        rightSaved.add(savedPins[i]);
      }
    }

    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppTokens.space16, AppTokens.space8, AppTokens.space16, 0),
              child: Column(
                children: [
                  // 1. Top Bar: Share & Settings (Theme Toggle)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.themeMode == ThemeMode.dark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          size: 22,
                        ),
                        tooltip: 'Toggle Theme',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          widget.onThemeToggle();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 22),
                        tooltip: 'Share profile',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile link copied to clipboard'),
                              duration: Duration(milliseconds: 1200),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, size: 22),
                        tooltip: 'Settings',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pinterest settings & preferences'),
                              duration: Duration(milliseconds: 1200),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // 2. Centered User Avatar (Pinterest Style)
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/6.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTokens.space12),

                  // 3. User Name & Verified Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Alex Vance',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_rounded,
                        color: AppTokens.pinterestRed,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@alexvance',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Visual curator & architectural designer · London / Tokyo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '48.2k followers · 542 following',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppTokens.space16),

                  // 4. Action Buttons (Share, Edit profile)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark ? AppTokens.darkPill : AppTokens.lightPill,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                        child: Text(
                          'Share',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTokens.space12),
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark ? AppTokens.darkPill : AppTokens.lightPill,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                        child: Text(
                          'Edit profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTokens.space20),
                ],
              ),
            ),
          ),

          // 5. Sticky Tabs: Saved & Created
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: theme.colorScheme.onSurface,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: theme.colorScheme.onSurface,
                unselectedLabelColor: isDark ? AppTokens.darkTextTertiary : AppTokens.lightTextTertiary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                tabs: const [
                  Tab(text: 'Saved'),
                  Tab(text: 'Created'),
                ],
              ),
              color: theme.scaffoldBackgroundColor,
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Saved Boards & Pins
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppTokens.space12, AppTokens.space12, AppTokens.space12, 96),
            children: [
              // Organize & Filter Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Organize',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.search_rounded, size: 20),
                      const SizedBox(width: 14),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.add_rounded, size: 24),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Create new board'),
                              duration: Duration(milliseconds: 1000),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppTokens.space12),

              // Pinterest Collage Boards Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.78,
                ),
                itemCount: PinterestData.userBoards.length,
                itemBuilder: (context, index) {
                  final board = PinterestData.userBoards[index];
                  return _PinterestBoardCard(board: board);
                },
              ),
              const SizedBox(height: AppTokens.space24),

              // All Pins Header
              Text(
                'All pins (${savedPins.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: AppTokens.space12),

              // Saved Pins Masonry
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: leftSaved.map((pin) {
                        return PinCard(
                          pin: pin,
                          onTap: () => PinDetailModal.show(
                            context,
                            pin: pin,
                            relatedPins: savedPins,
                            onToggleSave: widget.onToggleSave,
                            onSelectPin: (_) {},
                          ),
                          onToggleSave: () {
                            pin.isSaved = !pin.isSaved;
                            widget.onToggleSave();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: AppTokens.space8),
                  Expanded(
                    child: Column(
                      children: rightSaved.map((pin) {
                        return PinCard(
                          pin: pin,
                          onTap: () => PinDetailModal.show(
                            context,
                            pin: pin,
                            relatedPins: savedPins,
                            onToggleSave: widget.onToggleSave,
                            onSelectPin: (_) {},
                          ),
                          onToggleSave: () {
                            pin.isSaved = !pin.isSaved;
                            widget.onToggleSave();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 2: Created Pins
          Padding(
            padding: const EdgeInsets.all(AppTokens.space32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 48,
                  color: isDark ? AppTokens.darkTextTertiary : AppTokens.lightTextTertiary,
                ),
                const SizedBox(height: AppTokens.space16),
                Text(
                  'Inspire others with your ideas',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppTokens.space8),
                Text(
                  'Create Pins to showcase your photos, products, and designs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppTokens.space20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTokens.pinterestRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Create a new pin now'),
                        duration: Duration(milliseconds: 1000),
                      ),
                    );
                  },
                  child: const Text('Create Pin', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Authentic Pinterest Board Collage Card (1 large image on left, 2 stacked on right)
class _PinterestBoardCard extends StatelessWidget {
  final PinterestBoard board;

  const _PinterestBoardCard({required this.board});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Collage Container
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTokens.radiusBoard),
              color: isDark ? AppTokens.darkPill : AppTokens.lightPill,
            ),
            child: Row(
              children: [
                // Left Large Image
                Expanded(
                  flex: 2,
                  child: Image.network(
                    board.mainImage,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/5.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 2),

                // Right 2 Stacked Images
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          board.subImage1,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/1.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: Image.network(
                          board.subImage2,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/2.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Board Title & Pin Count
        Row(
          children: [
            Expanded(
              child: Text(
                board.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            if (board.isSecret)
              const Icon(Icons.lock_rounded, size: 12),
          ],
        ),
        Text(
          '${board.pinCount} Pins · ${board.updatedTime}',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppTokens.darkTextTertiary : AppTokens.lightTextTertiary,
          ),
        ),
      ],
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color color;

  _SliverTabBarDelegate(this.tabBar, {required this.color});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
