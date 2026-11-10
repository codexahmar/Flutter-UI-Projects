import 'package:flutter/material.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/pin_card.dart';
import '../widgets/pin_detail_modal.dart';
import '../widgets/pinterest_logo.dart';
import '../widgets/shimmer_skeleton.dart';
import '../widgets/staggered_pin_animation.dart';

class PinterestHomeScreen extends StatefulWidget {
  final List<PinItem> pins;
  final VoidCallback onToggleSave;
  final VoidCallback onCreateTap;
  final VoidCallback onChatTap;

  const PinterestHomeScreen({
    super.key,
    required this.pins,
    required this.onToggleSave,
    required this.onCreateTap,
    required this.onChatTap,
  });

  @override
  State<PinterestHomeScreen> createState() => _PinterestHomeScreenState();
}

class _PinterestHomeScreenState extends State<PinterestHomeScreen> {
  bool _isLoading = true;
  late List<PinItem> _displayPins;

  @override
  void initState() {
    super.initState();
    _displayPins = widget.pins;
    // Show beautiful Pinterest shimmer skeleton loading on app startup
    Future.delayed(const Duration(milliseconds: 650), () {
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
      setState(() {
        _displayPins = widget.pins;
      });
    }
  }

  Future<void> _refreshPins() async {
    setState(() => _isLoading = true);
    final newPins = await PinterestData.fetchLiveCategoryPins('All');
    if (mounted) {
      setState(() {
        _displayPins = newPins;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        // 1. Official Pinterest Top Bar (Logo + Brand on Left, Plus & Chat on Right)
        PinterestOfficialHeader(
          onCreateTap: widget.onCreateTap,
          onChatTap: widget.onChatTap,
        ),

        // 2. Body: Shimmer Skeleton on startup OR Staggered Animated Masonry Grid
        Expanded(
          child: _isLoading
              ? const PinterestMasonrySkeleton()
              : RefreshIndicator(
                  color: AppTokens.pinterestRed,
                  onRefresh: _refreshPins,
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
