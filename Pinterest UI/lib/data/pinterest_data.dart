import 'dart:math';
import '../constants/app_assets.dart';

class PinItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String assetFallback;
  final double aspectRatio;
  final String author;
  final String authorAvatar;
  final bool isStudioCutout;
  bool isSaved;

  PinItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.assetFallback,
    required this.aspectRatio,
    required this.author,
    required this.authorAvatar,
    this.isStudioCutout = false,
    this.isSaved = false,
  });

  PinItem copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    String? assetFallback,
    double? aspectRatio,
    String? author,
    String? authorAvatar,
    bool? isStudioCutout,
    bool? isSaved,
  }) {
    return PinItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      assetFallback: assetFallback ?? this.assetFallback,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      author: author ?? this.author,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      isStudioCutout: isStudioCutout ?? this.isStudioCutout,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class PinterestBoard {
  final String id;
  final String title;
  final int pinCount;
  final String updatedTime;
  final String mainImage;
  final String subImage1;
  final String subImage2;
  final bool isSecret;

  const PinterestBoard({
    required this.id,
    required this.title,
    required this.pinCount,
    required this.updatedTime,
    required this.mainImage,
    required this.subImage1,
    required this.subImage2,
    this.isSecret = false,
  });
}

class IdeaCard {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String assetFallback;

  const IdeaCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.assetFallback,
  });
}

class PinterestData {
  PinterestData._();

  static const List<String> categories = [
    'All',
    'Plants',
    'Botanicals',
    'Succulents',
    'Nature',
    'Tech',
    'Laptops',
    'Accessories',
  ];

  static const List<String> trendingSearches = [
    'minimal potted plant',
    'monstera white pot',
    'eucalyptus on white',
    'minimalist bonsai',
    'succulent white planter',
    'minimal tech studio',
  ];

  static const List<IdeaCard> ideasForYou = [
    IdeaCard(
      title: 'Minimal Plants',
      subtitle: 'White ceramic pots & greenery',
      imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=700&q=80',
      assetFallback: AppAssets.image5,
    ),
    IdeaCard(
      title: 'Succulents & Cacti',
      subtitle: 'Clean botanical forms on white',
      imageUrl: 'https://images.unsplash.com/photo-1596547609788-b5eebd7a334b?w=700&q=80',
      assetFallback: AppAssets.image1,
    ),
    IdeaCard(
      title: 'Nature & Foliage',
      subtitle: 'Organic stems & bright spaces',
      imageUrl: 'https://images.unsplash.com/photo-1611255552402-4f772d00621b?w=700&q=80',
      assetFallback: AppAssets.image2,
    ),
    IdeaCard(
      title: 'Minimal Tech Studio',
      subtitle: 'Clean gadgets, setups & coding desks',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=700&q=80',
      assetFallback: AppAssets.image3,
    ),
  ];

  // Authentic Pinterest Collage Boards
  static const List<PinterestBoard> userBoards = [
    PinterestBoard(
      id: 'b1',
      title: 'Plants & Nature',
      pinCount: 58,
      updatedTime: '2d',
      mainImage: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=700&q=80',
      subImage1: 'https://images.unsplash.com/photo-1596547609788-b5eebd7a334b?w=700&q=80',
      subImage2: 'https://images.unsplash.com/photo-1611255552402-4f772d00621b?w=700&q=80',
    ),
    PinterestBoard(
      id: 'b2',
      title: 'Minimal Botanicals',
      pinCount: 44,
      updatedTime: '3d',
      mainImage: 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=700&q=80',
      subImage1: 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a?w=700&q=80',
      subImage2: 'https://images.unsplash.com/photo-1684743317217-41bac262ea20?w=700&q=80',
    ),
    PinterestBoard(
      id: 'b3',
      title: 'Tech & Gadgets',
      pinCount: 36,
      updatedTime: '1w',
      mainImage: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=700&q=80',
      subImage1: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=700&q=80',
      subImage2: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=700&q=80',
    ),
    PinterestBoard(
      id: 'b4',
      title: 'Secret Studio Mood',
      pinCount: 19,
      updatedTime: '2w',
      mainImage: 'https://images.unsplash.com/photo-1604762525343-62309354f8a1?w=700&q=80',
      subImage1: 'https://images.unsplash.com/photo-1585938734416-a093903b9471?w=700&q=80',
      subImage2: 'https://images.unsplash.com/photo-1610449146539-5d2d7867a1b0?w=700&q=80',
      isSecret: true,
    ),
  ];

  // 20 unique, non-repeating pins mixing clean white-background Plants & Tech
  static const _plantCategories = {
    'Plants',
    'Botanicals',
    'Succulents',
    'Nature',
  };

  /// Initial curated feed mixing botanicals and studio tech asymmetrically across both columns
  static List<PinItem> getInitialPins() {
    return [
      // Row 0: Left Plant (p3) / Right Tech (p2)
      PinItem(
        id: 'p3',
        title: 'Minimalist potted succulent on crisp white studio',
        category: 'Plants',
        imageUrl: 'https://cdn.dummyjson.com/product-images/home-decoration/plant-pot/thumbnail.webp',
        assetFallback: AppAssets.image2,
        aspectRatio: 0.68,
        author: 'Botanica',
        authorAvatar: AppAssets.image3,
        isStudioCutout: true,
      ),
      PinItem(
        id: 'p2',
        title: 'Minimalist wireless headphones on warm studio backdrop',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=700&q=80',
        assetFallback: AppAssets.image3,
        aspectRatio: 0.86,
        author: 'Studio Audio',
        authorAvatar: AppAssets.image2,
      ),
      // Row 1: Left Tech (p4) / Right Plant (p1)
      PinItem(
        id: 'p4',
        title: 'Minimalist MacBook setup on warm wooden desk',
        category: 'Laptops',
        imageUrl: 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=700&q=80',
        assetFallback: AppAssets.image4,
        aspectRatio: 0.78,
        author: 'Minimal Desk',
        authorAvatar: AppAssets.image4,
      ),
      PinItem(
        id: 'p1',
        title: 'Minimal indoor showpiece plant in ceramic pot',
        category: 'Plants',
        imageUrl: 'https://cdn.dummyjson.com/product-images/home-decoration/house-showpiece-plant/thumbnail.webp',
        assetFallback: AppAssets.image5,
        aspectRatio: 0.72,
        author: 'Studio Flora',
        authorAvatar: AppAssets.image1,
        isStudioCutout: true,
        isSaved: true,
      ),
      // Row 2: Left Tech (p14) / Right Plant (p5)
      PinItem(
        id: 'p14',
        title: 'Contemporary smart speaker in warm minimal interior',
        category: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=700&q=80',
        assetFallback: AppAssets.image6,
        aspectRatio: 0.65,
        author: 'SoundForm',
        authorAvatar: AppAssets.image2,
      ),
      PinItem(
        id: 'p5',
        title: 'Monstera deliciosa leaf in minimal white ceramic pot',
        category: 'Botanicals',
        imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=700&q=80',
        assetFallback: AppAssets.image1,
        aspectRatio: 0.88,
        author: 'Leaf & Clay',
        authorAvatar: AppAssets.image5,
        isSaved: true,
      ),
      // Row 3: Left Plant (p7) / Right Tech (p8)
      PinItem(
        id: 'p7',
        title: 'Minimal green cactus in matte white planter',
        category: 'Succulents',
        imageUrl: 'https://images.unsplash.com/photo-1596547609788-b5eebd7a334b?w=700&q=80',
        assetFallback: AppAssets.image4,
        aspectRatio: 0.84,
        author: 'Desert Minimal',
        authorAvatar: AppAssets.image1,
      ),
      PinItem(
        id: 'p8',
        title: 'Developer MacBook Pro setup on warm oak table',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=700&q=80',
        assetFallback: AppAssets.image5,
        aspectRatio: 0.67,
        author: 'Alex Dev',
        authorAvatar: AppAssets.image2,
      ),
      // Row 4: Left Tech (p16) / Right Plant (p9)
      PinItem(
        id: 'p16',
        title: 'MacBook Pro in moody ambient studio lighting',
        category: 'Laptops',
        imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=700&q=80',
        assetFallback: AppAssets.image4,
        aspectRatio: 0.73,
        author: 'Gear Minimal',
        authorAvatar: AppAssets.image4,
      ),
      PinItem(
        id: 'p9',
        title: 'Fresh eucalyptus stem isolated on bright white background',
        category: 'Nature',
        imageUrl: 'https://images.unsplash.com/photo-1611255552402-4f772d00621b?w=700&q=80',
        assetFallback: AppAssets.image1,
        aspectRatio: 0.79,
        author: 'Pure Stems',
        authorAvatar: AppAssets.image3,
      ),
      // Row 5: Left Plant (p11) / Right Tech (p10)
      PinItem(
        id: 'p11',
        title: 'Crisp minimal botanical pot with soft white backdrop',
        category: 'Plants',
        imageUrl: 'https://images.unsplash.com/photo-1604762525343-62309354f8a1?w=700&q=80',
        assetFallback: AppAssets.image5,
        aspectRatio: 0.90,
        author: 'Nordic Flora',
        authorAvatar: AppAssets.image5,
      ),
      PinItem(
        id: 'p10',
        title: 'Custom mechanical keyboard minimalist studio',
        category: 'Accessories',
        imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=700&q=80',
        assetFallback: AppAssets.image4,
        aspectRatio: 0.64,
        author: 'KeyMech',
        authorAvatar: AppAssets.image4,
      ),
      // Row 6: Left Plant (p13) / Right Tech (p12)
      PinItem(
        id: 'p13',
        title: 'Sculptural minimal bonsai tree on pure white',
        category: 'Nature',
        imageUrl: 'https://images.unsplash.com/photo-1684743317217-41bac262ea20?w=700&q=80',
        assetFallback: AppAssets.image3,
        aspectRatio: 0.69,
        author: 'Zen Greenery',
        authorAvatar: AppAssets.image1,
      ),
      PinItem(
        id: 'p12',
        title: 'Clean 4K studio display on bright modern desk',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=700&q=80',
        assetFallback: AppAssets.image2,
        aspectRatio: 0.85,
        author: 'DeskInspo',
        authorAvatar: AppAssets.image6,
      ),
      // Row 7: Left Tech (p18) / Right Plant (p15)
      PinItem(
        id: 'p18',
        title: 'Cozy wooden desk laptop in ambient coding studio',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=700&q=80',
        assetFallback: AppAssets.image6,
        aspectRatio: 0.82,
        author: 'Studio Tech',
        authorAvatar: AppAssets.image6,
      ),
      PinItem(
        id: 'p15',
        title: 'Small desert cactus in minimalist white container',
        category: 'Succulents',
        imageUrl: 'https://images.unsplash.com/photo-1487190296540-b92a6b829973?w=700&q=80',
        assetFallback: AppAssets.image1,
        aspectRatio: 0.71,
        author: 'Arid Studio',
        authorAvatar: AppAssets.image3,
      ),
      // Row 8: Left Plant (p17) / Right Tech (p6)
      PinItem(
        id: 'p17',
        title: 'Lush tabletop plant in Scandinavian white planter',
        category: 'Plants',
        imageUrl: 'https://images.unsplash.com/photo-1509223197845-458d87318791?w=700&q=80',
        assetFallback: AppAssets.image5,
        aspectRatio: 0.75,
        author: 'Green House',
        authorAvatar: AppAssets.image5,
      ),
      PinItem(
        id: 'p6',
        title: 'Matte DSLR camera resting on moody studio table',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=700&q=80',
        assetFallback: AppAssets.image6,
        aspectRatio: 0.87,
        author: 'Lens Studio',
        authorAvatar: AppAssets.image6,
      ),
      // Row 9: Left Tech (p20) / Right Plant (p19)
      PinItem(
        id: 'p20',
        title: 'Clean desktop monitor workstation with warm ambient light',
        category: 'Tech',
        imageUrl: 'https://images.unsplash.com/photo-1587831990711-23ca6441447b?w=700&q=80',
        assetFallback: AppAssets.image6,
        aspectRatio: 0.80,
        author: 'DeskCraft',
        authorAvatar: AppAssets.image2,
      ),
      PinItem(
        id: 'p19',
        title: 'Clean succulent rosette in minimalist ceramic pot',
        category: 'Succulents',
        imageUrl: 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=700&q=80',
        assetFallback: AppAssets.image2,
        aspectRatio: 0.70,
        author: 'Terra Pot',
        authorAvatar: AppAssets.image1,
      ),
    ];
  }

  /// Deals shuffled plants and tech in randomized paired flips so neither masonry column clumps on refresh
  static List<PinItem> getShuffledPins(List<PinItem> currentPins) {
    if (currentPins.length <= 1) return List<PinItem>.of(currentPins);

    final random = Random();
    final previousFirstId = currentPins.first.id;

    final plants = currentPins
        .where((p) => _plantCategories.contains(p.category))
        .toList()
      ..shuffle(random);
    final tech = currentPins
        .where((p) => !_plantCategories.contains(p.category))
        .toList()
      ..shuffle(random);

    final pairCount =
        plants.length < tech.length ? plants.length : tech.length;

    // Flip 2-row blocks ([P,T] vs [T,P]) so both columns stay 50/50 balanced with <=2 consecutive same-theme pins
    final leftIsPlant = <bool>[];
    for (var i = 0; i + 1 < pairCount; i += 2) {
      final plantFirst = random.nextBool();
      leftIsPlant.add(plantFirst);
      leftIsPlant.add(!plantFirst);
    }
    if (leftIsPlant.length < pairCount) {
      leftIsPlant.add(random.nextBool());
    }

    if (pairCount > 0) {
      if (leftIsPlant[0] &&
          plants[0].id == previousFirstId &&
          plants.length > 1) {
        final swapIndex = 1 + random.nextInt(plants.length - 1);
        final temp = plants[0];
        plants[0] = plants[swapIndex];
        plants[swapIndex] = temp;
      } else if (!leftIsPlant[0] &&
          tech[0].id == previousFirstId &&
          tech.length > 1) {
        final swapIndex = 1 + random.nextInt(tech.length - 1);
        final temp = tech[0];
        tech[0] = tech[swapIndex];
        tech[swapIndex] = temp;
      }
    }

    final mixed = <PinItem>[];
    for (var i = 0; i < pairCount; i++) {
      if (leftIsPlant[i]) {
        mixed.add(plants[i]);
        mixed.add(tech[i]);
      } else {
        mixed.add(tech[i]);
        mixed.add(plants[i]);
      }
    }
    mixed.addAll(plants.skip(pairCount));
    mixed.addAll(tech.skip(pairCount));

    return mixed;
  }
}
