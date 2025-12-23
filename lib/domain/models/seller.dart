class Seller {
  final String id;
  final String name;
  final String username;
  final String? avatar;
  final bool isFavorite;
  final String? badge; // e.g., "Shopee Mall", "Yêu thích", "Yêu thích+"

  Seller({
    required this.id,
    required this.name,
    required this.username,
    this.avatar,
    this.isFavorite = false,
    this.badge,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
      'isFavorite': isFavorite,
      'badge': badge,
    };
  }

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      badge: json['badge'] as String?,
    );
  }
}






