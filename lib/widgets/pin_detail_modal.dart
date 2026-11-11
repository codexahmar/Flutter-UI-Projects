import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';

class PinDetailModal extends StatefulWidget {
  final PinItem pin;
  final List<PinItem> allPins;
  final VoidCallback onToggleSave;

  const PinDetailModal({
    super.key,
    required this.pin,
    required this.allPins,
    required this.onToggleSave,
  });

  static void show(
    BuildContext context, {
    required PinItem pin,
    required List<PinItem> allPins,
    required VoidCallback onToggleSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PinDetailModal(
        pin: pin,
        allPins: allPins,
        onToggleSave: onToggleSave,
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

  @override
  void initState() {
    super.initState();
    _currentPin = widget.pin;
    _isSaved = widget.pin.isSaved;
  }

  void _switchToPin(PinItem nextPin) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentPin = nextPin;
      _isSaved = nextPin.isSaved;
      _isFollowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const pillBg = AppTokens.lightPill;
    const primaryInk = Colors.black;
    const onPrimaryInk = Colors.white;

    // Filter pins of the EXACT SAME CATEGORY for authentic Pinterest visual discovery
    final sameCategoryPins = widget.allPins
        .where((p) => p.id != _currentPin.id && p.category.toLowerCase() == _currentPin.category.toLowerCase())
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.94,
      decoration: BoxDecoration(
        color: AppTokens.lightBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTokens.radiusPin)),
      ),
      child: Column(
        children: [
          // 1. Top Pinterest Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space12, vertical: AppTokens.space8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: pillBg,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: pillBg,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined, size: 20),
                        tooltip: 'Share',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pin link copied to clipboard'),
                              duration: Duration(milliseconds: 1200),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppTokens.space8),
                    Container(
                      decoration: BoxDecoration(
                        color: pillBg,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.more_horiz_rounded, size: 20),
                        tooltip: 'More options',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Scrollable Pin Content
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(AppTokens.space16, 0, AppTokens.space16, AppTokens.space32),
              children: [
                // Full High-Res Pin Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTokens.radiusPin),
                  child: Image.network(
                    _currentPin.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      _currentPin.assetFallback,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppTokens.space16),

                // Creator & Follow Button (Authentic Pinterest Button Colors)
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        _currentPin.authorAvatar,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: AppTokens.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentPin.author,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '14.8k followers',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTokens.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Authentic Pinterest Follow Button
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: _isFollowing ? pillBg : primaryInk,
                          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                        ),
                        child: Text(
                          _isFollowing ? 'Following' : 'Follow',
                          style: TextStyle(
                            color: _isFollowing ? primaryInk : onPrimaryInk,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.space16),

                // Pin Title
                Text(
                  _currentPin.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: -0.4,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: AppTokens.space8),
                Text(
                  'Saved to ${_currentPin.category} · Curated photos and visual ideas for your everyday moodboard.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppTokens.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppTokens.space20),

                // Save & View Buttons (Authentic Pinterest Button Colors)
                Row(
                  children: [
                    // View Button (Neutral Pill)
                    Expanded(
                      flex: 1,
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: pillBg,
                            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'View',
                            style: TextStyle(
                              color: primaryInk,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTokens.space12),

                    // Save Button (Iconic Pinterest Red Pill)
                    Expanded(
                      flex: 1,
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
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _isSaved ? primaryInk : AppTokens.pinterestRed,
                            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _isSaved ? 'Saved' : 'Save',
                            style: TextStyle(
                              color: _isSaved ? onPrimaryInk : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.space24),

                // 3. More Like This Section (Filtered to EXACT SAME CATEGORY)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'More like this',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _currentPin.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTokens.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.space12),

                // Related 2-column Masonry Grid
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTokens.radiusPin),
          child: AspectRatio(
            aspectRatio: pin.aspectRatio,
            child: Image.network(
              pin.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                pin.assetFallback,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
