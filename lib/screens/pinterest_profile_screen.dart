import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/create_pin_modal.dart';
import '../widgets/masonry_grid.dart';
import '../widgets/pin_detail_modal.dart';
import '../widgets/pinterest_board_card.dart';
import '../widgets/pinterest_icons.dart';
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

class _PinterestProfileScreenState extends State<PinterestProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFilterSearch = false;
  bool _showOrganizeChips = false;
  String _selectedFilter = 'All';
  String _searchText = '';
  final TextEditingController _filterController = TextEditingController();

  static const _filterOptions = ['All', 'Plants', 'Tech'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  List<PinItem> _filterSavedPins(List<PinItem> savedPins) {
    return savedPins.where((p) {
      final matchesCategory = _selectedFilter == 'All' ||
          (_selectedFilter == 'Plants' && _isPlantCategory(p.category)) ||
          (_selectedFilter == 'Tech' && !_isPlantCategory(p.category));
      if (!matchesCategory) return false;
      if (_searchText.isEmpty) return true;
      final q = _searchText.toLowerCase();
      return '${p.title} ${p.category} ${p.author}'.toLowerCase().contains(q);
    }).toList();
  }

  bool _isPlantCategory(String category) {
    final c = category.toLowerCase();
    return c == 'plants' || c == 'botanicals' || c == 'succulents' || c == 'nature';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final allSavedPins = widget.pins.where((p) => p.isSaved).toList();
    final visibleSavedPins = _filterSavedPins(allSavedPins);

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
                indicatorColor: AppTokens.lightTextPrimary,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppTokens.lightTextPrimary,
                unselectedLabelColor: AppTokens.lightTextTertiary,
                labelStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
            padding: const EdgeInsets.fromLTRB(
              AppTokens.space12,
              AppTokens.space12,
              AppTokens.space12,
              AppTokens.space24,
            ),
            children: [
              // Interactive Organize, Search & Create Toolbar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _showOrganizeChips = !_showOrganizeChips);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTokens.space8,
                        vertical: AppTokens.space8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: _showOrganizeChips
                                ? AppTokens.pinterestRed
                                : AppTokens.lightTextPrimary,
                          ),
                          const SizedBox(width: AppTokens.space8),
                          Text(
                            'Organize',
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 13,
                              color: AppTokens.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Filter saved pins',
                        icon: PinterestSearchIcon(
                          active: _showFilterSearch,
                          size: 20,
                          color: _showFilterSearch
                              ? AppTokens.pinterestRed
                              : AppTokens.lightTextPrimary,
                        ),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _showFilterSearch = !_showFilterSearch;
                            if (!_showFilterSearch) {
                              _filterController.clear();
                              _searchText = '';
                            }
                          });
                        },
                      ),
                      IconButton(
                        tooltip: 'Create new board or pin',
                        icon: const PinterestCreateIcon(
                          size: 21,
                          strokeWidth: 2.1,
                          color: AppTokens.lightTextPrimary,
                        ),
                        onPressed: () => CreatePinModal.show(context),
                      ),
                    ],
                  ),
                ],
              ),

              // Expandable Category Filter Chips
              if (_showOrganizeChips)
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppTokens.space4,
                    bottom: AppTokens.space12,
                  ),
                  child: Row(
                    children: _filterOptions.map((option) {
                      final selected = _selectedFilter == option;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppTokens.space8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedFilter = option);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTokens.space16,
                              vertical: AppTokens.space8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppTokens.lightTextPrimary
                                  : AppTokens.lightPill,
                              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                            ),
                            child: Text(
                              option,
                              style: textTheme.labelMedium?.copyWith(
                                color: selected
                                    ? Colors.white
                                    : AppTokens.lightTextPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // Expandable White Filter Search Bar
              if (_showFilterSearch)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppTokens.space16),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTokens.lightBg,
                      borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                      border: Border.all(
                        color: AppTokens.lightPillBorder,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16),
                    child: Row(
                      children: [
                        const PinterestSearchIcon(
                          size: 18,
                          color: AppTokens.lightTextSecondary,
                        ),
                        const SizedBox(width: AppTokens.space8),
                        Expanded(
                          child: TextField(
                            controller: _filterController,
                            onChanged: (val) => setState(() => _searchText = val.trim()),
                            style: textTheme.bodyLarge?.copyWith(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Filter saved pins…',
                              hintStyle: textTheme.bodyMedium?.copyWith(
                                color: AppTokens.lightTextTertiary,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: AppTokens.space8),

              // Pinterest Collage Boards Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppTokens.space12,
                  mainAxisSpacing: AppTokens.space16,
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
                'All pins (${visibleSavedPins.length})',
                style: textTheme.titleMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: AppTokens.space12),

              if (visibleSavedPins.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppTokens.space32),
                  child: Center(
                    child: Text(
                      allSavedPins.isEmpty
                          ? 'No saved pins yet. Tap Save on any pin to add it here.'
                          : 'No saved pins match your filter.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                PinterestMasonryGrid(
                  pins: visibleSavedPins,
                  enableAnimation: false,
                  heroTagPrefix: 'profile',
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  onPinTap: (pin) => PinDetailModal.show(
                    context,
                    pin: pin,
                    allPins: widget.pins,
                    onToggleSave: widget.onToggleSave,
                    heroTagPrefix: 'profile',
                  ),
                  onToggleSave: (pin) {
                    pin.isSaved = !pin.isSaved;
                    widget.onToggleSave();
                  },
                ),
            ],
          ),

          // Tab 2: Created Pins Empty State (#Also: headline + description + 1 clear action)
          Padding(
            padding: const EdgeInsets.all(AppTokens.space32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 44,
                  color: AppTokens.lightTextSecondary,
                ),
                const SizedBox(height: AppTokens.space16),
                Text(
                  'Inspire others with your ideas',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppTokens.space8),
                Text(
                  'Create Pins to showcase your photos, products, and designs.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTokens.space20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTokens.pinterestRed,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: AppTokens.space24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                    ),
                  ),
                  onPressed: () => CreatePinModal.show(context),
                  child: Text(
                    'Create Pin',
                    style: textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
