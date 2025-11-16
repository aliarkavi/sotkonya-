class Housing {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String mapUrl; // direct Google Maps link or latitude/longitude

  Housing({required this.id, required this.name, required this.description, required this.imageUrl, required this.mapUrl});

  factory Housing.fromMap(String id, Map<String, dynamic> data) => Housing(
        id: id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        mapUrl: data['mapUrl'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'mapUrl': mapUrl,
      };
}
