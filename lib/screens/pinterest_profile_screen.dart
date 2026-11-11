import 'package:flutter/material.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/masonry_grid.dart';
import '../widgets/pin_detail_modal.dart';
import '../widgets/pinterest_board_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/sliver_tab_bar_delegate.dart';

class PinterestProfileScreen extends StatefulWidget {
  final List<PinItem> pins;
  final VoidCallback onToggleSave;

  const PinterestProfileScreen({
    super.key,
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
    final savedPins = widget.pins.where((p) => p.isSaved).toList();

    return NestedScrollView(
      physics: const BouncingScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          const SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.black,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.black,
                unselectedLabelColor: AppTokens.lightTextTertiary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                  return PinterestBoardCard(board: board);
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

              // Saved Pins Masonry Grid
              PinterestMasonryGrid(
                pins: savedPins,
                enableAnimation: false,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                onPinTap: (pin) => PinDetailModal.show(
                  context,
                  pin: pin,
                  allPins: widget.pins,
                  onToggleSave: widget.onToggleSave,
                ),
                onToggleSave: (pin) {
                  pin.isSaved = !pin.isSaved;
                  widget.onToggleSave();
                },
              ),
            ],
          ),

          // Tab 2: Created Pins Empty State
          Padding(
            padding: const EdgeInsets.all(AppTokens.space32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 48,
                  color: AppTokens.lightTextTertiary,
                ),
                const SizedBox(height: AppTokens.space16),
                Text(
                  'Inspire others with your ideas',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppTokens.space8),
                const Text(
                  'Create Pins to showcase your photos, products, and designs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTokens.lightTextSecondary,
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
