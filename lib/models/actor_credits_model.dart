// To parse this JSON data, do
//
//     final actorCredits = actorCreditsFromMap(jsonString);

import 'dart:convert';

import 'package:peliculas/models/models.dart';

class ActorCredits {
    ActorCredits({
        required this.cast,
        required this.crew,
        required this.id,
    });

    List<Movie> cast;
    List<Movie> crew;
    int id;

    factory ActorCredits.fromJson(String str) => ActorCredits.fromMap(json.decode(str));

    factory ActorCredits.fromMap(Map<String, dynamic> json) => ActorCredits(
        cast: List<Movie>.from(json["cast"].map((x) => Movie.fromMap(x))),
        crew: List<Movie>.from(json["crew"].map((x) => Movie.fromMap(x))),
        id: json["id"],
    );
}
