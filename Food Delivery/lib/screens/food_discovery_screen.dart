import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ai_food_delivery/data/demo_food_data.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/screens/order_confirmation_screen.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_menu_card.dart';
import 'package:ai_food_delivery/widgets/restaurant_card.dart';
import 'package:ai_food_delivery/widgets/section_header.dart';
import 'package:ai_food_delivery/widgets/sticky_order_bar.dart';

/// Editorial food discovery screen with isolated auto-slider and responsive controls.
class FoodDiscoveryScreen extends StatefulWidget {
  const FoodDiscoveryScreen({super.key});

  @override
  State<FoodDiscoveryScreen> createState() => _FoodDiscoveryScreenState();
}

class _FoodDiscoveryScreenState extends State<FoodDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedCategoryIndex = 0;
  int? _selectedFoodIndex;
  String? _selectedRestaurantName;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredFoods {
    final categoryLabel = kDemoCategories[_selectedCategoryIndex].label;
    final query = _searchQuery.trim().toLowerCase();

    return kDemoFoods.where((food) {
      final matchesCategory =
          categoryLabel == 'All' || food.category == categoryLabel;
      final matchesRestaurant = _selectedRestaurantName == null ||
          food.restaurant == _selectedRestaurantName;
      final matchesQuery = query.isEmpty ||
          food.name.toLowerCase().contains(query) ||
          food.restaurant.toLowerCase().contains(query) ||
          food.description.toLowerCase().contains(query);
      return matchesCategory && matchesRestaurant && matchesQuery;
    }).toList();
  }

  Future<void> _openCheckout(FoodItem food) async {
    final didPlaceOrder = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(food: food),
      ),
    );
    if (didPlaceOrder == true && mounted) {
      setState(() => _selectedFoodIndex = null);
    }
  }

  void _toggleFoodSelection(int globalIndex) {
    setState(() {
      _selectedFoodIndex =
          _selectedFoodIndex == globalIndex ? null : globalIndex;
    });
  }

  void _handleBagTap() {
    if (_selectedFoodIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select any dish to add it to your bag.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    _openCheckout(kDemoFoods[_selectedFoodIndex!]);
  }

  void _toggleRestaurantFilter(String restaurantName) {
    setState(() {
      _selectedRestaurantName =
          _selectedRestaurantName == restaurantName ? null : restaurantName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleFoods = _filteredFoods;
    final selectedFood =
        _selectedFoodIndex != null ? kDemoFoods[_selectedFoodIndex!] : null;
    final bagCount = selectedFood == null ? 0 : 1;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: FoodColors.canvas,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      FoodSpacing.lg,
                      FoodSpacing.md,
                      FoodSpacing.lg,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    6,
                                    6,
                                    FoodSpacing.md + 2,
                                    6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: FoodColors.surface,
                                    borderRadius:
                                        BorderRadius.circular(FoodRadius.pill),
                                    border:
                                        Border.all(color: FoodColors.border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: FoodColors.accentTint,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.location_solid,
                                          color: FoodColors.accent,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(width: FoodSpacing.sm),
                                      Flexible(
                                        child: Text(
                                          'Home · Street 8, F-10/3',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: FoodText.title.copyWith(
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: FoodSpacing.md),
                            Tooltip(
                              message: bagCount == 0
                                  ? 'Bag is empty'
                                  : 'Open checkout bag',
                              child: InkWell(
                                onTap: _handleBagTap,
                                customBorder: const CircleBorder(),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: FoodColors.surface,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: FoodColors.border,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: FoodColors.shadow,
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.bag,
                                        size: 19,
                                        color: FoodColors.textPrimary,
                                      ),
                                    ),
                                    Positioned(
                                      top: -4,
                                      right: -3,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 120),
                                        constraints: const BoxConstraints(
                                          minWidth: 20,
                                          minHeight: 20,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: bagCount > 0
                                              ? FoodColors.accent
                                              : FoodColors.textPrimary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: FoodColors.canvas,
                                            width: 1.5,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$bagCount',
                                          style: FoodText.tabular.copyWith(
                                            fontSize: 11,
                                            color: FoodColors.inkOnAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: FoodSpacing.xl),
                        Text(
                          'Fresh flavors, delivered fast',
                          style: FoodText.headline,
                        ),
                        const SizedBox(height: FoodSpacing.lg),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(FoodRadius.pill),
                            boxShadow: const [
                              BoxShadow(
                                color: FoodColors.shadow,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            style: FoodText.body,
                            decoration: InputDecoration(
                              hintText: 'Search dishes or kitchens',
                              prefixIcon: const Icon(
                                CupertinoIcons.search,
                                size: 18,
                                color: FoodColors.textSecondary,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      tooltip: 'Clear search',
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.xmark_circle_fill,
                                        size: 17,
                                        color: FoodColors.textSecondary,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: FoodSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: FoodSpacing.lg),
                    scrollDirection: Axis.horizontal,
                    itemCount: kDemoCategories.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: FoodSpacing.sm),
                    itemBuilder: (context, index) {
                      final category = kDemoCategories[index];
                      final isActive = index == _selectedCategoryIndex;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategoryIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: FoodSpacing.md + 2,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? FoodColors.textPrimary
                                : FoodColors.surface,
                            borderRadius:
                                BorderRadius.circular(FoodRadius.pill),
                            border: Border.all(
                              color: isActive
                                  ? FoodColors.textPrimary
                                  : FoodColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category.icon,
                                size: 14,
                                color: isActive
                                    ? FoodColors.inkOnDark
                                    : FoodColors.textSecondary,
                              ),
                              const SizedBox(width: FoodSpacing.xs + 2),
                              Text(
                                category.label,
                                style: FoodText.caption.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isActive
                                      ? FoodColors.inkOnDark
                                      : FoodColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: FoodSpacing.xl)),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: FoodSpacing.lg),
                  child: SectionHeader(
                    title: 'Featured restaurants',
                    trailingText:
                        _selectedRestaurantName != null ? 'Show all' : null,
                    onTrailingTap: _selectedRestaurantName != null
                        ? () => setState(() => _selectedRestaurantName = null)
                        : null,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: FoodSpacing.md)),
              SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: _FeaturedRestaurantsSlider(
                    selectedRestaurantName: _selectedRestaurantName,
                    onRestaurantTap: _toggleRestaurantFilter,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: FoodSpacing.xl)),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: FoodSpacing.lg),
                  child: SectionHeader(
                    title: _selectedRestaurantName ?? 'Popular dishes',
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: FoodSpacing.md)),
              if (visibleFoods.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: FoodSpacing.lg),
                    child: Container(
                      padding: const EdgeInsets.all(FoodSpacing.xl),
                      decoration: BoxDecoration(
                        color: FoodColors.surface,
                        borderRadius: BorderRadius.circular(FoodRadius.md),
                        border: Border.all(color: FoodColors.border),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            CupertinoIcons.search,
                            color: FoodColors.textSecondary,
                            size: 26,
                          ),
                          const SizedBox(height: FoodSpacing.sm),
                          Text('No dishes match that filter',
                              style: FoodText.title),
                          const SizedBox(height: FoodSpacing.xs),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _selectedCategoryIndex = 0;
                                _selectedRestaurantName = null;
                              });
                            },
                            child: const Text('Reset filters'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: FoodSpacing.lg),
                  sliver: SliverList.separated(
                    itemCount: visibleFoods.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: FoodSpacing.md),
                    itemBuilder: (context, index) {
                      final food = visibleFoods[index];
                      final globalIndex = kDemoFoods.indexOf(food);
                      return RepaintBoundary(
                        child: FoodMenuCard(
                          food: food,
                          isSelected: globalIndex == _selectedFoodIndex,
                          onSelect: () => _toggleFoodSelection(globalIndex),
                          onOpenCheckout: () {
                            setState(() => _selectedFoodIndex = globalIndex);
                            _openCheckout(food);
                          },
                        ),
                      );
                    },
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: bottomPadding + (selectedFood != null ? 108 : 32),
                ),
              ),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: selectedFood != null ? 0 : -130,
            child: selectedFood != null
                ? StickyOrderBar(
                    food: selectedFood,
                    onCheckout: () => _openCheckout(selectedFood),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Self-contained featured restaurant carousel so auto-slide ticks never rebuild the full screen.
class _FeaturedRestaurantsSlider extends StatefulWidget {
  final String? selectedRestaurantName;
  final ValueChanged<String> onRestaurantTap;

  const _FeaturedRestaurantsSlider({
    required this.selectedRestaurantName,
    required this.onRestaurantTap,
  });

  @override
  State<_FeaturedRestaurantsSlider> createState() =>
      _FeaturedRestaurantsSliderState();
}

class _FeaturedRestaurantsSliderState
    extends State<_FeaturedRestaurantsSlider> {
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.80);
    _startAutoSlider();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlider() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_activePage + 1) % kFeaturedRestaurants.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _pauseAutoSlider() {
    _autoSlideTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 214,
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction != ScrollDirection.idle) {
                _pauseAutoSlider();
              } else {
                _startAutoSlider();
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              padEnds: false,
              clipBehavior: Clip.none,
              itemCount: kFeaturedRestaurants.length,
              onPageChanged: (index) => setState(() => _activePage = index),
              itemBuilder: (context, index) {
                final spot = kFeaturedRestaurants[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? FoodSpacing.lg : 0,
                    right: FoodSpacing.md,
                  ),
                  child: RestaurantCard(
                    spot: spot,
                    isSelected: widget.selectedRestaurantName == spot.name,
                    onTap: () => widget.onRestaurantTap(spot.name),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: FoodSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(kFeaturedRestaurants.length, (i) {
            final active = i == _activePage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? FoodColors.accent : FoodColors.border,
                borderRadius: BorderRadius.circular(FoodRadius.pill),
              ),
            );
          }),
        ),
      ],
    );
  }
}
