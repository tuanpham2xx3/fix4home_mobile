import 'article_dto.dart';

class ArticleListResponseDTO {
  final List<ArticleDTO> articles;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ArticleListResponseDTO({
    required this.articles,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ArticleListResponseDTO.fromJson(Map<String, dynamic> json) {
    final articlesList = json['articles'] as List<dynamic>? ?? [];
    return ArticleListResponseDTO(
      articles: articlesList
          .map((article) =>
              ArticleDTO.fromJson(article as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'articles': articles.map((article) => article.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}

