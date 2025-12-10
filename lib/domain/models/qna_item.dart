class QnAItem {
  final int id;
  final String question;
  final String answer;

  QnAItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory QnAItem.fromJson(Map<String, dynamic> json) {
    return QnAItem(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}

