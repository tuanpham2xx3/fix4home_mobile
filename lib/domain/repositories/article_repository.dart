import '../models/article_dto.dart';
import '../models/article_list_response.dart';

abstract class ArticleRepository {
  /// Lấy danh sách bài viết với phân trang
  Future<ArticleListResponseDTO> getArticles({
    int page = 0,
    int limit = 10,
  });

  /// Lấy chi tiết bài viết theo ID
  Future<ArticleDTO> getArticleById(int id);

  /// Lấy chi tiết bài viết theo slug
  Future<ArticleDTO> getArticleBySlug(String slug);

  /// Tìm kiếm bài viết theo keyword
  Future<ArticleListResponseDTO> searchArticles({
    String? keyword,
    int page = 0,
    int limit = 10,
  });
}

