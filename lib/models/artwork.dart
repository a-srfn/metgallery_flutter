class Artwork {
  final int id;
  final String title;
  final String imageUrl;
  final String artist;
  final String culture;

  Artwork({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.artist,
    required this.culture,
  });

  factory Artwork.fromJson(
      Map<String,dynamic> json){

    return Artwork(
      id: json["objectID"],
      title: json["title"] ?? "",
      imageUrl: json["primaryImageSmall"] ?? "",
      artist: json["artistDisplayName"] ?? "",
      culture: json["culture"] ?? "",
    );
  }
}