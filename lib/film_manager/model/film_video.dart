class FilmVideo {
  final String id;
  final String iso_639_1;
  final String name;
  final String site;
  final String type;
  final String trailerUrl;
  final String key;
  final bool official;

  FilmVideo({
    required this.id,
    required this.iso_639_1,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
    required this.key,
    required this.trailerUrl,
  });

  const FilmVideo.empty()
      : id = "",
        iso_639_1 = "",
        name = "",
        site = "",
        type = "",
        official = false,
        trailerUrl ="",
        key = "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iso_639_1': iso_639_1,
      'name': name,
      'site': site,
      'type': type,
      'official': official,
      'trailer_url' : trailerUrl,
      'key' : key,
    };
  }

  factory FilmVideo.fromJson(Map<String, dynamic>? json) {
    return json != null
        ? FilmVideo(
            id: json['id'] as String,
            iso_639_1: json['iso_639_1'] as String,
            name: json['name'] as String,
            site: json['site'] as String,
            type: json['type'] as String,
            official: json['official'] as bool,
            key : json['key'],
            trailerUrl: "https://www.youtube.com/watch?v=${json['key']}",
          )
        : const FilmVideo.empty();
  }
}
