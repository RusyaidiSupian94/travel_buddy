class TravelService {
  final String id;
  final String name;
  final String category;
  final String description;
  final double pricePerDay;
  final String vendorId;

  const TravelService({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.pricePerDay,
    required this.vendorId,
  });

  factory TravelService.fromJson(Map<String, dynamic> json) {
    return TravelService(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unnamed service',
      category: json['category'] as String? ?? 'Guide',
      description: json['description'] as String? ?? '',
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble() ?? 0,
      vendorId: json['vendorId'] as String? ?? '',
    );
  }
}
