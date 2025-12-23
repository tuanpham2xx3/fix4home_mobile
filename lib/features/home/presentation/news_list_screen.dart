import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/gradient_header.dart';
import '../../../data/services/news_service.dart';
import '../../../domain/models/news_article.dart';

final newsQueryProvider = StateProvider<String>((ref) => '');
final newsPageProvider = StateProvider<int>((ref) => 0);
final newsLimitProvider = StateProvider<int>((ref) => 10);

final filteredNewsProvider =
    FutureProvider.family<ArticleListResponse, Map<String, dynamic>>((ref, params) async {
  final query = params['query'] as String;
  final page = params['page'] as int;
  final limit = params['limit'] as int;
  final service = ref.watch(newsServiceProvider);

  if (query.isEmpty) {
    return service.getAllNews(page: page, limit: limit);
  } else {
    return service.searchNews(query, page: page, limit: limit);
  }
});

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<NewsArticle> _allArticles = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 0;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  void _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final limit = ref.read(newsLimitProvider);
      final query = ref.read(newsQueryProvider);

      final service = ref.read(newsServiceProvider);
      ArticleListResponse response;

      if (query.isEmpty) {
        response = await service.getAllNews(page: nextPage, limit: limit);
      } else {
        response = await service.searchNews(query, page: nextPage, limit: limit);
      }

      setState(() {
        _allArticles.addAll(response.articles);
        _currentPage = nextPage;
        _hasMore = nextPage < response.totalPages - 1;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải thêm bài viết: $e')),
        );
      }
    }
  }

  void _onSearchChanged(String value) {
    ref.read(newsQueryProvider.notifier).state = value;
    setState(() {
      _allArticles.clear();
      _currentPage = 0;
      _hasMore = true;
      _currentQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(newsQueryProvider);
    final limit = ref.watch(newsLimitProvider);

    // Reset state when query changes
    if (query != _currentQuery) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _allArticles.clear();
          _currentPage = 0;
          _hasMore = true;
          _currentQuery = query;
        });
      });
    }

    final newsAsync = ref.watch(
      filteredNewsProvider({
        'query': query,
        'page': 0,
        'limit': limit,
      }),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            const GradientHeader(
              title: 'Tin tức Thợ Việt',
              showBackButton: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _buildSearchBar(),
            ),
            Expanded(
              child: newsAsync.when(
                data: (response) {
                  // Update articles list on first load or when query changes
                  if (_currentPage == 0 || query != _currentQuery) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _allArticles.clear();
                          _allArticles.addAll(response.articles);
                          _currentPage = response.page;
                          _hasMore = response.page < response.totalPages - 1;
                          _currentQuery = query;
                        });
                      }
                    });
                  }

                  if (_allArticles.isEmpty && !_isLoadingMore) {
                    return const Center(child: Text('Chưa có tin tức'));
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemBuilder: (context, index) {
                      if (index < _allArticles.length) {
                        final article = _allArticles[index];
                        return _NewsCard(article: article);
                      } else if (_isLoadingMore) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: _allArticles.length + (_isLoadingMore ? 1 : 0),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lỗi tải tin tức',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(filteredNewsProvider({
                            'query': query,
                            'page': 0,
                            'limit': limit,
                          }));
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
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
              _NewsThumbnail(imageUrl: article.imageUrl),
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
  final String imageUrl;

  const _NewsThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 110,
        height: 110,
        color: Colors.grey[200],
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, color: Colors.grey);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }
}
