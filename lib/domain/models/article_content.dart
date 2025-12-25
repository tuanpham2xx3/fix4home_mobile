class ContentBlock {
  final String type;
  final String? content;
  final int? level; // For headings

  ContentBlock({
    required this.type,
    this.content,
    this.level,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: json['type'] ?? '',
      content: json['content'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (content != null) 'content': content,
      if (level != null) 'level': level,
    };
  }
}

class ArticleContent {
  final String type;
  final List<ContentBlock> blocks;

  ArticleContent({
    required this.type,
    required this.blocks,
  });

  factory ArticleContent.fromJson(Map<String, dynamic> json) {
    final blocks = json['blocks'] as List<dynamic>? ?? [];
    return ArticleContent(
      type: json['type'] ?? 'structured',
      blocks: blocks
          .map((block) => ContentBlock.fromJson(block as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }

  // Helper method to extract text content from blocks
  String extractText() {
    return blocks
        .where((block) => block.type == 'paragraph' && block.content != null)
        .map((block) => block.content!)
        .join('\n\n');
  }
}

