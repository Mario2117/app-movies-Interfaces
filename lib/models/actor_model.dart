// To parse this JSON data, do
//
//     final actorDetails = actorDetailsFromMap(jsonString);
import 'dart:convert';

class ActorDetails {
    ActorDetails({
        //required this.adult,
        required this.biography,
        required this.alsoKnownAs,
        required this.birthday,
        this.deathday,
        required this.gender,
        //required this.homepage,
        required this.id,
        required this.imdbId,
        required this.knownForDepartment,
        required this.name,
        required this.placeOfBirth,
        required this.popularity,
        required this.profilePath,
    });

    //bool adult;
    List<String> alsoKnownAs;
    String biography;
    DateTime birthday;
    DateTime? deathday;
    int gender;
    //String homepage;
    int id;
    String imdbId;
    String knownForDepartment;
    String name;
    String placeOfBirth;
    double popularity;
    String profilePath;

    get fullProfilePath {
      if ( this.profilePath != null )
        return 'https://image.tmdb.org/t/p/w500${ this.profilePath }';

      return 'https://i.stack.imgur.com/GNhxO.png';
    }

    factory ActorDetails.fromJson(String str) => ActorDetails.fromMap(json.decode(str));

    factory ActorDetails.fromMap(Map<String, dynamic> json) => ActorDetails(
        //adult: json["adult"],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
        biography: json["biography"],
        birthday: DateTime.parse(json["birthday"]),
        deathday: json["deathday"] == null ? null : DateTime.parse(json["deathday"]),
        gender: json["gender"],
        //homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"],
    );

}
