import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import 'cached_pin_image.dart';
import 'pin_options_sheet.dart';

class PinDetailModal extends StatefulWidget {
  final PinItem pin;
  final List<PinItem> allPins;
  final VoidCallback onToggleSave;
  final String? heroTagPrefix;

  const PinDetailModal({
    super.key,
    required this.pin,
    required this.allPins,
    required this.onToggleSave,
    this.heroTagPrefix,
  });

  static void show(
    BuildContext context, {
    required PinItem pin,
    required List<PinItem> allPins,
    required VoidCallback onToggleSave,
    String? heroTagPrefix,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.35),
        transitionDuration: const Duration(milliseconds: 340),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (ctx, animation, secondaryAnimation) {
          return PinDetailModal(
            pin: pin,
            allPins: allPins,
            onToggleSave: onToggleSave,
            heroTagPrefix: heroTagPrefix,
          );
        },
        transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: fade,
            child: child,
          );
        },
      ),
    );
  }

  @override
  State<PinDetailModal> createState() => _PinDetailModalState();
}

class _PinDetailModalState extends State<PinDetailModal> {
  late PinItem _currentPin;
  late bool _isSaved;
  bool _isFollowing = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _currentPin = widget.pin;
    _isSaved = widget.pin.isSaved;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _switchToPin(PinItem nextPin) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentPin = nextPin;
      _isSaved = nextPin.isSaved;
      _isFollowing = false;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Filter pins of the same category for visual discovery
    final sameCategoryPins = widget.allPins
        .where(
          (p) =>
              p.id != _currentPin.id &&
              p.category.toLowerCase() == _currentPin.category.toLowerCase(),
        )
        .toList();
    final relatedPins = sameCategoryPins.isNotEmpty
        ? sameCategoryPins
        : widget.allPins.where((p) => p.id != _currentPin.id).toList();

    final leftRelated = <PinItem>[];
    final rightRelated = <PinItem>[];
    for (int i = 0; i < relatedPins.length; i++) {
      if (i % 2 == 0) {
        leftRelated.add(relatedPins[i]);
      } else {
        rightRelated.add(relatedPins[i]);
      }
    }

    final activeHeroTag =
        (widget.heroTagPrefix != null && _currentPin.id == widget.pin.id)
            ? '${widget.heroTagPrefix}_pin_${_currentPin.id}'
            : null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Tap above the sheet to dismiss cleanly
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.94,
              decoration: const BoxDecoration(
                color: AppTokens.lightBg,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppTokens.radiusSheet),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  const SizedBox(height: AppTokens.space8),
                  Container(
                    width: 36,
                    height: AppTokens.space4,
                    decoration: BoxDecoration(
                      color: AppTokens.lightPillHover,
                      borderRadius: BorderRadius.circular(AppTokens.space2),
                    ),
                  ),

                  // 1. Top Pinterest Action Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTokens.space16,
                      vertical: AppTokens.space8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ModalCircleAction(
                          icon: Icons.close_rounded,
                          tooltip: 'Close',
                          onTap: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            _ModalCircleAction(
                              icon: Icons.share_outlined,
                              tooltip: 'Share',
                              iconSize: 20,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pin link copied to clipboard'),
                                    duration: Duration(milliseconds: 1200),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: AppTokens.space8),
                            _ModalCircleAction(
                              icon: Icons.more_horiz_rounded,
                              tooltip: 'More options',
                              iconSize: 20,
                              onTap: () => PinOptionsSheet.show(context, pin: _currentPin),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. Scrollable Pin Content
                  Expanded(
                    child: ListView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppTokens.space16,
                        AppTokens.space4,
                        AppTokens.space16,
                        AppTokens.space32,
                      ),
                      children: [
                        // Full High-Res Pin Image with Hero flight animation
                        AspectRatio(
                          aspectRatio: _currentPin.aspectRatio,
                          child: CachedPinImage(
                            key: ValueKey(_currentPin.id),
                            imageUrl: _currentPin.imageUrl,
                            assetFallback: _currentPin.assetFallback,
                            isStudioCutout: _currentPin.isStudioCutout,
                            cutoutPadding: AppTokens.space12,
                            heroTag: activeHeroTag,
                          ),
                        ),
                        const SizedBox(height: AppTokens.space16),

                        // Creator Row & Follow Capsule
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTokens.lightImageHairline,
                                  width: 0.8,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  _currentPin.authorAvatar,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTokens.space12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentPin.author,
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppTokens.space2),
                                  Text(
                                    '${_currentPin.category} · Curated pin',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppTokens.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() => _isFollowing = !_isFollowing);
                              },
                              borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTokens.space16,
                                  vertical: AppTokens.space12,
                                ),
                                decoration: BoxDecoration(
                                  color: _isFollowing
                                      ? AppTokens.lightPill
                                      : AppTokens.lightTextPrimary,
                                  borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                                ),
                                child: Text(
                                  _isFollowing ? 'Following' : 'Follow',
                                  style: textTheme.labelLarge?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _isFollowing
                                        ? AppTokens.lightTextPrimary
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTokens.space16),

                        // Pin Title & Description
                        Text(
                          _currentPin.title,
                          style: textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: AppTokens.space8),
                        Text(
                          'Curated in ${_currentPin.category} · Visual inspiration for your moodboard.',
                          style: textTheme.bodyMedium?.copyWith(height: 1.4),
                        ),
                        const SizedBox(height: AppTokens.space20),

                        // Action Pyramid: View (neutral soft pill) + Save (primary brand red capsule)
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Opening source website…'),
                                      duration: Duration(milliseconds: 1000),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                                child: Container(
                                  constraints: const BoxConstraints(minHeight: 48),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTokens.space16,
                                    vertical: AppTokens.space12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTokens.lightPill,
                                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'View',
                                    style: textTheme.labelLarge?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppTokens.lightTextPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTokens.space12),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    _isSaved = !_isSaved;
                                    _currentPin.isSaved = _isSaved;
                                  });
                                  widget.onToggleSave();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _isSaved ? 'Saved to profile board' : 'Removed from board',
                                      ),
                                      duration: const Duration(milliseconds: 1000),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  constraints: const BoxConstraints(minHeight: 48),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTokens.space16,
                                    vertical: AppTokens.space12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isSaved
                                        ? AppTokens.lightTextPrimary
                                        : AppTokens.pinterestRed,
                                    borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_isSaved) ...[
                                        const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: AppTokens.space4),
                                      ],
                                      Text(
                                        _isSaved ? 'Saved' : 'Save',
                                        style: textTheme.labelLarge?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTokens.space24),

                        // 3. More Like This Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'More like this',
                              style: textTheme.titleMedium,
                            ),
                            Text(
                              _currentPin.category,
                              style: textTheme.labelMedium?.copyWith(
                                color: AppTokens.lightTextTertiary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTokens.space12),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: leftRelated.map((p) {
                                  return _RelatedPinThumb(
                                    pin: p,
                                    onTap: () => _switchToPin(p),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: AppTokens.space8),
                            Expanded(
                              child: Column(
                                children: rightRelated.map((p) {
                                  return _RelatedPinThumb(
                                    pin: p,
                                    onTap: () => _switchToPin(p),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModalCircleAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final double iconSize;
  final VoidCallback onTap;

  const _ModalCircleAction({
    required this.icon,
    required this.tooltip,
    this.iconSize = 22,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radiusButton),
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppTokens.lightSurfaceSubtle,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: iconSize,
            color: AppTokens.lightTextPrimary,
          ),
        ),
      ),
    );
  }
}

class _RelatedPinThumb extends StatelessWidget {
  final PinItem pin;
  final VoidCallback onTap;

  const _RelatedPinThumb({required this.pin, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.space8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radiusPin),
        child: AspectRatio(
          aspectRatio: pin.aspectRatio,
          child: CachedPinImage(
            imageUrl: pin.imageUrl,
            assetFallback: pin.assetFallback,
            isStudioCutout: pin.isStudioCutout,
            cutoutPadding: AppTokens.space8,
          ),
        ),
      ),
    );
  }
}
