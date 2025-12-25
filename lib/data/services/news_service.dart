import 'package:flutter/foundation.dart';
import '../../domain/models/news_article.dart';
import '../../domain/repositories/article_repository.dart';
import '../../domain/models/article_dto.dart';
import '../../core/config/api_config.dart';

class NewsService {
  final ArticleRepository _articleRepository;

  NewsService(this._articleRepository);

  // Helper method to normalize image URL
  String _normalizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    
    // Trim and remove all whitespace/newlines
    String normalized = url.trim().replaceAll(RegExp(r'\s+'), '');
    
    if (normalized.isEmpty) return '';
    
    try {
      if (!normalized.startsWith('http')) {
        // Relative URL - prepend base URL
        normalized = '${ApiConfig.baseUrl}$normalized';
      } else {
        // Absolute URL - handle localhost conversion for Android emulator
        final baseUrlParts = Uri.parse(ApiConfig.baseUrl);
        final imageUrlParts = Uri.parse(normalized);
        
        // If image URL uses localhost/127.0.0.1 but baseUrl uses different host, replace it
        if ((imageUrlParts.host == 'localhost' || imageUrlParts.host == '127.0.0.1') &&
            baseUrlParts.host != 'localhost' && baseUrlParts.host != '127.0.0.1') {
          normalized = normalized.replaceFirst(
            '${imageUrlParts.scheme}://${imageUrlParts.host}',
            '${baseUrlParts.scheme}://${baseUrlParts.host}',
          );
        }
      }
      
      // Validate URL by parsing it
      Uri.parse(normalized);
      
      if (kDebugMode) {
        print('Image URL normalized: $normalized');
      }
      
      return normalized;
    } catch (e) {
      if (kDebugMode) {
        print('Error normalizing image URL: $url, error: $e');
      }
      return '';
    }
  }

  // Helper method to convert ArticleDTO to NewsArticle
  NewsArticle _articleDtoToNewsArticle(ArticleDTO dto) {
    // Extract full content from structured content blocks
    String fullContent = '';
    if (dto.content.type == 'structured' && dto.content.blocks.isNotEmpty) {
      fullContent = dto.content.extractText();
    } else if (dto.content.blocks.isNotEmpty) {
      // Fallback: extract all text from blocks
      fullContent = dto.content.blocks
          .where((block) => block.content != null)
          .map((block) => block.content!)
          .join('\n\n');
    }

    // Handle image URL (can be absolute or relative)
    String imageUrl = _normalizeImageUrl(dto.heroImage?.url);

    // Map sections
    List<NewsSection> sections = [];
    if (dto.sections != null && dto.sections!.isNotEmpty) {
      sections = dto.sections!.map((section) {
        return NewsSection(
          title: section.title,
          content: section.content,
          bulletPoints: section.bulletPoints,
        );
      }).toList();
    }

    // Map contact info
    NewsContactInfo contactInfo;
    if (dto.contactInfo != null) {
      contactInfo = NewsContactInfo(
        websiteUrl: dto.contactInfo!.websiteUrl,
        bookingPhone: dto.contactInfo!.bookingPhone ?? '',
        consultationPhones: dto.contactInfo!.consultationPhones ?? [],
      );
    } else {
      // Default contact info if not provided
      contactInfo = NewsContactInfo(
        bookingPhone: '',
        consultationPhones: [],
      );
    }

    return NewsArticle(
      id: dto.id.toString(),
      title: dto.title,
      shortDescription: dto.shortDescription,
      fullContent: fullContent,
      imageUrl: imageUrl,
      phoneNumber: contactInfo.bookingPhone,
      sections: sections,
      contactInfo: contactInfo,
    );
  }

  Future<List<NewsArticle>> getAllNews() async {
    try {
      final response = await _articleRepository.getArticles(
        page: 0,
        limit: 100, // Get up to 100 articles
      );
      return response.articles.map(_articleDtoToNewsArticle).toList();
    } catch (e) {
      // Return empty list on error (UI will handle error states)
      return [];
    }
  }

  Future<NewsArticle?> getNewsById(String id) async {
    try {
      // Try parsing as int first (ID)
      final articleId = int.tryParse(id);
      ArticleDTO article;
      
      if (articleId != null) {
        article = await _articleRepository.getArticleById(articleId);
      } else {
        // If not a number, try as slug
        article = await _articleRepository.getArticleBySlug(id);
      }
      
      return _articleDtoToNewsArticle(article);
    } catch (e) {
      return null;
    }
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    try {
      if (query.isEmpty) {
        return getAllNews();
      }
      
      final response = await _articleRepository.searchArticles(
        keyword: query,
        page: 0,
        limit: 100,
      );
      return response.articles.map(_articleDtoToNewsArticle).toList();
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }
}
