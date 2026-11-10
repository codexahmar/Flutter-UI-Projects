import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';

class PinDetailModal extends StatefulWidget {
  final PinItem pin;
  final List<PinItem> relatedPins;
  final VoidCallback onToggleSave;
  final ValueChanged<PinItem> onSelectPin;

  const PinDetailModal({
    super.key,
    required this.pin,
    required this.relatedPins,
    required this.onToggleSave,
    required this.onSelectPin,
  });

  static void show(
    BuildContext context, {
    required PinItem pin,
    required List<PinItem> relatedPins,
    required VoidCallback onToggleSave,
    required ValueChanged<PinItem> onSelectPin,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PinDetailModal(
        pin: pin,
        relatedPins: relatedPins,
        onToggleSave: onToggleSave,
        onSelectPin: onSelectPin,
      ),
    );
  }

  @override
  State<PinDetailModal> createState() => _PinDetailModalState();
}

class _PinDetailModalState extends State<PinDetailModal> {
  late bool _isSaved;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.pin.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: isDark ? AppTokens.darkBg : AppTokens.lightBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTokens.radiusPin)),
      ),
      child: Column(
        children: [
          // Top Action Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16, vertical: AppTokens.space12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 22),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pin link copied to clipboard'),
                            duration: Duration(milliseconds: 1200),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz_rounded, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Pin Body
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(AppTokens.space16, 0, AppTokens.space16, AppTokens.space32),
              children: [
                // Full Pin Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTokens.radiusPin),
                  child: Image.network(
                    widget.pin.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      widget.pin.assetFallback,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppTokens.space16),

                // Creator Row & Follow Button
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        widget.pin.authorAvatar,
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
                            widget.pin.author,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '12.4k followers',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                      },
                      child: Text(
                        _isFollowing ? 'Following' : 'Follow',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.space16),

                // Pin Title
                Text(
                  widget.pin.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppTokens.space8),
                Text(
                  'Saved to ${widget.pin.category} moodboard · Photos and inspiration curated for you.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppTokens.space24),

                // Main Save Button Row
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: _isSaved
                              ? (isDark ? Colors.white : Colors.black)
                              : AppTokens.pinterestRed,
                          foregroundColor: _isSaved
                              ? (isDark ? Colors.black : Colors.white)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _isSaved = !_isSaved;
                            widget.pin.isSaved = _isSaved;
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
                        child: Text(
                          _isSaved ? 'Saved' : 'Save',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTokens.space12),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening source website…'),
                            duration: Duration(milliseconds: 1000),
                          ),
                        );
                      },
                      child: const Text('View', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: AppTokens.space32),

                // More to explore section
                Text(
                  'More to explore',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppTokens.space16),

                // Related 2-column Pins
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: widget.relatedPins
                            .where((p) => p.id != widget.pin.id)
                            .take(3)
                            .map((p) => _RelatedPinThumb(
                                  pin: p,
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.onSelectPin(p);
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: AppTokens.space12),
                    Expanded(
                      child: Column(
                        children: widget.relatedPins
                            .where((p) => p.id != widget.pin.id)
                            .skip(3)
                            .take(3)
                            .map((p) => _RelatedPinThumb(
                                  pin: p,
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.onSelectPin(p);
                                  },
                                ))
                            .toList(),
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
      padding: const EdgeInsets.only(bottom: AppTokens.space12),
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
