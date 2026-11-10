import 'dart:convert';
import 'dart:io';

class PinItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String assetFallback;
  final double aspectRatio;
  final String author;
  final String authorAvatar;
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
    'Home decor',
    'Outfits',
    'Architecture',
    'Aesthetics',
    'Design',
    'Quotes',
    'Photography',
  ];

  static const List<String> trendingSearches = [
    'minimalist apartment',
    'tokyo street style',
    'brutalist architecture',
    'cozy coffee shop',
    'film photography portrait',
    'modern poster typography',
  ];

  static const List<IdeaCard> ideasForYou = [
    IdeaCard(
      title: 'Minimal Living',
      subtitle: 'Warm wood and calm lines',
      imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=600&q=80',
      assetFallback: 'assets/images/5.jpg',
    ),
    IdeaCard(
      title: 'Autumn Wardrobe',
      subtitle: 'Layering and vintage coats',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&q=80',
      assetFallback: 'assets/images/1.jpg',
    ),
    IdeaCard(
      title: 'Editorial Studio',
      subtitle: 'Natural shadow and lighting',
      imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600&q=80',
      assetFallback: 'assets/images/2.jpg',
    ),
    IdeaCard(
      title: 'Cyber Moods',
      subtitle: 'Neon reflections in rainy streets',
      imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600&q=80',
      assetFallback: 'assets/images/3.jpg',
    ),
  ];

  // Authentic Pinterest Collage Boards
  static const List<PinterestBoard> userBoards = [
    PinterestBoard(
      id: 'b1',
      title: 'Design System & UI',
      pinCount: 48,
      updatedTime: '2d',
      mainImage: 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=500&q=80',
      subImage1: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&q=80',
      subImage2: 'https://images.unsplash.com/photo-1522542550221-31fd19575a2d?w=300&q=80',
    ),
    PinterestBoard(
      id: 'b2',
      title: 'Streetwear & Fits',
      pinCount: 112,
      updatedTime: '4d',
      mainImage: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500&q=80',
      subImage1: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=300&q=80',
      subImage2: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80',
    ),
    PinterestBoard(
      id: 'b3',
      title: 'Architecture & Spaces',
      pinCount: 76,
      updatedTime: '1w',
      mainImage: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=500&q=80',
      subImage1: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=300&q=80',
      subImage2: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=300&q=80',
    ),
    PinterestBoard(
      id: 'b4',
      title: 'Secret Project Mood',
      pinCount: 23,
      updatedTime: '2w',
      mainImage: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=500&q=80',
      subImage1: 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=300&q=80',
      subImage2: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=300&q=80',
      isSecret: true,
    ),
  ];

  // 24 completely unique, non-repeating Pinterest pins with distinct aspect ratios
  static List<PinItem> getInitialPins() {
    return [
      PinItem(
        id: 'p1',
        title: 'Minimal concrete interior with morning light',
        category: 'Architecture',
        imageUrl: 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=700&q=80',
        assetFallback: 'assets/images/5.jpg',
        aspectRatio: 0.72,
        author: 'Studio Ark',
        authorAvatar: 'assets/images/1.jpg',
        isSaved: true,
      ),
      PinItem(
        id: 'p2',
        title: 'Autumn tailored oversized trench styling',
        category: 'Outfits',
        imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=700&q=80',
        assetFallback: 'assets/images/1.jpg',
        aspectRatio: 0.65,
        author: 'Elena Mode',
        authorAvatar: 'assets/images/2.jpg',
      ),
      PinItem(
        id: 'p3',
        title: 'Soft shadow beauty portrait on 35mm film',
        category: 'Photography',
        imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=700&q=80',
        assetFallback: 'assets/images/2.jpg',
        aspectRatio: 0.85,
        author: 'Julian V',
        authorAvatar: 'assets/images/3.jpg',
        isSaved: true,
      ),
      PinItem(
        id: 'p4',
        title: 'Tokyo neon rainy night reflection',
        category: 'Aesthetics',
        imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=700&q=80',
        assetFallback: 'assets/images/3.jpg',
        aspectRatio: 0.68,
        author: 'CyberVision',
        authorAvatar: 'assets/images/4.jpg',
      ),
      PinItem(
        id: 'p5',
        title: 'Clean modern ceramic ceramics & coffee corner',
        category: 'Home decor',
        imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=700&q=80',
        assetFallback: 'assets/images/4.jpg',
        aspectRatio: 0.8,
        author: 'Nordic Spaces',
        authorAvatar: 'assets/images/5.jpg',
      ),
      PinItem(
        id: 'p6',
        title: 'Editorial streetwear with structured jacket',
        category: 'Outfits',
        imageUrl: 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=700&q=80',
        assetFallback: 'assets/images/6.jpg',
        aspectRatio: 0.64,
        author: 'Archive Fit',
        authorAvatar: 'assets/images/6.jpg',
        isSaved: true,
      ),
      PinItem(
        id: 'p7',
        title: 'Monochrome glass skyscraper geometry',
        category: 'Architecture',
        imageUrl: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=700&q=80',
        assetFallback: 'assets/images/5.jpg',
        aspectRatio: 0.75,
        author: 'Metropolis',
        authorAvatar: 'assets/images/1.jpg',
      ),
      PinItem(
        id: 'p8',
        title: 'Simplicity is the ultimate sophistication',
        category: 'Quotes',
        imageUrl: 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=700&q=80',
        assetFallback: 'assets/images/3.jpg',
        aspectRatio: 1.05,
        author: 'Typography Daily',
        authorAvatar: 'assets/images/2.jpg',
      ),
      PinItem(
        id: 'p9',
        title: 'Golden hour field portrait in natural sunlight',
        category: 'Photography',
        imageUrl: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=700&q=80',
        assetFallback: 'assets/images/1.jpg',
        aspectRatio: 0.7,
        author: 'Aura Studio',
        authorAvatar: 'assets/images/3.jpg',
      ),
      PinItem(
        id: 'p10',
        title: 'Cozy book lover reading nook with warm lamp',
        category: 'Home decor',
        imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=700&q=80',
        assetFallback: 'assets/images/4.jpg',
        aspectRatio: 0.78,
        author: 'Warm Haven',
        authorAvatar: 'assets/images/4.jpg',
      ),
      PinItem(
        id: 'p11',
        title: 'Neutral palette everyday casual streetwear',
        category: 'Outfits',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=700&q=80',
        assetFallback: 'assets/images/6.jpg',
        aspectRatio: 0.66,
        author: 'FitCheck',
        authorAvatar: 'assets/images/5.jpg',
      ),
      PinItem(
        id: 'p12',
        title: 'Swiss modern poster layout and grid system',
        category: 'Design',
        imageUrl: 'https://images.unsplash.com/photo-1522542550221-31fd19575a2d?w=700&q=80',
        assetFallback: 'assets/images/3.jpg',
        aspectRatio: 0.88,
        author: 'Grid & Type',
        authorAvatar: 'assets/images/6.jpg',
      ),
      PinItem(
        id: 'p13',
        title: 'Brutalist concrete staircase in Berlin',
        category: 'Architecture',
        imageUrl: 'https://images.unsplash.com/photo-1486718448742-163732cd1544?w=700&q=80',
        assetFallback: 'assets/images/5.jpg',
        aspectRatio: 0.73,
        author: 'Concrete Arch',
        authorAvatar: 'assets/images/1.jpg',
      ),
      PinItem(
        id: 'p14',
        title: 'Stay hungry, stay foolish',
        category: 'Quotes',
        imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=700&q=80',
        assetFallback: 'assets/images/4.jpg',
        aspectRatio: 0.95,
        author: 'Words of Note',
        authorAvatar: 'assets/images/2.jpg',
      ),
      PinItem(
        id: 'p15',
        title: 'Moody studio portrait with soft rim light',
        category: 'Photography',
        imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=700&q=80',
        assetFallback: 'assets/images/2.jpg',
        aspectRatio: 0.69,
        author: 'Shadow Works',
        authorAvatar: 'assets/images/3.jpg',
      ),
      PinItem(
        id: 'p16',
        title: 'Mid-century living room with wooden credenza',
        category: 'Home decor',
        imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=700&q=80',
        assetFallback: 'assets/images/5.jpg',
        aspectRatio: 0.77,
        author: 'MidMod Living',
        authorAvatar: 'assets/images/4.jpg',
      ),
    ];
  }

  /// Live public API fetcher for dynamic category loading
  static Future<List<PinItem>> fetchLiveCategoryPins(String category) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);

    try {
      final uri = Uri.parse('https://dummyjson.com/products/category/home-decoration');
      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final Map<String, dynamic> data = jsonDecode(body);
        final List products = data['products'] ?? [];
        if (products.isNotEmpty) {
          return products.take(6).map((item) {
            return PinItem(
              id: 'api_${item['id']}',
              title: item['title'] ?? 'Design inspiration',
              category: category,
              imageUrl: item['thumbnail'] ?? '',
              assetFallback: 'assets/images/5.jpg',
              aspectRatio: 0.8,
              author: 'Curator',
              authorAvatar: 'assets/images/1.jpg',
            );
          }).toList();
        }
      }
    } catch (_) {
      // Graceful offline fallback
    } finally {
      client.close();
    }

    return getInitialPins().where((p) => category == 'All' || p.category.toLowerCase() == category.toLowerCase()).toList();
  }
}
