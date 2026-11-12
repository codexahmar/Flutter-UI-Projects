import 'package:flutter/material.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import 'pin_card.dart';
import 'staggered_pin_animation.dart';

/// Reusable 2-column masonry grid with synchronized cascade animation and Hero tags.
class PinterestMasonryGrid extends StatefulWidget {
  final List<PinItem> pins;
  final ValueChanged<PinItem> onPinTap;
  final ValueChanged<PinItem>? onToggleSave;
  final bool showSaveButton;
  final bool enableAnimation;
  final String? heroTagPrefix;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const PinterestMasonryGrid({
    super.key,
    required this.pins,
    required this.onPinTap,
    this.onToggleSave,
    this.showSaveButton = true,
    this.enableAnimation = true,
    this.heroTagPrefix,
    this.padding = const EdgeInsets.fromLTRB(
      AppTokens.space8,
      AppTokens.space8,
      AppTokens.space8,
      AppTokens.space24,
    ),
    this.physics,
    this.controller,
  });

  @override
  State<PinterestMasonryGrid> createState() => _PinterestMasonryGridState();
}

class _PinterestMasonryGridState extends State<PinterestMasonryGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: widget.enableAnimation ? 0.0 : 1.0,
    );
    if (widget.enableAnimation) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant PinterestMasonryGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enableAnimation) {
      _controller.value = 1.0;
      return;
    }
    if (!_hasSamePinOrder(oldWidget.pins, widget.pins)) {
      _controller.forward(from: 0.0);
    }
  }

  bool _hasSamePinOrder(List<PinItem> a, List<PinItem> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftColumn = <MapEntry<int, PinItem>>[];
    final rightColumn = <MapEntry<int, PinItem>>[];

    for (int i = 0; i < widget.pins.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(MapEntry(i, widget.pins[i]));
      } else {
        rightColumn.add(MapEntry(i, widget.pins[i]));
      }
    }

    Widget buildColumnItem(int index, PinItem pin) {
      final heroTag =
          widget.heroTagPrefix != null ? '${widget.heroTagPrefix}_pin_${pin.id}' : null;

      final card = PinCard(
        key: widget.enableAnimation ? null : ValueKey(pin.id),
        pin: pin,
        showSaveButton: widget.showSaveButton,
        heroTag: heroTag,
        onTap: () => widget.onPinTap(pin),
        onToggleSave: widget.onToggleSave != null ? () => widget.onToggleSave!(pin) : null,
      );

      if (!widget.enableAnimation) return card;
      return StaggeredPinAnimation(
        key: ValueKey(pin.id),
        index: index,
        progress: _controller,
        child: card,
      );
    }

    return SingleChildScrollView(
      controller: widget.controller,
      physics: widget.physics ??
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: widget.padding,
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
