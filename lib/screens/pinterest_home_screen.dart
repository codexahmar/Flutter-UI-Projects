import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/pin_card.dart';
import '../widgets/pin_detail_modal.dart';
import '../widgets/shimmer_skeleton.dart';
import '../widgets/staggered_pin_animation.dart';

class PinterestHomeScreen extends StatefulWidget {
  final List<PinItem> pins;
  final VoidCallback onToggleSave;

  const PinterestHomeScreen({
    super.key,
    required this.pins,
    required this.onToggleSave,
  });

  @override
  State<PinterestHomeScreen> createState() => _PinterestHomeScreenState();
}

class _PinterestHomeScreenState extends State<PinterestHomeScreen> {
  String _selectedCategory = 'All';
  bool _isLoading = true;
  late List<PinItem> _displayPins;

  @override
  void initState() {
    super.initState();
    _displayPins = widget.pins;
    // Show beautiful Pinterest shimmer skeleton loading on app startup
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant PinterestHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pins != widget.pins) {
      _filterPins(_selectedCategory);
    }
  }

  void _filterPins(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _displayPins = widget.pins;
      } else {
        _displayPins = widget.pins.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
      }
    });
  }

  Future<void> _refreshCategoryPins() async {
    setState(() => _isLoading = true);
    final newPins = await PinterestData.fetchLiveCategoryPins(_selectedCategory);
    if (mounted) {
      setState(() {
        _displayPins = newPins;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Split into 2 staggered columns for authentic Pinterest masonry
    final leftColumnPins = <MapEntry<int, PinItem>>[];
    final rightColumnPins = <MapEntry<int, PinItem>>[];
    for (int i = 0; i < _displayPins.length; i++) {
      if (i % 2 == 0) {
        leftColumnPins.add(MapEntry(i, _displayPins[i]));
      } else {
        rightColumnPins.add(MapEntry(i, _displayPins[i]));
      }
    }

    return Column(
      children: [
        // 1. Pinterest Horizontal Category Pills
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space12),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: PinterestData.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppTokens.space8),
            itemBuilder: (context, index) {
              final cat = PinterestData.categories[index];
              final isSelected = cat == _selectedCategory;

              return InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  _filterPins(cat);
                },
                borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? Colors.white : Colors.black)
                        : (isDark ? AppTokens.darkPill : AppTokens.lightPill),
                    borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                  ),
                  child: Center(
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? (isDark ? Colors.black : Colors.white)
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // 2. Body: Shimmer Skeleton on startup OR Staggered Animated Masonry Grid
        Expanded(
          child: _isLoading
              ? const PinterestMasonrySkeleton()
              : RefreshIndicator(
                  color: AppTokens.pinterestRed,
                  onRefresh: _refreshCategoryPins,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(AppTokens.space8, AppTokens.space8, AppTokens.space8, 96),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Masonry Column with Staggered Animation
                        Expanded(
                          child: Column(
                            children: leftColumnPins.map((entry) {
                              final index = entry.key;
                              final pin = entry.value;

                              return StaggeredPinAnimation(
                                index: index,
                                child: PinCard(
                                  pin: pin,
                                  onTap: () => PinDetailModal.show(
                                    context,
                                    pin: pin,
                                    allPins: _displayPins,
                                    onToggleSave: widget.onToggleSave,
                                  ),
                                  onToggleSave: () {
                                    pin.isSaved = !pin.isSaved;
                                    widget.onToggleSave();
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: AppTokens.space8),

                        // Right Masonry Column with Staggered Animation
                        Expanded(
                          child: Column(
                            children: rightColumnPins.map((entry) {
                              final index = entry.key;
                              final pin = entry.value;

                              return StaggeredPinAnimation(
                                index: index,
                                child: PinCard(
                                  pin: pin,
                                  onTap: () => PinDetailModal.show(
                                    context,
                                    pin: pin,
                                    allPins: _displayPins,
                                    onToggleSave: widget.onToggleSave,
                                  ),
                                  onToggleSave: () {
                                    pin.isSaved = !pin.isSaved;
                                    widget.onToggleSave();
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
