class Genre {
  final int id;
  final String name;
  final String imageBackground;

  Genre({required this.id, required this.name, required this.imageBackground});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
      imageBackground: json['image_background'] ,
    );
  }
}
