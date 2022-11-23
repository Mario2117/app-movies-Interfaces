// To parse this JSON data, do
//
//     final movieProv = movieProvFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class MovieProv {
    MovieProv({
        required this.id,
        required this.results,
    });

    int id;
    Results results;

    factory MovieProv.fromJson(String str) => MovieProv.fromMap(json.decode(str));


    factory MovieProv.fromMap(Map<String, dynamic> json) => MovieProv(
        id: json["id"],
        results: Results.fromMap(json["results"]),
    );

}

class Results {
    Results({
        required this.us,
    });

    
    Ae? us;

    factory Results.fromJson(String str) => Results.fromMap(json.decode(str));


    factory Results.fromMap(Map<String, dynamic> json) => Results(
        
        us: json["US"]== null ? null: Ae.fromMap(json["US"]),
    );

}


class Flatrate {
    Flatrate({
        required this.logoPath,
        required this.providerId,
        required this.providerName,
        required this.displayPriority,
    });

    String logoPath;
    int providerId;
    String providerName;
    int displayPriority;

    get fullPosterImg {
      if ( this.logoPath != null )
        return 'https://image.tmdb.org/t/p/w500${ this.logoPath }';

      return 'https://i.stack.imgur.com/GNhxO.png';
    }

    factory Flatrate.fromJson(String str) => Flatrate.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Flatrate.fromMap(Map<String, dynamic> json) => Flatrate(
        logoPath: json["logo_path"],
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        displayPriority: json["display_priority"],
    );

    Map<String, dynamic> toMap() => {
        "logo_path": logoPath,
        "provider_id": providerId,
        "provider_name": providerName,
        "display_priority": displayPriority,
    };
}

class Ae {
    Ae({
        required this.buy,
        required this.link,
        required this.flatrate,
        required this.rent,
        required this.free,
        required this.ads,
    });

    String link;
    List<Flatrate>? buy;
    List<Flatrate>? flatrate;
    List<Flatrate>? rent;
    List<Flatrate>? free;
    List<Flatrate>? ads;

    factory Ae.fromJson(String str) => Ae.fromMap(json.decode(str));

    factory Ae.fromMap(Map<String, dynamic> json) => Ae(
        link: json["link"] == null ? null : json["link"],
        buy: json["buy"] == null ? null : List<Flatrate>.from(json["buy"].map((x) => Flatrate.fromMap(x))),
        flatrate: json["flatrate"] == null ? null : List<Flatrate>.from(json["flatrate"].map((x) => Flatrate.fromMap(x))),
        rent: json["rent"] == null ? null : List<Flatrate>.from(json["rent"].map((x) => Flatrate.fromMap(x))),
        free: json["free"] == null ? null : List<Flatrate>.from(json["free"].map((x) => Flatrate.fromMap(x))),
        ads: json["ads"] == null ? null : List<Flatrate>.from(json["ads"].map((x) => Flatrate.fromMap(x))),
    );

}
