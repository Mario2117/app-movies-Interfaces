
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/actor_model.dart';

import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {

  String _apiKey   = '9aad50abb0e5a8d2b6bd496ad44b3386';
  String _baseUrl  = 'api.themoviedb.org';
  String _language = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies   = [];
  List<Movie> topRatedMovies  = [];

  Map<int, List<Cast>> moviesCast = {};
  //Map<String, List<Movie>> actorCredits = {};
  List<Movie> actorCredits = [];

  //ActorDetails actor = ;
  

  int _popularPage = 0;
  int _topRatedPage = 0;

  final debouncer = Debouncer(
    duration: Duration( milliseconds: 500 ),
  );

  final StreamController<List<Movie>> _suggestionStreamContoller = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamContoller.stream;



  MoviesProvider() {
    print('MoviesProvider inicializado');

    this.getOnDisplayMovies();
    this.getPopularMovies();
    this.getTopRatedMovies();
  }

  Future<String> _getJsonData( String endpoint, [int page = 1] ) async {
    final url = Uri.https( _baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }


  getOnDisplayMovies() async {
    
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    
    onDisplayMovies = nowPlayingResponse.results;
    
    notifyListeners();
  }

  getPopularMovies() async {

    _popularPage++;

    final jsonData = await this._getJsonData('3/movie/popular', _popularPage );
    final popularResponse = PopularResponse.fromJson( jsonData );
    print(popularResponse);
    
    popularMovies = [ ...popularMovies, ...popularResponse.results ];
    notifyListeners();
  }

  getTopRatedMovies() async {

    _topRatedPage++;

    final jsonData = await this._getJsonData('3/movie/top_rated', _topRatedPage );
    final topRatedResponse = PopularResponse.fromJson( jsonData );
    print(topRatedResponse);
    
    topRatedMovies = [ ...topRatedMovies, ...topRatedResponse.results ];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast( int movieId ) async {

    if( moviesCast.containsKey(movieId) ) return moviesCast[movieId]!;

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson( jsonData );

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<MovieDetails> getMovieDetails( int movieId ) async {

    final jsonData = await this._getJsonData('3/movie/$movieId');
    final movieDetailsResponse = MovieDetails.fromJson( jsonData );

    MovieDetails movieDetail = movieDetailsResponse;

    return movieDetail;
  }

  Future<ActorDetails> getActorDetails( int actorId ) async {

    final jsonData = await this._getJsonData('3/person/$actorId');
    final actorDetailsResponse = ActorDetails.fromJson( jsonData );

    ActorDetails actorDetail = actorDetailsResponse;

    return actorDetail;
  }

  Future<List<Movie>> getActorCredits( int actorId ) async {

    final jsonData = await this._getJsonData('3/person/$actorId/movie_credits');
    final actorCreditsResponse = ActorCredits.fromJson( jsonData );

    actorCredits = actorCreditsResponse.cast;

    return actorCredits;
  }

  Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );

    return searchResponse.results;
  }

  void getSuggestionsByQuery( String searchTerm ) {

    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      // print('Tenemos valor a buscar: $value');
      final results = await this.searchMovies(value);
      this._suggestionStreamContoller.add( results );
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), ( _ ) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration( milliseconds: 301)).then(( _ ) => timer.cancel());
  }


}