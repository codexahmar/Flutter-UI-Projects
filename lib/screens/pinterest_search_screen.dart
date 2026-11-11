import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/masonry_grid.dart';
import '../widgets/pin_detail_modal.dart';

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

  @override
  Widget build(BuildContext context) {
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
        // 1. Pinterest Iconic Search Bar (Pure White)
        Padding(
          padding: const EdgeInsets.fromLTRB(AppTokens.space12, AppTokens.space8, AppTokens.space12, AppTokens.space8),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
              border: Border.all(
                color: AppTokens.lightPillBorder,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: AppTokens.lightTextSecondary,
                ),
                const SizedBox(width: AppTokens.space12),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (val) {
                      setState(() {
                        _query = val.trim();
                      });
                    },
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTokens.lightTextPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search for ideas…',
                      hintStyle: TextStyle(
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
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _query = '';
                      });
                    },
                  )
                else
                  const Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: AppTokens.lightTextSecondary,
                  ),
              ],
            ),
          ),
        ),

        // 2. Body: Either "Ideas For You" or Search Results
        Expanded(
          child: _query.isNotEmpty
              ? (filteredPins.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: AppTokens.lightTextTertiary,
                          ),
                          const SizedBox(height: AppTokens.space12),
                          Text(
                            'No pins found for "$_query"',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTokens.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : PinterestMasonryGrid(
                      pins: filteredPins,
                      enableAnimation: false,
                      onPinTap: (pin) => PinDetailModal.show(
                        context,
                        pin: pin,
                        allPins: widget.pins,
                        onToggleSave: widget.onToggleSave,
                      ),
                      onToggleSave: (pin) {
                        pin.isSaved = !pin.isSaved;
                        widget.onToggleSave();
                      },
                    ))
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(AppTokens.space16, AppTokens.space8, AppTokens.space16, 96),
                  children: [
                    const Text(
                      'Ideas for you',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: -0.3,
                        color: AppTokens.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: AppTokens.space12),

                    // 2x2 Visual Category Cards
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.35,
                      ),
                      itemCount: PinterestData.ideasForYou.length,
                      itemBuilder: (context, index) {
                        final idea = PinterestData.ideasForYou[index];
                        return InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _controller.text = idea.title;
                              _query = idea.title;
                            });
                          },
                          borderRadius: BorderRadius.circular(AppTokens.radiusPin),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppTokens.radiusPin),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: idea.imageUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(milliseconds: 180),
                                  placeholder: (_, __) => Container(color: AppTokens.lightPill),
                                  errorWidget: (_, __, ___) => Image.asset(
                                    idea.assetFallback,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.42),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(AppTokens.space12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        idea.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        idea.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.8),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTokens.space24),

                    const Text(
                      'Popular on Pinterest',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: -0.3,
                        color: AppTokens.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: AppTokens.space12),

                    // Trending search query pills
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PinterestData.trendingSearches.map((term) {
                        return InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _controller.text = term;
                              _query = term;
                            });
                          },
                          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppTokens.lightPillBorder, width: 1.0),
                              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search_rounded, size: 14),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    term,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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
