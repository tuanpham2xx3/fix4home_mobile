import 'article_content.dart';
import 'article_hero_image.dart';

// Import ContentBlock for use in factory method

class ArticleSection {
  final String title;
  final String? content;
  final List<String>? bulletPoints;

  ArticleSection({
    required this.title,
    this.content,
    this.bulletPoints,
  });

  factory ArticleSection.fromJson(Map<String, dynamic> json) {
    final bulletPointsList = json['bulletPoints'] as List<dynamic>?;
    return ArticleSection(
      title: json['title'] ?? '',
      content: json['content'],
      bulletPoints: bulletPointsList?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (content != null) 'content': content,
      if (bulletPoints != null) 'bulletPoints': bulletPoints,
    };
  }
}

class ArticleContactInfo {
  final String? websiteUrl;
  final String? bookingPhone;
  final List<String>? consultationPhones;

  ArticleContactInfo({
    this.websiteUrl,
    this.bookingPhone,
    this.consultationPhones,
  });

  factory ArticleContactInfo.fromJson(Map<String, dynamic> json) {
    final consultationPhonesList = json['consultationPhones'] as List<dynamic>?;
    return ArticleContactInfo(
      websiteUrl: json['websiteUrl'],
      bookingPhone: json['bookingPhone'],
      consultationPhones: consultationPhonesList?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (bookingPhone != null) 'bookingPhone': bookingPhone,
      if (consultationPhones != null) 'consultationPhones': consultationPhones,
    };
  }
}

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

  factory ArticleMetadata.fromJson(Map<String, dynamic> json) {
    final tagsList = json['tags'] as List<dynamic>?;
    return ArticleMetadata(
      author: json['author'],
      authorId: json['authorId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      tags: tagsList?.map((e) => e.toString()).toList(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (author != null) 'author': author,
      if (authorId != null) 'authorId': authorId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
      if (tags != null) 'tags': tags,
      if (category != null) 'category': category,
    };
  }
}

class ArticleDTO {
  final int id;
  final String title;
  final String shortDescription;
  final String slug;
  final String status;
  final ArticleContent content;
  final ArticleHeroImage? heroImage;
  final String? metaDescription;
  final String? metaKeywords;
  final List<ArticleSection>? sections;
  final ArticleContactInfo? contactInfo;
  final ArticleMetadata? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;

  ArticleDTO({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.slug,
    required this.status,
    required this.content,
    this.heroImage,
    this.metaDescription,
    this.metaKeywords,
    this.sections,
    this.contactInfo,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  factory ArticleDTO.fromJson(Map<String, dynamic> json) {
    final sectionsList = json['sections'] as List<dynamic>?;
    return ArticleDTO(
      id: json['id'] as int,
      title: json['title'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      slug: json['slug'] ?? '',
      status: json['status'] ?? 'DRAFT',
      content: json['content'] != null
          ? (json['content'] is Map<String, dynamic>
              ? ArticleContent.fromJson(json['content'] as Map<String, dynamic>)
              : ArticleContent(
                  type: 'text',
                  blocks: [
                    ContentBlock(
                      type: 'paragraph',
                      content: json['content'].toString(),
                    )
                  ],
                ))
          : ArticleContent(type: 'structured', blocks: []),
      heroImage: json['heroImage'] != null
          ? ArticleHeroImage.fromJson(json['heroImage'] as Map<String, dynamic>)
          : null,
      metaDescription: json['metaDescription'],
      metaKeywords: json['metaKeywords'],
      sections: sectionsList
          ?.map((s) => ArticleSection.fromJson(s as Map<String, dynamic>))
          .toList(),
      contactInfo: json['contactInfo'] != null
          ? ArticleContactInfo.fromJson(
              json['contactInfo'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] != null
          ? ArticleMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'slug': slug,
      'status': status,
      'content': content.toJson(),
      if (heroImage != null) 'heroImage': heroImage!.toJson(),
      if (metaDescription != null) 'metaDescription': metaDescription,
      if (metaKeywords != null) 'metaKeywords': metaKeywords,
      if (sections != null)
        'sections': sections!.map((s) => s.toJson()).toList(),
      if (contactInfo != null) 'contactInfo': contactInfo!.toJson(),
      if (metadata != null) 'metadata': metadata!.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
    };
  }
}

