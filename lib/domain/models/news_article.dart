// Content Block Models
class ContentBlock {
  final String type;
  final String? content;
  final int? level; // For heading
  final List<String>? items; // For lists
  final String? spacing; // For lists
  final String? url; // For image/link
  final String? alt; // For image
  final String? caption; // For image

  ContentBlock({
    required this.type,
    this.content,
    this.level,
    this.items,
    this.spacing,
    this.url,
    this.alt,
    this.caption,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: json['type'] as String,
      content: json['content'] as String?,
      level: json['level'] as int?,
      items: json['items'] != null
          ? List<String>.from(json['items'] as List)
          : null,
      spacing: json['spacing'] as String?,
      url: json['url'] as String?,
      alt: json['alt'] as String?,
      caption: json['caption'] as String?,
    );
  }
}

class ArticleContent {
  final String type;
  final List<ContentBlock> blocks;

  ArticleContent({
    required this.type,
    required this.blocks,
  });

  factory ArticleContent.fromJson(Map<String, dynamic> json) {
    return ArticleContent(
      type: json['type'] as String? ?? 'structured',
      blocks: (json['blocks'] as List<dynamic>?)
              ?.map((block) => ContentBlock.fromJson(block as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// Hero Image Model
class HeroImage {
  final String? url;
  final String? alt;
  final String? caption;

  HeroImage({
    this.url,
    this.alt,
    this.caption,
  });

  factory HeroImage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return HeroImage();
    return HeroImage(
      url: json['url'] as String?,
      alt: json['alt'] as String?,
      caption: json['caption'] as String?,
    );
  }
}

// Section Model
class NewsSection {
  final String title;
  final String? content;
  final List<String>? bulletPoints;

  NewsSection({
    required this.title,
    this.content,
    this.bulletPoints,
  });

  factory NewsSection.fromJson(Map<String, dynamic> json) {
    return NewsSection(
      title: json['title'] as String? ?? '',
      content: json['content'] as String?,
      bulletPoints: json['bulletPoints'] != null
          ? List<String>.from(json['bulletPoints'] as List)
          : null,
    );
  }
}

// Contact Info Model
class NewsContactInfo {
  final String? websiteUrl;
  final String bookingPhone;
  final List<String> consultationPhones;

  NewsContactInfo({
    this.websiteUrl,
    required this.bookingPhone,
    required this.consultationPhones,
  });

  factory NewsContactInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return NewsContactInfo(
        bookingPhone: '',
        consultationPhones: [],
      );
    }
    return NewsContactInfo(
      websiteUrl: json['websiteUrl'] as String?,
      bookingPhone: json['bookingPhone'] as String? ?? '',
      consultationPhones: json['consultationPhones'] != null
          ? List<String>.from(json['consultationPhones'] as List)
          : [],
    );
  }
}

// Article Metadata Model
class ArticleMetadata {
  final String? author;
  final int? authorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final List<String>? tags;
  final String? category;

  ArticleMetadata({
    this.author,
    this.authorId,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.tags,
    this.category,
  });

  factory ArticleMetadata.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ArticleMetadata();
    return ArticleMetadata(
      author: json['author'] as String?,
      authorId: json['authorId'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      category: json['category'] as String?,
    );
  }
}

// Main Article Model
class NewsArticle {
  final int id;
  final String title;
  final String shortDescription;
  final String? slug;
  final ArticleContent? content;
  final HeroImage? heroImage;
  final String? metaDescription;
  final String? metaKeywords;
  final String? status;
  final List<NewsSection> sections;
  final NewsContactInfo contactInfo;
  final ArticleMetadata metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;

  // Legacy fields for backward compatibility
  String get imageUrl => heroImage?.url ?? '';
  String get phoneNumber => contactInfo.bookingPhone;
  String get fullContent {
    // Extract text from content blocks
    if (content?.blocks.isEmpty ?? true) return '';
    return content!.blocks
        .where((block) => block.content != null)
        .map((block) => block.content!)
        .join('\n\n');
  }

  NewsArticle({
    required this.id,
    required this.title,
    required this.shortDescription,
    this.slug,
    this.content,
    this.heroImage,
    this.metaDescription,
    this.metaKeywords,
    this.status,
    required this.sections,
    required this.contactInfo,
    required this.metadata,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      slug: json['slug'] as String?,
      content: json['content'] != null
          ? ArticleContent.fromJson(json['content'] as Map<String, dynamic>)
          : null,
      heroImage: HeroImage.fromJson(json['heroImage'] as Map<String, dynamic>?),
      metaDescription: json['metaDescription'] as String?,
      metaKeywords: json['metaKeywords'] as String?,
      status: json['status'] as String?,
      sections: (json['sections'] as List<dynamic>?)
              ?.map((section) =>
                  NewsSection.fromJson(section as Map<String, dynamic>))
              .toList() ??
          [],
      contactInfo: NewsContactInfo.fromJson(
          json['contactInfo'] as Map<String, dynamic>?),
      metadata: ArticleMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>?),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
    );
  }
}

// Pagination Response Model
class ArticleListResponse {
  final List<NewsArticle> articles;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ArticleListResponse({
    required this.articles,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ArticleListResponse.fromJson(Map<String, dynamic> json) {
    return ArticleListResponse(
      articles: (json['articles'] as List<dynamic>?)
              ?.map((article) =>
                  NewsArticle.fromJson(article as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}
