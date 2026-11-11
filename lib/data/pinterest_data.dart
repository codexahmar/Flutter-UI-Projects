import 'dart:convert';
import 'dart:io';
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
    'Coding',
    'Tech Setups',
    'Cute DPs',
    'Kids & Smiles',
    'Workspaces',
    'Cyber Aesthetics',
    'Developer Life',
  ];

  static const List<String> trendingSearches = [
    'clean coding setup',
    'cute kids dp',
    'flutter developer desk',
    'neon terminal dark mode',
    'aesthetic profile pictures',
    'mechanical keyboard macro',
  ];

  static const List<IdeaCard> ideasForYou = [
    IdeaCard(
      title: 'Coding Workspaces',
      subtitle: 'Neon screens & mechanical keys',
      imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=700&q=80',
      assetFallback: AppAssets.image5,
    ),
    IdeaCard(
      title: 'Cute DPs & Avatars',
      subtitle: 'Sweet smiles and charming portraits',
      imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=700&q=80',
      assetFallback: AppAssets.image1,
    ),
    IdeaCard(
      title: 'Dev Battlestations',
      subtitle: 'Ultrawides & minimalist desks',
      imageUrl: 'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=700&q=80',
      assetFallback: AppAssets.image2,
    ),
    IdeaCard(
      title: 'Cyber Aesthetics',
      subtitle: 'Matrix terminals & late night glow',
      imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=700&q=80',
      assetFallback: AppAssets.image3,
    ),
  ];

  // Authentic Pinterest Collage Boards
  static const List<PinterestBoard> userBoards = [
    PinterestBoard(
      id: 'b1',
      title: 'Coding & Setups',
      pinCount: 58,
      updatedTime: '2d',
      mainImage: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=700&q=80',
      subImage1: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=700&q=80',
      subImage2: 'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=700&q=80',
    ),
    PinterestBoard(
      id: 'b2',
      title: 'Cute DPs & Avatars',
      pinCount: 94,
      updatedTime: '3d',
      mainImage: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=700&q=80',
      subImage1: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=700&q=80',
      subImage2: 'https://images.unsplash.com/photo-1485546246426-74dc88dec4d9?w=700&q=80',
    ),
    PinterestBoard(
      id: 'b3',
      title: 'Developer Workspaces',
      pinCount: 64,
      updatedTime: '1w',
      mainImage: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=700&q=80',
      subImage1: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=700&q=80',
      subImage2: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=700&q=80',
    ),
    PinterestBoard(
      id: 'b4',
      title: 'Secret Project Ideas',
      pinCount: 21,
      updatedTime: '2w',
      mainImage: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=700&q=80',
      subImage1: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=700&q=80',
      subImage2: 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=700&q=80',
      isSecret: true,
    ),
  ];

  // 16 completely unique Pinterest pins focusing on Tech, Coding, and Cute DPs/Kids
  static List<PinItem> getInitialPins() {
    return [
      PinItem(
        id: 'p1',
        title: 'Minimalist MacBook Pro setup with VS Code & warm coffee',
        category: 'Workspaces',
        imageUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=700&q=80',
        assetFallback: AppAssets.image5,
        aspectRatio: 0.68,
        author: 'Alex Dev',
        authorAvatar: AppAssets.image1,
        isSaved: true,
      ),
      PinItem(
        id: 'p2',
        title: 'Clean dark mode Flutter IDE coding workspace',
        category: 'Coding',
        imageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=700&q=80',
        assetFallback: AppAssets.image2,
        aspectRatio: 0.75,
        author: 'CodeForge',
        authorAvatar: AppAssets.image2,
      ),
      PinItem(
        id: 'p3',
        title: 'Adorable smiling little girl with big eyes (Aesthetic DP)',
        category: 'Cute DPs',
        imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=700&q=80',
        assetFallback: AppAssets.image3,
        aspectRatio: 0.72,
        author: 'SweetSmiles',
        authorAvatar: AppAssets.image3,
        isSaved: true,
      ),
      PinItem(
        id: 'p4',
        title: 'Cyberpunk dual-monitor programming battlestation with purple neon',
        category: 'Tech Setups',
        imageUrl: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=700&q=80',
        assetFallback: AppAssets.image4,
        aspectRatio: 0.68,
        author: 'NeonCoder',
        authorAvatar: AppAssets.image4,
      ),
      PinItem(
        id: 'p5',
        title: 'Cute little coder toddler with oversized studio headphones',
        category: 'Kids & Smiles',
        imageUrl: 'https://images.unsplash.com/photo-1485546246426-74dc88dec4d9?w=700&q=80',
        assetFallback: AppAssets.image1,
        aspectRatio: 0.78,
        author: 'LittleBeats',
        authorAvatar: AppAssets.image5,
      ),
      PinItem(
        id: 'p6',
        title: 'Sweet little boy in cozy winter beanie aesthetic portrait DP',
        category: 'Cute DPs',
        imageUrl: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=700&q=80',
        assetFallback: AppAssets.image6,
        aspectRatio: 0.65,
        author: 'CozyPortraits',
        authorAvatar: AppAssets.image6,
        isSaved: true,
      ),
      PinItem(
        id: 'p7',
        title: 'Neon terminal Matrix green code stream in dark mode',
        category: 'Cyber Aesthetics',
        imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=700&q=80',
        assetFallback: AppAssets.image5,
        aspectRatio: 0.65,
        author: 'CyberVision',
        authorAvatar: AppAssets.image1,
      ),
      PinItem(
        id: 'p8',
        title: 'Clean programmer workspace with ultrawide monitor & mechanical keyboard',
        category: 'Workspaces',
        imageUrl: 'https://images.unsplash.com/photo-1587620962725-abab7fe55159?w=700&q=80',
        assetFallback: AppAssets.image3,
        aspectRatio: 0.78,
        author: 'DeskInspo',
        authorAvatar: AppAssets.image2,
      ),
      PinItem(
        id: 'p9',
        title: 'Happy cheerful little kid laughing joyfully in natural sunlight',
        category: 'Kids & Smiles',
        imageUrl: 'https://images.unsplash.com/photo-1544717302-de2939b7ef71?w=700&q=80',
        assetFallback: AppAssets.image1,
        aspectRatio: 0.73,
        author: 'SunshineKids',
        authorAvatar: AppAssets.image3,
      ),
      PinItem(
        id: 'p10',
        title: 'MacBook screen with clean syntax highlighting & evening vibe',
        category: 'Developer Life',
        imageUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=700&q=80',
        assetFallback: AppAssets.image4,
        aspectRatio: 0.70,
        author: 'WorkspaceHub',
        authorAvatar: AppAssets.image4,
      ),
      PinItem(
        id: 'p11',
        title: 'Aesthetic pastel hoodie portrait (Clean Aesthetic DP)',
        category: 'Cute DPs',
        imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=700&q=80',
        assetFallback: AppAssets.image6,
        aspectRatio: 0.66,
        author: 'AestheticDPs',
        authorAvatar: AppAssets.image5,
      ),
      PinItem(
        id: 'p12',
        title: 'Colorful frontend HTML, CSS & JavaScript code snippet',
        category: 'Coding',
        imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=700&q=80',
        assetFallback: AppAssets.image3,
        aspectRatio: 0.85,
        author: 'FrontEndDaily',
        authorAvatar: AppAssets.image6,
      ),
      PinItem(
        id: 'p13',
        title: 'Cute smart toddler with glasses looking curiously at book',
        category: 'Kids & Smiles',
        imageUrl: 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=700&q=80',
        assetFallback: AppAssets.image5,
        aspectRatio: 0.75,
        author: 'TinyTech',
        authorAvatar: AppAssets.image1,
      ),
      PinItem(
        id: 'p14',
        title: 'Custom mechanical keyboard with aesthetic artisan keycaps',
        category: 'Tech Setups',
        imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=700&q=80',
        assetFallback: AppAssets.image4,
        aspectRatio: 0.68,
        author: 'KeyMech',
        authorAvatar: AppAssets.image2,
      ),
      PinItem(
        id: 'p15',
        title: 'Sweet smiling baby girl in warm sunlight (Adorable DP)',
        category: 'Cute DPs',
        imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=700&q=80',
        assetFallback: AppAssets.image2,
        aspectRatio: 0.71,
        author: 'PureSmile',
        authorAvatar: AppAssets.image3,
      ),
      PinItem(
        id: 'p16',
        title: 'Modern software engineering architecture & wireframe system',
        category: 'Coding',
        imageUrl: 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=700&q=80',
        assetFallback: AppAssets.image5,
        aspectRatio: 0.80,
        author: 'SoftwareCraft',
        authorAvatar: AppAssets.image4,
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
              assetFallback: AppAssets.image5,
              aspectRatio: 0.8,
              author: 'Curator',
              authorAvatar: AppAssets.image1,
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
