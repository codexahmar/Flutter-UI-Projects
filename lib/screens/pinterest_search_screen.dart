import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/pinterest_data.dart';
import '../themes/design_tokens.dart';
import '../widgets/pin_card.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredPins = widget.pins.where((p) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return p.title.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.author.toLowerCase().contains(q);
    }).toList();

    final leftPins = <PinItem>[];
    final rightPins = <PinItem>[];
    for (int i = 0; i < filteredPins.length; i++) {
      if (i % 2 == 0) {
        leftPins.add(filteredPins[i]);
      } else {
        rightPins.add(filteredPins[i]);
      }
    }

    return Column(
      children: [
        // 1. Pinterest Iconic Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(AppTokens.space12, AppTokens.space8, AppTokens.space12, AppTokens.space8),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppTokens.darkPill : AppTokens.lightPill,
              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.space16),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary,
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search for ideas…',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppTokens.darkTextTertiary : AppTokens.lightTextTertiary,
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
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: isDark ? AppTokens.darkTextSecondary : AppTokens.lightTextSecondary,
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
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                          ),
                          const SizedBox(height: AppTokens.space12),
                          Text(
                            'No pins found for "$_query"',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(AppTokens.space8, AppTokens.space8, AppTokens.space8, 96),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: leftPins.map((pin) {
                                return PinCard(
                                  pin: pin,
                                  onTap: () => PinDetailModal.show(
                                    context,
                                    pin: pin,
                                    relatedPins: filteredPins,
                                    onToggleSave: widget.onToggleSave,
                                    onSelectPin: (_) {},
                                  ),
                                  onToggleSave: () {
                                    pin.isSaved = !pin.isSaved;
                                    widget.onToggleSave();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: AppTokens.space8),
                          Expanded(
                            child: Column(
                              children: rightPins.map((pin) {
                                return PinCard(
                                  pin: pin,
                                  onTap: () => PinDetailModal.show(
                                    context,
                                    pin: pin,
                                    relatedPins: filteredPins,
                                    onToggleSave: widget.onToggleSave,
                                    onSelectPin: (_) {},
                                  ),
                                  onToggleSave: () {
                                    pin.isSaved = !pin.isSaved;
                                    widget.onToggleSave();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ))
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(AppTokens.space16, AppTokens.space8, AppTokens.space16, 96),
                  children: [
                    Text(
                      'Ideas for you',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                                Image.network(
                                  idea.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    idea.assetFallback,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.42),
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
                                          color: Colors.white.withOpacity(0.8),
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

                    Text(
                      'Popular on Pinterest',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                              color: isDark ? AppTokens.darkPill : AppTokens.lightPill,
                              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search_rounded, size: 15),
                                const SizedBox(width: 6),
                                Text(
                                  term,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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
