// To parse this JSON data, do
//
//     final actorImages = actorImagesFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class ActorImages {
    ActorImages({
        required this.id,
        required this.profiles,
    });

    int id;
    List<Profile> profiles;

    factory ActorImages.fromJson(String str) => ActorImages.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    

    factory ActorImages.fromMap(Map<String, dynamic> json) => ActorImages(
        id: json["id"],
        profiles: List<Profile>.from(json["profiles"].map((x) => Profile.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "profiles": List<dynamic>.from(profiles.map((x) => x.toMap())),
    };
}

class Profile {
    Profile({
        required this.aspectRatio,
        required this.height,
        required this.iso6391,
        required this.filePath,
        required this.voteAverage,
        required this.voteCount,
        required this.width,
    });

    double aspectRatio;
    int height;
    dynamic iso6391;
    String filePath;
    double voteAverage;
    int voteCount;
    int width;

    get fullPosterImg {
      if ( this.filePath != null )
        return 'https://image.tmdb.org/t/p/w500${ this.filePath }';

      return 'https://i.stack.imgur.com/GNhxO.png';
    }

    factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        aspectRatio: json["aspect_ratio"].toDouble(),
        height: json["height"],
        iso6391: json["iso_639_1"],
        filePath: json["file_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        width: json["width"],
    );

    Map<String, dynamic> toMap() => {
        "aspect_ratio": aspectRatio,
        "height": height,
        "iso_639_1": iso6391,
        "file_path": filePath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "width": width,
    };
}
