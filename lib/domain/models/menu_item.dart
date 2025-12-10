class MenuItem {
  final String key;
  final String title;
  final List<String>? services;
  final Map<String, List<String>>? categorizedServices;

  MenuItem({
    required this.key,
    required this.title,
    this.services,
    this.categorizedServices,
  });

  // Get all services as a flat list
  List<String> getAllServices() {
    if (services != null) {
      return services!;
    }
    if (categorizedServices != null) {
      final allServices = <String>[];
      categorizedServices!.values.forEach((list) {
        allServices.addAll(list);
      });
      return allServices;
    }
    return [];
  }

  // Check if has categories
  bool get hasCategories => categorizedServices != null && categorizedServices!.isNotEmpty;
}

