class ArticleHeroImage {
  final String url;
  final String? alt;
  final String? caption;

  ArticleHeroImage({
    required this.url,
    this.alt,
    this.caption,
  });

  factory ArticleHeroImage.fromJson(Map<String, dynamic> json) {
    // Trim URL to remove any whitespace or newlines
    final url = (json['url'] ?? '').toString().trim().replaceAll(RegExp(r'\s+'), '');
    return ArticleHeroImage(
      url: url,
      alt: json['alt']?.toString().trim(),
      caption: json['caption']?.toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (alt != null) 'alt': alt,
      if (caption != null) 'caption': caption,
    };
  }
}

