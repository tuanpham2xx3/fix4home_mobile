import '../../domain/models/news_article.dart';

class NewsService {
  static final NewsService _instance = NewsService._internal();
  factory NewsService() => _instance;
  NewsService._internal();

  // Mock news articles data based on screenshots
  final List<NewsArticle> _articles = [
    NewsArticle(
      id: '1',
      title: 'Thợ Chống Dột Mái Hiên Nhà, Bảo Hành Dài Lâu',
      shortDescription:
          'Mái hiên là bộ phận luôn xuất hiện hầu hết ở các công trình. Tuy nhiên, mái hiên cũng là nơi hứng chịu nhiều tác động từ môi trường và thời tiết.',
      fullContent:
          'Mái hiên là bộ phận luôn xuất hiện hầu hết ở các công trình. Tuy nhiên, mái hiên cũng là nơi hứng chịu nhiều tác động từ môi trường và thời tiết. Là nơi tiếp xúc với nước mưa đầu tiên, khi trời tạnh, mái hiên cũng là vị trí khô nước chậm nhất. Tốc độ nước trôi bị giảm xuống, sẽ gây ra hiện tượng thấm dột ở mái hiên.\n\nThợ Việt chuyên nhận thi công chống dột mái hiên nhà. Nhận chống dột cho tất cả các mái hiên. Với đội ngũ thợ được đào tạo chuyên nghiệp, sẵn sàng hỗ trợ quý khách. Chuyên giải quyết, khắc phục và xử lý các tình trạng dột nước cục bộ của mái hiên nhà.',
      imageUrl: 'assets/banners/co_khi.png', // Placeholder - should be actual news image
      phoneNumber: '18008122',
      sections: [
        NewsSection(
          title: 'Dịch vụ chống dột mái hiên nhà tại Thợ Việt',
          content:
              'Chống dột cho mái hiên nhà là công việc cần được thực hiện. Giúp bảo vệ mái hiên tránh những tác động xấu. Với các vấn đề hư hỏng, dột nước xảy ra mà không được khắc phục kịp thời. Khi đến mùa mưa gió sẽ rất nguy hiểm. Gây ảnh hưởng đến chất lượng công trình, lẫn quá trình sinh hoạt của khách hàng.\n\nDịch vụ chống thấm dột chất lượng cao, xử lý triệt để hiệu quả 100%. Hạn chế thời gian dột nước trở lại sau nhiều năm sử dụng. Thợ chống dột mái hiên nhà tại Thợ Việt luôn cam kết mang đến dịch vụ tốt nhất cho khách hàng.',
        ),
        NewsSection(
          title: 'Nguyên nhân mái hiên bị hư hỏng',
          content:
              'Để có thể đưa ra phương án sửa chữa phù hợp và hiệu quả, cần phải hiểu rõ nguyên nhân mái hiên bị hư hỏng. Đặc biệt là sau nhiều năm sử dụng, khách hàng cần biết vì sao mái hiên nhà mình lại gặp vấn đề để dễ dàng đề xuất phương án sửa chữa đúng và phù hợp. Sau đây là những nguyên nhân thường gặp mà các thợ sửa chữa gặp phải trong quá trình thi công:',
          bulletPoints: [
            'Mái hiên là bộ phận giúp che chắn ánh nắng mặt trời, mưa gió đập vào tường. Do đó, mái hiên phải chịu tất cả những tác động tiêu cực từ môi trường và thời tiết.',
            'Thường xuyên tiếp xúc với nước mưa dễ dàng khiến axit và các tạp chất làm ăn mòn, oxy hóa bề mặt mái hiên.',
            'Theo thời gian, rêu mốc sẽ bám vào những vị trí ẩm ướt, dễ dàng khiến mái hiên bị hư hỏng. Rêu mốc có thể lan sang tường, gây nứt và ảnh hưởng đến kết cấu bề mặt tường.',
            'Các vết ố vàng, đen làm mất thẩm mỹ của công trình. Nếu để quá lâu sẽ làm nứt bề mặt mái hiên và cuối cùng ảnh hưởng đến các khu vực xung quanh.',
          ],
        ),
        NewsSection(
          title: 'Lưu ý khi thực hiện chống dột',
          content:
              'Khi thực hiện chống dột mái hiên, cần lưu ý một số điểm quan trọng để đảm bảo hiệu quả và độ bền của công trình.',
          bulletPoints: [
            'Chọn vật liệu chống thấm chất lượng cao, phù hợp với loại mái hiên.',
            'Đảm bảo bề mặt mái hiên được làm sạch trước khi thi công.',
            'Thi công đúng quy trình kỹ thuật để đạt hiệu quả tốt nhất.',
            'Kiểm tra và bảo dưỡng định kỳ để kéo dài tuổi thọ.',
          ],
        ),
        NewsSection(
          title: 'Cam kết của Thợ Việt',
          bulletPoints: [
            'Thợ Việt hoạt động trong lĩnh vực xây dựng nói chung và chống dột nói riêng đã nhiều năm. Hoạt động từ năm 2011 đến nay.',
            'Thợ có tay nghề thâm niên, đã và đang thực hiện rất nhiều dự án chống dột khác nhau. Được khách hàng đánh giá cao về chất lượng dịch vụ.',
            'Chi phí dịch vụ luôn cạnh tranh trên thị trường. Không phát sinh thêm chi phí, nếu có thợ sẽ báo giá cụ thể cho quý khách.',
            'Đội ngũ nhân viên tư vấn luôn sẵn sàng hỗ trợ quý khách mọi lúc. Làm việc cả ngày nghỉ và ngày lễ trong năm.',
            'Cam kết sử dụng vật liệu chống dột đều là hàng chính hãng. Cam kết hoàn thành công trình đúng thời hạn.',
            'Chính sách bảo hành dài hạn, nếu có vấn đề gì do thợ hoặc tự nhiên. Thợ sẽ đến kiểm tra và khắc phục cho quý khách.',
          ],
        ),
      ],
      contactInfo: NewsContactInfo(
        websiteUrl: 'https://thoviet.com.vn/tin-tuc/nhat-ky-cong-viec',
        bookingPhone: '18008122',
        consultationPhones: ['0903532938', '0915269839'],
      ),
    ),
    NewsArticle(
      id: '2',
      title: 'Dịch Vụ Chống Thấm Ngược Uy Tín Chất Lượng',
      shortDescription:
          'Nhiều khách hàng lo lắng về chất lượng công trình sau một thời gian sử dụng. Đặc biệt là các vấn đề về thấm dột có thể ảnh hưởng đến chất lượng và tuổi thọ công trình.',
      fullContent:
          'Nhiều khách hàng lo lắng về chất lượng công trình sau một thời gian sử dụng. Đặc biệt là các vấn đề về thấm dột có thể ảnh hưởng đến chất lượng và tuổi thọ công trình.\n\nThợ Việt cung cấp dịch vụ chống thấm ngược uy tín, chất lượng cao với đội ngũ thợ chuyên nghiệp và kinh nghiệm lâu năm. Chúng tôi cam kết mang đến giải pháp chống thấm hiệu quả, bền vững cho mọi công trình.',
      imageUrl: 'assets/banners/dien_nuoc.png',
      phoneNumber: '18008122',
      sections: [
        NewsSection(
          title: 'Tại sao chọn dịch vụ chống thấm ngược',
          content:
              'Chống thấm ngược là phương pháp xử lý thấm dột từ phía trong, không cần đục phá bên ngoài. Phương pháp này phù hợp với các trường hợp không thể thi công từ bên ngoài hoặc cần giải pháp nhanh chóng.',
        ),
      ],
      contactInfo: NewsContactInfo(
        bookingPhone: '18008122',
        consultationPhones: ['0903532938', '0915269839'],
      ),
    ),
    NewsArticle(
      id: '3',
      title: 'Vấn Đề Thường Gặp, Cách Sửa Chữa Máng Xối Nhanh Chóng',
      shortDescription:
          'Nhà ở thường gặp tình trạng nước mưa rò rỉ vào mùa mưa, khiến nước nhỏ giọt xuống tường gây ẩm mốc và hư hỏng.',
      fullContent:
          'Nhà ở thường gặp tình trạng nước mưa rò rỉ vào mùa mưa, khiến nước nhỏ giọt xuống tường gây ẩm mốc và hư hỏng. Máng xối là bộ phận quan trọng giúp thoát nước mưa, nhưng sau thời gian sử dụng có thể bị tắc nghẽn hoặc hư hỏng.\n\nThợ Việt chuyên sửa chữa và thay thế máng xối với đội ngũ thợ có kinh nghiệm. Chúng tôi cung cấp giải pháp nhanh chóng, hiệu quả để khắc phục các vấn đề về máng xối.',
      imageUrl: 'assets/banners/do_nuoc.png',
      phoneNumber: '18008122',
      sections: [
        NewsSection(
          title: 'Các vấn đề thường gặp với máng xối',
          bulletPoints: [
            'Máng xối bị tắc nghẽn do lá cây, rác thải',
            'Máng xối bị rò rỉ, thủng lỗ',
            'Máng xối bị lệch, không đúng độ dốc',
            'Máng xối bị gỉ sét, hư hỏng do thời tiết',
          ],
        ),
      ],
      contactInfo: NewsContactInfo(
        bookingPhone: '18008122',
        consultationPhones: ['0903532938', '0915269839'],
      ),
    ),
    NewsArticle(
      id: '4',
      title: 'Top 5 Phương Pháp Chống Thấm Tường Ngoài Trời',
      shortDescription:
          'Tường ngoài trời là bộ phận chịu tác động trực tiếp từ môi trường bên ngoài như nắng, mưa, bão. Do đó cần có biện pháp chống thấm hiệu quả.',
      fullContent:
          'Tường ngoài trời là bộ phận chịu tác động trực tiếp từ môi trường bên ngoài như nắng, mưa, bão. Do đó cần có biện pháp chống thấm hiệu quả để bảo vệ công trình.\n\nDưới đây là top 5 phương pháp chống thấm tường ngoài trời được Thợ Việt áp dụng và khuyến nghị cho khách hàng.',
      imageUrl: 'assets/banners/noi_that.png',
      phoneNumber: '0915269839',
      sections: [
        NewsSection(
          title: '5 Phương pháp chống thấm hiệu quả',
          bulletPoints: [
            'Sơn chống thấm KOVA CT-IIA - Giải pháp phổ biến và hiệu quả',
            'Chống thấm bằng màng bitum - Độ bền cao, chịu được thời tiết khắc nghiệt',
            'Chống thấm bằng vật liệu gốc xi măng - Phù hợp với tường bê tông',
            'Chống thấm bằng keo epoxy - Độ bám dính cao, chống thấm tốt',
            'Chống thấm bằng vật liệu composite - Hiện đại, độ bền cao',
          ],
        ),
      ],
      contactInfo: NewsContactInfo(
        bookingPhone: '18008122',
        consultationPhones: ['0903532938', '0915269839'],
      ),
    ),
    NewsArticle(
      id: '5',
      title: 'Dán Film Cách Nhiệt, Kính Mờ Cho Cửa Kính Báo Giá',
      shortDescription:
          'Nhu cầu dịch vụ dán film cách nhiệt ngày càng tăng do thay đổi thời tiết. Film cách nhiệt giúp giảm nhiệt độ, tiết kiệm điện năng và tăng tính riêng tư.',
      fullContent:
          'Nhu cầu dịch vụ dán film cách nhiệt ngày càng tăng do thay đổi thời tiết. Film cách nhiệt giúp giảm nhiệt độ, tiết kiệm điện năng và tăng tính riêng tư cho không gian.\n\nThợ Việt cung cấp dịch vụ dán film cách nhiệt và kính mờ chuyên nghiệp cho cửa kính, cửa sổ. Chúng tôi sử dụng film chất lượng cao, đảm bảo hiệu quả và độ bền.',
      imageUrl: 'assets/banners/van_chuyen.png',
      phoneNumber: '18008122',
      sections: [
        NewsSection(
          title: 'Lợi ích của film cách nhiệt',
          bulletPoints: [
            'Giảm nhiệt độ phòng, tiết kiệm điện năng điều hòa',
            'Chống tia UV có hại, bảo vệ nội thất',
            'Tăng tính riêng tư cho không gian',
            'Giảm chói sáng, tạo không gian thoải mái',
          ],
        ),
      ],
      contactInfo: NewsContactInfo(
        bookingPhone: '18008122',
        consultationPhones: ['0903532938', '0915269839'],
      ),
    ),
    NewsArticle(
      id: '6',
      title: 'Thi Công Tủ Bếp Nhôm Kính Chất Lượng, Bảo Hành Lâu Dài',
      shortDescription:
          'Tủ bếp nhôm kính là giải pháp hiện đại, sang trọng cho không gian bếp. Với độ bền cao và dễ vệ sinh, tủ bếp nhôm kính ngày càng được ưa chuộng.',
      fullContent:
          'Tủ bếp nhôm kính là giải pháp hiện đại, sang trọng cho không gian bếp. Với độ bền cao và dễ vệ sinh, tủ bếp nhôm kính ngày càng được ưa chuộng.\n\nThợ Việt chuyên thi công tủ bếp nhôm kính với đội ngũ thợ có tay nghề cao. Chúng tôi cam kết chất lượng sản phẩm và dịch vụ bảo hành lâu dài cho khách hàng.',
      imageUrl: 'assets/banners/ve_sinh.png',
      phoneNumber: '18008122',
      sections: [
        NewsSection(
          title: 'Ưu điểm của tủ bếp nhôm kính',
          bulletPoints: [
            'Độ bền cao, chịu được nhiệt độ và độ ẩm',
            'Dễ vệ sinh, không bị ẩm mốc',
            'Thiết kế hiện đại, sang trọng',
            'Đa dạng mẫu mã, màu sắc',
          ],
        ),
      ],
      contactInfo: NewsContactInfo(
        bookingPhone: '18008122',
        consultationPhones: ['0903532938', '0915269839'],
      ),
    ),
  ];

  Future<List<NewsArticle>> getAllNews() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_articles);
  }

  Future<NewsArticle?> getNewsById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<NewsArticle>> searchNews(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) {
      return getAllNews();
    }
    final lowerQuery = query.toLowerCase();
    return _articles
        .where((article) =>
            article.title.toLowerCase().contains(lowerQuery) ||
            article.shortDescription.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

