// To parse this JSON data, do
//
//     final movieImages = movieImagesFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class MovieImages {
    MovieImages({
        required this.backdrops,
        required this.id,
        required this.logos,
        required this.posters,
    });

    List<Backdrop> backdrops;
    int id;
    List<Backdrop> logos;
    List<Backdrop> posters;

    factory MovieImages.fromJson(String str) => MovieImages.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory MovieImages.fromMap(Map<String, dynamic> json) => MovieImages(
        backdrops: List<Backdrop>.from(json["backdrops"].map((x) => Backdrop.fromMap(x))),
        id: json["id"],
        logos: List<Backdrop>.from(json["logos"].map((x) => Backdrop.fromMap(x))),
        posters: List<Backdrop>.from(json["posters"].map((x) => Backdrop.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "backdrops": List<dynamic>.from(backdrops.map((x) => x.toMap())),
        "id": id,
        "logos": List<dynamic>.from(logos.map((x) => x.toMap())),
        "posters": List<dynamic>.from(posters.map((x) => x.toMap())),
    };
}

class Backdrop {
    Backdrop({
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
    String iso6391;
    String filePath;
    double voteAverage;
    int voteCount;
    int width;

    get fullPosterImg {
      if ( this.filePath != null )
        return 'https://image.tmdb.org/t/p/w500${ this.filePath }';

      return 'https://i.stack.imgur.com/GNhxO.png';
    }

    factory Backdrop.fromJson(String str) => Backdrop.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Backdrop.fromMap(Map<String, dynamic> json) => Backdrop(
        aspectRatio: json["aspect_ratio"].toDouble(),
        height: json["height"],
        iso6391: json["iso_639_1"] == null ? 'null' : json["iso_639_1"],
        filePath: json["file_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        width: json["width"],
    );

    Map<String, dynamic> toMap() => {
        "aspect_ratio": aspectRatio,
        "height": height,
        "iso_639_1": iso6391 == null ? null : iso6391,
        "file_path": filePath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "width": width,
    };
}
