import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/gradient_header.dart';
import '../../../data/services/news_service.dart';
import '../../../domain/models/news_article.dart';
import '../../../domain/repositories/article_repository.dart';
import '../../../data/repositories/api_article_repository.dart';
import '../../../core/services/api_client.dart';

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiArticleRepository(dio);
});

final newsServiceProvider = Provider<NewsService>((ref) {
  final repository = ref.watch(articleRepositoryProvider);
  return NewsService(repository);
});

final newsQueryProvider = StateProvider<String>((ref) => '');

final filteredNewsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  final query = ref.watch(newsQueryProvider);
  final service = ref.watch(newsServiceProvider);
  if (query.isEmpty) {
    return service.getAllNews();
  }
  return service.searchNews(query);
});

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    // Refresh news every 5 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        ref.refresh(filteredNewsProvider);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(filteredNewsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            const GradientHeader(
              title: 'Tin tức',
              showBackButton: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _buildSearchBar(),
            ),
            Expanded(
              child: newsAsync.when(
                data: (articles) {
                  if (articles.isEmpty) {
                    return const Center(child: Text('Chưa có tin tức'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return _NewsCard(article: article);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: articles.length,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    'Lỗi tải tin tức',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(newsQueryProvider.notifier).state = value;
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          hintText: 'Tìm kiếm tin tức...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/news/${article.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NewsThumbnail(imagePath: article.imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.shortDescription,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        const Text(
                          'Quét mã đặt lịch',
                          style: TextStyle(fontSize: 12.5, color: Colors.black54),
                        ),
                        Text(
                          'Gọi THỢ VIỆT ${article.phoneNumber}',
                          style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsThumbnail extends StatelessWidget {
  final String imagePath;

  const _NewsThumbnail({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 110,
        height: 110,
        color: Colors.grey[200],
        child: imagePath.startsWith('http')
            ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, color: Colors.grey);
                },
              )
            : Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, color: Colors.grey);
                },
              ),
      ),
    );
  }
}

