class Cast {
  List<Actor> actores = [];

  Cast.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    });
  }
}

class Actor {
  late String uniqueId;

  late int castId;
  late String character;
  late String creditId;
  late int gender;
  late int id;
  late String name;
  late int order;
  late int voteAverage;
  late int knownFor;
  late String profilePath;

  Actor({
    required this.uniqueId,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.gender,
    required this.id,
    required this.name,
    required this.order,
    required this.voteAverage,
    required this.knownFor,
    required this.profilePath,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId = json['cast_id'] ?? 0;;
    character = json['character'];
    creditId = json['credit_id'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
  }

  String get overview => "";

  getFoto() {
    if (profilePath == null) {
      return 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}
