class NewsSection {
  final String title;
  final String? content;
  final List<String>? bulletPoints;

  NewsSection({
    required this.title,
    this.content,
    this.bulletPoints,
  });
}

class NewsContactInfo {
  final String? websiteUrl;
  final String bookingPhone;
  final List<String> consultationPhones;

  NewsContactInfo({
    this.websiteUrl,
    required this.bookingPhone,
    required this.consultationPhones,
  });
}

class NewsArticle {
  final String id;
  final String title;
  final String shortDescription;
  final String fullContent;
  final String imageUrl;
  final String phoneNumber;
  final List<NewsSection> sections;
  final NewsContactInfo contactInfo;

  NewsArticle({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullContent,
    required this.imageUrl,
    required this.phoneNumber,
    required this.sections,
    required this.contactInfo,
  });
}

