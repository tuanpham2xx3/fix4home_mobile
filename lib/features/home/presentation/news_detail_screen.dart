import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/gradient_header.dart';
import '../../../domain/models/news_article.dart';
import '../../../data/services/news_service.dart';

final newsDetailProvider =
    FutureProvider.family<NewsArticle?, String>((ref, id) async {
  final service = ref.watch(newsServiceProvider);
  return service.getNewsById(id);
});

class NewsDetailScreen extends ConsumerWidget {
  final String id;

  const NewsDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsDetailProvider(id));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            const GradientHeader(
              title: 'Chi tiết tin tức',
              showBackButton: true,
            ),
            Expanded(
              child: newsAsync.when(
                data: (article) {
                  if (article == null) {
                    return const Center(child: Text('Không tìm thấy bài viết'));
                  }
                  return _buildContent(context, article);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lỗi tải bài viết',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(newsDetailProvider(id));
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

  Widget _buildContent(BuildContext context, NewsArticle article) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroImage(article.heroImage),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                // Render structured content blocks
                if (article.content != null && article.content!.blocks.isNotEmpty)
                  ...article.content!.blocks.map((block) => _ContentBlockWidget(block: block)),
                // Fallback to fullContent if no structured content
                if (article.content == null || article.content!.blocks.isEmpty)
                  Text(
                    article.fullContent,
                    style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                  ),
                const SizedBox(height: 16),
                _buildBookingButton(context, article.title),
                const SizedBox(height: 20),
                ...article.sections.map((s) => _SectionBlock(section: s)),
                const SizedBox(height: 20),
                _ContactInfo(contactInfo: article.contactInfo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(HeroImage? heroImage) {
    final imageUrl = heroImage?.url ?? '';
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            )
          : Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              ),
            ),
    );
  }

  Widget _buildBookingButton(BuildContext context, String serviceName) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC107),
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        icon: const Icon(Icons.event_available),
        label: const Text(
          'Đặt lịch nhanh chóng',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          final uri = Uri(
            path: '/quick-booking',
            queryParameters: {'serviceName': serviceName},
          );
          context.push(uri.toString());
        },
      ),
    );
  }
}

// Widget to render individual content blocks
class _ContentBlockWidget extends StatelessWidget {
  final ContentBlock block;

  const _ContentBlockWidget({required this.block});

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case 'paragraph':
        if (block.content == null || block.content!.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            block.content!,
            style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
          ),
        );

      case 'heading':
        if (block.content == null || block.content!.isEmpty) {
          return const SizedBox.shrink();
        }
        final level = block.level ?? 2;
        final fontSize = _getHeadingFontSize(level);
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            block.content!,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        );

      case 'unorderedList':
      case 'orderedList':
        if (block.items == null || block.items!.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: block.items!.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      block.type == 'orderedList' ? '${index + 1}. ' : '•  ',
                      style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );

      case 'image':
        if (block.url == null || block.url!.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  block.url!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
              if (block.caption != null && block.caption!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    block.caption!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        );

      case 'link':
        if (block.url == null || block.url!.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => launchUrl(Uri.parse(block.url!)),
            child: Text(
              block.content ?? block.url!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
                height: 1.5,
              ),
            ),
          ),
        );

      default:
        // Unknown block type, try to render content if available
        if (block.content != null && block.content!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              block.content!,
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
          );
        }
        return const SizedBox.shrink();
    }
  }

  double _getHeadingFontSize(int level) {
    switch (level) {
      case 1:
        return 28;
      case 2:
        return 24;
      case 3:
        return 20;
      case 4:
        return 18;
      case 5:
        return 16;
      case 6:
        return 14;
      default:
        return 20;
    }
  }
}

class _SectionBlock extends StatelessWidget {
  final NewsSection section;

  const _SectionBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (section.content != null && section.content!.isNotEmpty)
            Text(
              section.content!,
              style: const TextStyle(fontSize: 15.5, color: Colors.black87, height: 1.55),
            ),
          if (section.bulletPoints != null && section.bulletPoints!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: section.bulletPoints!
                  .map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '•  ',
                              style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                            ),
                            Expanded(
                              child: Text(
                                b,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final NewsContactInfo contactInfo;

  const _ContactInfo({required this.contactInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contactInfo.websiteUrl != null && contactInfo.websiteUrl!.isNotEmpty)
          _linkRow('Xem thêm', contactInfo.websiteUrl!),
        const SizedBox(height: 8),
        Text(
          'ĐT đặt lịch miễn phí cước: ${contactInfo.bookingPhone}',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          'Hotline tư vấn: ${contactInfo.consultationPhones.join(' - ')}',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _linkRow(String label, String url) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Text(
        url,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
