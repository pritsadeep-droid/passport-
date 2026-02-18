class KpiTemplate {
  final String id;
  final String title;
  final String description;
  final String criteria;
  final String? category;
  final bool isActive;
  final DateTime? createdAt;

  KpiTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.criteria,
    this.category,
    this.isActive = true,
    this.createdAt,
  });

  factory KpiTemplate.fromJson(Map<String, dynamic> json) {
    return KpiTemplate(
      id: (json['_id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      criteria: (json['criteria'] as String?) ?? '',
      category: json['category'] as String?,
      isActive: (json['isActive'] as bool?) ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'criteria': criteria,
      'category': category,
    };
  }
}
