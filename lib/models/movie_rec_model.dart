// To parse this JSON data, do
//
//     final movieRecs = movieRecsFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:peliculas/models/models.dart';

class MovieRecs {
    MovieRecs({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    int page;
    List<Movie> results;
    int totalPages;
    int totalResults;

    factory MovieRecs.fromJson(String str) => MovieRecs.fromMap(json.decode(str));

    factory MovieRecs.fromMap(Map<String, dynamic> json) => MovieRecs(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

}

