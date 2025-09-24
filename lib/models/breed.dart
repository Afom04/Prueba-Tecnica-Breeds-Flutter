class Breed {
  final String id;
  final String name;
  final String? group;
  final String? lifeSpan;
  final String? temperament;
  final String? origin;
  final String? imageUrl;
  final String? referenceImageId;
  final String? description;

  Breed({
    required this.id,
    required this.name,
    this.group,
    this.lifeSpan,
    this.temperament,
    this.origin,
    this.imageUrl,
    this.referenceImageId,
    this.description,
  });

  Breed copyWith(
      {String? id,
      String? name,
      String? group,
      String? lifeSpan,
      String? temperament,
      String? origin,
      String? imageUrl,
      String? referenceImageId,
      String? description}) {
    return Breed(
        id: id ?? this.id,
        name: name ?? this.name,
        group: group ?? this.group,
        lifeSpan: lifeSpan ?? this.lifeSpan,
        temperament: temperament ?? this.temperament,
        origin: origin ?? this.origin,
        imageUrl: imageUrl ?? this.imageUrl,
        referenceImageId: referenceImageId ?? this.referenceImageId,
        description: description ?? this.description);
  }

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
        id: json["id"].toString(),
        name: json["name"],
        group: json["breed_group"],
        lifeSpan: json["life_span"],
        temperament: json["temperament"],
        origin: json["origin"],
        imageUrl:
            null, // Initialized as null, will be fetched separately by ApiService
        referenceImageId: json["reference_image_id"],
        description: json["description"]);
  }
}
