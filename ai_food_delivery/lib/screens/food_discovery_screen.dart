import 'package:flutter/material.dart';
import 'package:ai_food_delivery/data/demo_food_data.dart';
import 'package:ai_food_delivery/models/food_item.dart';
import 'package:ai_food_delivery/screens/order_confirmation_screen.dart';
import 'package:ai_food_delivery/theme/app_theme.dart';
import 'package:ai_food_delivery/widgets/food_menu_card.dart';
import 'package:ai_food_delivery/widgets/restaurant_card.dart';
import 'package:ai_food_delivery/widgets/section_header.dart';
import 'package:ai_food_delivery/widgets/sticky_order_bar.dart';

/// Main menu and restaurant discovery screen.
class FoodDiscoveryScreen extends StatefulWidget {
  const FoodDiscoveryScreen({super.key});

  @override
  State<FoodDiscoveryScreen> createState() => _FoodDiscoveryScreenState();
}

class _FoodDiscoveryScreenState extends State<FoodDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedCategoryIndex = 0;
  String? _selectedRestaurant;
  FoodItem? _selectedFood;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredFoods {
    final category = kDemoCategories[_selectedCategoryIndex].label;
    final needle = _query.trim().toLowerCase();

    return kDemoFoods.where((food) {
      final matchesCategory = category == 'All' || food.category == category;
      final matchesRestaurant =
          _selectedRestaurant == null || food.restaurant == _selectedRestaurant;
      final matchesQuery =
          needle.isEmpty ||
          food.name.toLowerCase().contains(needle) ||
          food.restaurant.toLowerCase().contains(needle) ||
          food.category.toLowerCase().contains(needle);
      return matchesCategory && matchesRestaurant && matchesQuery;
    }).toList();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedCategoryIndex = 0;
      _selectedRestaurant = null;
      _selectedFood = null;
    });
  }

  Future<void> _openCheckout(FoodItem food) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => OrderConfirmationScreen(food: food),
      ),
    );
    if (!mounted) return;
    setState(() => _selectedFood = null);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final visibleFoods = _filteredFoods;
    final bottomInset = _selectedFood != null ? 104.0 : FoodSpacing.xl;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                FoodSpacing.lg,
                FoodSpacing.lg,
                FoodSpacing.lg,
                bottomInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('F-10/2, Islamabad', style: textTheme.bodySmall),
                  const SizedBox(height: FoodSpacing.xs),
                  Text(
                    'Fresh flavors, delivered fast',
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: FoodSpacing.lg),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search dishes or restaurants',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: FoodColors.textSecondary,
                      ),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: BorderSide.none,
                              ),
                              icon: const Icon(Icons.close_rounded, size: 18),
                            ),
                    ),
                  ),
                  const SizedBox(height: FoodSpacing.lg),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: kDemoCategories.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: FoodSpacing.sm),
                      itemBuilder: (context, index) {
                        final category = kDemoCategories[index];
                        final selected = _selectedCategoryIndex == index;
                        return _CategoryChip(
                          category: category,
                          selected: selected,
                          onTap: () => setState(() {
                            _selectedCategoryIndex = index;
                            _selectedFood = null;
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: FoodSpacing.xl),
                  SectionHeader(
                    title: 'Featured restaurants',
                    trailingText: _selectedRestaurant != null
                        ? 'Show all'
                        : '${kFeaturedRestaurants.length}',
                    onTrailingTap: _selectedRestaurant != null
                        ? () => setState(() => _selectedRestaurant = null)
                        : null,
                  ),
                  const SizedBox(height: FoodSpacing.md),
                  SizedBox(
                    height: 190,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: kFeaturedRestaurants.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: FoodSpacing.md),
                      itemBuilder: (context, index) {
                        final spot = kFeaturedRestaurants[index];
                        final selected = _selectedRestaurant == spot.name;
                        return RestaurantCard(
                          restaurant: spot,
                          selected: selected,
                          onTap: () => setState(() {
                            _selectedRestaurant = selected ? null : spot.name;
                            _selectedFood = null;
                          }),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: FoodSpacing.xl),
                  SectionHeader(
                    title: _selectedRestaurant ?? 'Menu',
                    trailingText: '${visibleFoods.length}',
                  ),
                  const SizedBox(height: FoodSpacing.md),
                  if (visibleFoods.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(FoodSpacing.lg),
                      decoration: BoxDecoration(
                        color: FoodColors.surface,
                        borderRadius: BorderRadius.circular(FoodRadius.lg),
                        border: Border.all(color: FoodColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No matching dishes', style: textTheme.titleMedium),
                          const SizedBox(height: FoodSpacing.xs),
                          Text(
                            'Try clearing filters or searching another craving.',
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(height: FoodSpacing.md),
                          FilledButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear filters'),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: visibleFoods.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: FoodSpacing.md),
                      itemBuilder: (context, index) {
                        final food = visibleFoods[index];
                        final selected = _selectedFood?.name == food.name;
                        return FoodMenuCard(
                          food: food,
                          selected: selected,
                          onTap: () => setState(() {
                            _selectedFood = selected ? null : food;
                          }),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            left: FoodSpacing.lg,
            right: FoodSpacing.lg,
            bottom: _selectedFood != null ? FoodSpacing.lg : -110,
            child: SafeArea(
              top: false,
              child: _selectedFood == null
                  ? const SizedBox.shrink()
                  : StickyOrderBar(
                      food: _selectedFood!,
                      onContinue: () => _openCheckout(_selectedFood!),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final FoodCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FoodColors.accent : FoodColors.surface,
      borderRadius: BorderRadius.circular(FoodRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FoodRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FoodSpacing.lg,
            vertical: FoodSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FoodRadius.pill),
            border: Border.all(
              color: selected ? FoodColors.accent : FoodColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                category.icon,
                size: 16,
                color: selected ? FoodColors.inkOnAccent : FoodColors.accent,
              ),
              const SizedBox(width: FoodSpacing.sm),
              Text(
                category.label,
                style: FoodText.button.copyWith(
                  fontSize: 13,
                  color: selected
                      ? FoodColors.inkOnAccent
                      : FoodColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

