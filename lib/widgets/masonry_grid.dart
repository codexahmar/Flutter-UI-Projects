import 'package:flutter/material.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import 'pin_card.dart';
import 'staggered_pin_animation.dart';

/// Reusable 2-column masonry grid matching Pinterest's exact wall layout.
class PinterestMasonryGrid extends StatelessWidget {
  final List<PinItem> pins;
  final ValueChanged<PinItem> onPinTap;
  final ValueChanged<PinItem> onToggleSave;
  final bool enableAnimation;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const PinterestMasonryGrid({
    super.key,
    required this.pins,
    required this.onPinTap,
    required this.onToggleSave,
    this.enableAnimation = true,
    this.padding = const EdgeInsets.fromLTRB(AppTokens.space8, AppTokens.space8, AppTokens.space8, 96),
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final leftColumn = <MapEntry<int, PinItem>>[];
    final rightColumn = <MapEntry<int, PinItem>>[];

    for (int i = 0; i < pins.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(MapEntry(i, pins[i]));
      } else {
        rightColumn.add(MapEntry(i, pins[i]));
      }
    }

    Widget buildColumnItem(int index, PinItem pin) {
      final card = PinCard(
        pin: pin,
        onTap: () => onPinTap(pin),
        onToggleSave: () => onToggleSave(pin),
      );

      if (!enableAnimation) return card;
      return StaggeredPinAnimation(index: index, child: card);
    }

    return SingleChildScrollView(
      controller: controller,
      physics: physics ?? const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftColumn.map((e) => buildColumnItem(e.key, e.value)).toList(),
            ),
          ),
          const SizedBox(width: AppTokens.space8),
          Expanded(
            child: Column(
              children: rightColumn.map((e) => buildColumnItem(e.key, e.value)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

