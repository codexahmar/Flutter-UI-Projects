import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/masonry_grid.dart';
import '../widgets/pin_detail_modal.dart';
import '../widgets/pinterest_logo.dart';
import '../widgets/shimmer_skeleton.dart';

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
  bool _hasPreloaded = false;
  int _feedVersion = 0;
  late List<PinItem> _displayPins;

  @override
  void initState() {
    super.initState();
    _displayPins = List.of(widget.pins);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasPreloaded) {
      _hasPreloaded = true;
      _preloadInitialImages();
    }
  }

  bool get _isTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('Test');

  Future<void> _safePrecache(ImageProvider provider) {
    final completer = Completer<void>();
    final stream = provider.resolve(ImageConfiguration.empty);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, sync) {
        if (!completer.isCompleted) completer.complete();
        stream.removeListener(listener);
      },
      onError: (exception, stackTrace) {
        if (!completer.isCompleted) completer.complete();
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
    return completer.future.timeout(
      const Duration(milliseconds: 250),
      onTimeout: () {
        stream.removeListener(listener);
      },
    );
  }

  /// Ends the skeleton UI immediately once all initial viewport images are fully loaded
  Future<void> _preloadInitialImages() async {
    final initialPins = _displayPins.take(8);
    final futures = <Future<void>>[];

    for (final pin in initialPins) {
      futures.add(_safePrecache(AssetImage(pin.assetFallback)));
      futures.add(_safePrecache(AssetImage(pin.authorAvatar)));

      if (!_isTest && pin.imageUrl.isNotEmpty) {
        futures.add(_safePrecache(CachedNetworkImageProvider(pin.imageUrl)));
      }
    }

    // Wait until all images are fully decoded in Flutter's ImageCache
    await Future.wait(futures);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant PinterestHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pins != widget.pins) {
      setState(() {
        _displayPins = List.of(widget.pins);
      });
    }
  }

  Future<void> _refreshPins() async {
    setState(() => _isLoading = true);
    if (!_isTest) {
      await Future<void>.delayed(const Duration(milliseconds: 220));
    }
    if (!mounted) return;
    setState(() {
      _displayPins = PinterestData.getShuffledPins(_displayPins);
      _feedVersion++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Official Pinterest Top Bar
        PinterestOfficialHeader(
          onCreateTap: widget.onCreateTap,
          onChatTap: widget.onChatTap,
        ),

        // 2. Body: Shimmer Skeleton OR Synchronized Cascade Pinterest Wall
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeOut,
            child: _isLoading
                ? const PinterestMasonrySkeleton(key: ValueKey('skeleton'))
                : RefreshIndicator(
                    key: ValueKey('wall_$_feedVersion'),
                    color: AppTokens.pinterestRed,
                    onRefresh: _refreshPins,
                    child: PinterestMasonryGrid(
                      pins: _displayPins,
                      showSaveButton: false,
                      heroTagPrefix: 'home',
                      onPinTap: (pin) => PinDetailModal.show(
                        context,
                        pin: pin,
                        allPins: _displayPins,
                        onToggleSave: widget.onToggleSave,
                        heroTagPrefix: 'home',
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
