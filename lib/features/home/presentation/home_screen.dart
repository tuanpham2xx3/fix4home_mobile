import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'service_menu_screen.dart';
import 'search_screen.dart';
import 'membership_screen.dart';
import 'main_navigation.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // PageControllers for carousels
  late PageController _promoPageController;
  late PageController _servicesPageController;
  late PageController _articlesPageController;
  
  // Timers for auto-scrolling
  Timer? _promoTimer;
  Timer? _servicesTimer;
  Timer? _articlesTimer;
  
  // Current page indices
  int _promoCurrentPage = 0;
  int _servicesCurrentPage = 0;
  int _articlesCurrentPage = 0;
  
  // Banner lists
  final List<String> _banners = [
    'assets/banners/co_khi.png',
    'assets/banners/dien_nuoc.png',
    'assets/banners/do_nuoc.png',
    'assets/banners/noi_that.png',
    'assets/banners/van_chuyen.png',
    'assets/banners/ve_sinh.png',
  ];

  @override
  void initState() {
    super.initState();
    _promoPageController = PageController(viewportFraction: 0.8, initialPage: 0);
    _servicesPageController = PageController(viewportFraction: 0.8, initialPage: 0);
    _articlesPageController = PageController(viewportFraction: 0.8, initialPage: 0);
    
    _startAutoScroll();
  }

  void _openServiceBottomSheet(BuildContext context, String serviceKey, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.78,
          child: ServiceMenuBottomSheet(
            serviceKey: serviceKey,
            serviceTitle: title,
          ),
        );
      },
    );
  }

  void _startAutoScroll() {
    // Auto-scroll for promotional section
    _promoTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_promoPageController.hasClients) {
        _promoCurrentPage = (_promoCurrentPage + 1) % _banners.length;
        _promoPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    // Auto-scroll for services section
    _servicesTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_servicesPageController.hasClients) {
        _servicesCurrentPage = (_servicesCurrentPage + 1) % _banners.length;
        _servicesPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    // Auto-scroll for articles section
    _articlesTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_articlesPageController.hasClients) {
        _articlesCurrentPage = (_articlesCurrentPage + 1) % 3;
        _articlesPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _pauseAutoScroll() {
    _promoTimer?.cancel();
    _servicesTimer?.cancel();
    _articlesTimer?.cancel();
  }

  void _resumeAutoScroll() {
    _startAutoScroll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _promoTimer?.cancel();
    _servicesTimer?.cancel();
    _articlesTimer?.cancel();
    _promoPageController.dispose();
    _servicesPageController.dispose();
    _articlesPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverAppBar - Header màu vàng (ẩn khi cuộn xuống, hiện khi cuộn lên)
            SliverAppBar(
              backgroundColor: Colors.transparent, // Để gradient hiển thị rõ
              floating: true,
              snap: true,
              expandedHeight: 130.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFD54F), // Vàng đậm ở trên
                        Color(0xFFFFC107), // Vàng trung bình
                        Color(0xCCFFC107), // Vàng nhạt (80% opacity)
                        Color(0x99FFC107), // Vàng nhạt (60% opacity)
                        Color(0x66FFC107), // Vàng nhạt (40% opacity)
                        Color(0x33FFC107), // Vàng nhạt (20% opacity)
                        Color(0x10FFC107), // Vàng cực nhạt (6% opacity)
                        Colors.transparent, // Hoàn toàn trong suốt
                      ],
                      stops: [0.0, 0.2, 0.4, 0.55, 0.7, 0.85, 0.95, 1.0], // Fade mượt từ trên xuống
                    ),
                  ),
                  child: _buildHeaderContent(context, ref),
                ),
              ),
            ),
            
            // SliverPersistentHeader - Search bar sticky
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                child: _buildSearchBar(),
              ),
            ),
            
            // Nội dung scrollable
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Services Grid Section
                  _buildServicesSection(),
                  
                  // Promotion Banner Section
                  _buildPromotionSection(),
                  
                  // Services and Commerce Section
                  _buildServicesCommerceSection(),
                  
                  // Featured Articles Section
                  _buildFeaturedArticlesSection(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Picture
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: const Icon(Icons.person, color: Colors.grey, size: 30),
              ),
              const SizedBox(width: 12),
              // Points Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MembershipScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.monetization_on, color: Color(0xFFFFC107), size: 18),
                      SizedBox(width: 4),
                      Text(
                        '0 điểm',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Notification Icon
              _buildIconWithBadge(
                icon: Icons.notifications_outlined,
                badgeCount: '38',
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              // Message Icon
              _buildIconWithBadge(
                icon: Icons.message_outlined,
                badgeCount: '38',
                onPressed: () {
                  // Chuyển sang màn hình tin nhắn (index 2)
                  ref.read(selectedIndexProvider.notifier).state = 2;
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Greeting and Question
          Row(
            children: [
              const Text(
                'Chào User !',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Bạn muốn sửa gì ?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithBadge({
    required IconData icon,
    required String badgeCount,
    required VoidCallback onPressed,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, size: 28, color: Colors.black87),
            onPressed: onPressed,
            padding: EdgeInsets.zero,
          ),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Text(
              badgeCount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        context.push('/search');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.grey, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Hơn 100 dịch vụ Quý Khách đang cần...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Đặt dịch vụ ngay',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildServicesGrid(),
        ],
      ),
    );
  }

  Widget _buildServicesGrid() {
    final services = [
      {'title': 'Xây dựng sửa nhà', 'image': 'assets/menu/sua_nha.png', 'key': 'XayDungSuaNha'},
      {'title': 'Cơ khí nhôm kính', 'image': 'assets/menu/co_khi.png', 'key': 'CoKhiNhomKinh'},
      {'title': 'Điện nước', 'image': 'assets/menu/dien_nuoc.png', 'key': 'DienNuoc'},
      {'title': 'Điện lạnh', 'image': 'assets/menu/dien_lanh.png', 'key': 'DienLanh'},
      {'title': 'Điện máy', 'image': 'assets/menu/dien_may.png', 'key': 'DienMay'},
      {'title': 'Đồ gỗ nội thất', 'image': 'assets/menu/do_go.png', 'key': 'DoGoNoiThat'},
      {'title': 'Vệ sinh', 'image': 'assets/menu/ve_sinh.png', 'key': 'VeSinh'},
      {'title': 'Thông nghẹt hút hầm', 'image': 'assets/menu/thong_nghet.png', 'key': 'ThongNghetHutHam'},
      {'title': 'Vận chuyển', 'image': 'assets/menu/van_chuyen.png', 'key': 'ChuyenNha'},
      {'title': 'Dịch vụ khác', 'image': 'assets/menu/dich_vu_khac.png', 'key': 'DichVuKhac'},
      {'title': 'Bảng giá', 'image': 'assets/menu/bang_gia.png', 'key': 'BangGia'},
      {'title': 'Tin tức', 'image': 'assets/menu/tin_tuc.png', 'key': 'TinTuc'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceItem(
          service['title'] as String,
          service['image'] as String,
          service['key'] as String?,
        );
      },
    );
  }

  Widget _buildServiceItem(String title, String imagePath, String? serviceKey) {
    return GestureDetector(
      onTap: () {
        if (serviceKey != null && serviceKey != 'DichVuKhac' && serviceKey != 'BangGia' && serviceKey != 'TinTuc') {
          _openServiceBottomSheet(context, serviceKey, title);
        } else if (serviceKey == 'BangGia') {
          context.push('/price');
        } else {
          // Handle special services (DichVuKhac, BangGia, TinTuc)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tính năng $title sẽ được cập nhật sớm')),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107), // Yellow background
              borderRadius: BorderRadius.circular(35),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Chương trình khuyến mãi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _promoPageController,
              onPageChanged: (index) {
                setState(() {
                  _promoCurrentPage = index % _banners.length;
                });
              },
              itemCount: _banners.length * 100, // Infinite scroll
              itemBuilder: (context, index) {
                final bannerIndex = index % _banners.length;
                return _buildCarouselItem(_banners[bannerIndex], _promoPageController, index.toDouble());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCommerceSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Dịch vụ và Thương mại',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _servicesPageController,
              onPageChanged: (index) {
                setState(() {
                  _servicesCurrentPage = index % _banners.length;
                });
              },
              itemCount: _banners.length * 100, // Infinite scroll
              itemBuilder: (context, index) {
                final bannerIndex = index % _banners.length;
                return _buildCarouselItem(_banners[bannerIndex], _servicesPageController, index.toDouble());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedArticlesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Bài viết nổi bật',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _articlesPageController,
              onPageChanged: (index) {
                setState(() {
                  _articlesCurrentPage = index % 3;
                });
              },
              itemCount: 3 * 100, // Infinite scroll
              itemBuilder: (context, index) {
                final articleIndex = index % 3;
                return _buildArticleCarouselItem(_articlesPageController, index.toDouble(), articleIndex);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath, PageController controller, double index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (!controller.position.haveDimensions) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        final page = controller.page ?? 0;
        final difference = (page - index).abs();
        
        double scale = 1.0;
        double opacity = 1.0;
        
        // With viewportFraction 0.8, adjacent pages are 0.8 apart
        if (difference > 0.6) {
          // Side items: smaller and less opaque
          scale = 0.6;
          opacity = 0.5;
        } else if (difference > 0.2) {
          // Transition items
          final progress = (difference - 0.2) / 0.4;
          scale = 0.6 + (0.4 * (1 - progress));
          opacity = 0.5 + (0.5 * (1 - progress));
        } else {
          // Center item: full size and opacity
          scale = 1.0;
          opacity = 1.0;
        }

        return Transform.scale(
          scale: scale,
          alignment: Alignment.center,
          child: Opacity(
            opacity: opacity,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2 * opacity),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildArticleCarouselItem(PageController controller, double index, int articleIndex) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (!controller.position.haveDimensions) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: articleIndex == 1 ? const Color(0xFFFFC107) : const Color(0xFF2196F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Loading...'),
            ),
          );
        }

        final page = controller.page ?? 0;
        final difference = (page - index).abs();
        
        double scale = 1.0;
        double opacity = 1.0;
        
        // With viewportFraction 0.8, adjacent pages are 0.8 apart
        if (difference > 0.6) {
          // Side items: smaller and less opaque
          scale = 0.6;
          opacity = 0.5;
        } else if (difference > 0.2) {
          // Transition items
          final progress = (difference - 0.2) / 0.4;
          scale = 0.6 + (0.4 * (1 - progress));
          opacity = 0.5 + (0.5 * (1 - progress));
        } else {
          // Center item: full size and opacity
          scale = 1.0;
          opacity = 1.0;
        }

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: articleIndex == 1 ? const Color(0xFFFFC107) : const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2 * opacity),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'FIX4HOME',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      articleIndex == 1 
                        ? 'DỊCH VỤ ĐIỆN NƯỚC'
                        : 'DỊCH VỤ CƠ KHÍ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (articleIndex == 1) ...[
                      const Text(
                        '• Hệ thống điện - nước',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      const Text(
                        '• Hệ thống mạng, camera',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      const Text(
                        '• Hệ thống thiết bị NLMT',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                    const Spacer(),
                    const Text(
                      '1800 812',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom delegate cho Search Bar SliverPersistentHeader
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarDelegate({required this.child});

  @override
  double get minExtent => 60.0;

  @override
  double get maxExtent => 60.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
