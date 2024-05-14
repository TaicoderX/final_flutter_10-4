class Achievement {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final String related;
  final int threshHold;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.related,
    required this.threshHold,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    List<String> imagesList;
    if (json['image'] is List) {
      imagesList = List<String>.from(json['image']);
    } else if (json['image'] is String) {
      imagesList = [json['image']];
    } else {
      imagesList = [];
    }

    return Achievement(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      images: imagesList,
      related: json['related'],
      threshHold: json['threshHold'],
    );
  }
}

