import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/cached_pin_image.dart';
import '../widgets/masonry_grid.dart';
import '../widgets/pin_detail_modal.dart';
import '../widgets/pinterest_icons.dart';

class PinterestSearchScreen extends StatefulWidget {
  final List<PinItem> pins;
  final VoidCallback onToggleSave;

  const PinterestSearchScreen({
    super.key,
    required this.pins,
    required this.onToggleSave,
  });

  @override
  State<PinterestSearchScreen> createState() => _PinterestSearchScreenState();
}

class _PinterestSearchScreenState extends State<PinterestSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyQuery(String value) {
    HapticFeedback.selectionClick();
    setState(() {
      _controller.text = value;
      _query = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final filteredPins = widget.pins.where((p) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      final searchable = '${p.title} ${p.category} ${p.author}'.toLowerCase();
      if (searchable.contains(q)) return true;
      final words = q.split(RegExp(r'\s+')).where((w) => w.length > 2).toList();
      if (words.isEmpty) return false;
      return words.any((w) => searchable.contains(w));
    }).toList();

    return Column(
      children: [
        // 1. Crisp White Pinterest Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTokens.space12,
            AppTokens.space8,
            AppTokens.space12,
            AppTokens.space8,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            decoration: BoxDecoration(
              color: AppTokens.lightBg,
              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
              border: Border.all(
                color: AppTokens.lightPillBorder,
                width: 1,
              ),
              boxShadow: AppTokens.shadowBar,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16),
            child: Row(
              children: [
                const PinterestSearchIcon(
                  size: 20,
                  color: AppTokens.lightTextSecondary,
                ),
                const SizedBox(width: AppTokens.space12),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (val) => setState(() => _query = val.trim()),
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search for ideas…',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: AppTokens.lightTextTertiary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_query.isNotEmpty)
                  IconButton(
                    tooltip: 'Clear search',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppTokens.lightTextSecondary,
                    ),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  )
                else
                  IconButton(
                    tooltip: 'Visual search',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 20,
                      color: AppTokens.lightTextSecondary,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pinterest Lens visual search'),
                          duration: Duration(milliseconds: 1000),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),

        // 2. Body: "Ideas for you" Explore Grid OR Search Results
        Expanded(
          child: _query.isNotEmpty
              ? (filteredPins.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTokens.space32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const PinterestSearchIcon(
                              size: 40,
                              color: AppTokens.lightTextTertiary,
                            ),
                            const SizedBox(height: AppTokens.space12),
                            Text(
                              'No pins found for "$_query"',
                              textAlign: TextAlign.center,
                              style: textTheme.titleSmall?.copyWith(
                                color: AppTokens.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: AppTokens.space16),
                            InkWell(
                              borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                              onTap: () {
                                _controller.clear();
                                setState(() => _query = '');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTokens.space20,
                                  vertical: AppTokens.space12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTokens.lightPill,
                                  borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                                ),
                                child: Text(
                                  'Clear search',
                                  style: textTheme.labelLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : PinterestMasonryGrid(
                      pins: filteredPins,
                      enableAnimation: false,
                      heroTagPrefix: 'search',
                      onPinTap: (pin) => PinDetailModal.show(
                        context,
                        pin: pin,
                        allPins: widget.pins,
                        onToggleSave: widget.onToggleSave,
                        heroTagPrefix: 'search',
                      ),
                      onToggleSave: (pin) {
                        pin.isSaved = !pin.isSaved;
                        widget.onToggleSave();
                      },
                    ))
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppTokens.space16,
                    AppTokens.space8,
                    AppTokens.space16,
                    AppTokens.space24,
                  ),
                  children: [
                    Text(
                      'Ideas for you',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTokens.space12),

                    // 2x2 Visual Category Cards with bottom-up legibility scrim (#36)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppTokens.space12,
                        mainAxisSpacing: AppTokens.space12,
                        childAspectRatio: 1.35,
                      ),
                      itemCount: PinterestData.ideasForYou.length,
                      itemBuilder: (context, index) {
                        final idea = PinterestData.ideasForYou[index];
                        return InkWell(
                          onTap: () => _applyQuery(idea.title),
                          borderRadius: BorderRadius.circular(AppTokens.radiusPin),
                          child: CachedPinImage(
                            imageUrl: idea.imageUrl,
                            assetFallback: idea.assetFallback,
                            overlay: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 0.45, 1.0],
                                  colors: [
                                    AppTokens.imageScrimTop,
                                    AppTokens.imageScrimMid,
                                    AppTokens.imageScrimBottom,
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(AppTokens.space12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    idea.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppTokens.space2),
                                  Text(
                                    idea.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.labelSmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.92),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTokens.space24),

                    Text(
                      'Popular on Pinterest',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTokens.space12),

                    // Trending Search Query Pills
                    Wrap(
                      spacing: AppTokens.space8,
                      runSpacing: AppTokens.space8,
                      children: PinterestData.trendingSearches.map((term) {
                        return InkWell(
                          onTap: () => _applyQuery(term),
                          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTokens.space16,
                              vertical: AppTokens.space8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTokens.lightBg,
                              border: Border.all(
                                color: AppTokens.lightPillBorder,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const PinterestSearchIcon(
                                  size: 14,
                                  color: AppTokens.lightTextSecondary,
                                ),
                                const SizedBox(width: AppTokens.space8),
                                Flexible(
                                  child: Text(
                                    term,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: AppTokens.lightTextPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
