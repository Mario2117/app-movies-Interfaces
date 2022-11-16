
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:peliculas/helpers/debouncer.dart';

import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {

  String _apiKey   = '9aad50abb0e5a8d2b6bd496ad44b3386';
  String _baseUrl  = 'api.themoviedb.org';
  String _language = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies   = [];
  List<Movie> topRatedMovies  = [];
  List<Movie> recsMovies  = [];

  Map<int, List<Cast>> moviesCast = {};
  List<Movie> actorCredits = [];
  List<ActorImages> actorImages = [];
  List<MovieImages> actorMovies = [];
  //ActorDetails actor = ;

  List<Movie> favMovies  = [];
  List<int> favMoviesIds  = [];
  List<ActorDetails> favActors  = [];
  List<int> favActorsIds  = [];

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

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void favMovie(Movie movie) {
    favMovies.add(movie);
    favMoviesIds.add(movie.id);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void favActor(ActorDetails actor) {
    favActors.add(actor);
    favActorsIds.add(actor.id);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void removeFavMovie(Movie movie) {
    favMovies.remove(movie);
    favMoviesIds.remove(movie.id);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void removeFavActor(ActorDetails actor) {
    favActors.remove(actor);
    favActorsIds.remove(actor.id);
    print( favActors);
    print( favActorsIds);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  List<Movie> get moviesFav {return favMovies;}


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

  Future<String> _getJsonDataMovie( String endpoint ) async {
    final url = Uri.https( _baseUrl, endpoint, {
      'api_key': _apiKey
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
    
    popularMovies = [ ...popularMovies, ...popularResponse.results ];
    notifyListeners();
  }

  getTopRatedMovies() async {

    _topRatedPage++;

    final jsonData = await this._getJsonData('3/movie/top_rated', _topRatedPage );
    final topRatedResponse = PopularResponse.fromJson( jsonData );
    
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

  Future<List<Movie>> getMovieRecs( int movieId ) async {

    final jsonData = await this._getJsonData('3/movie/$movieId/recommendations');
    final recsMoviesResponse = MovieRecs.fromJson( jsonData );

    recsMovies = recsMoviesResponse.results;

    return recsMovies;
  }

  Future<MovieDetails> getMovieDetails( int movieId ) async {

    final jsonData = await this._getJsonData('3/movie/$movieId');
    final movieDetailsResponse = MovieDetails.fromJson( jsonData );

    MovieDetails movieDetail = movieDetailsResponse;

    return movieDetail;
  }

  Future<MovieProv> getMovieProv( int movieId ) async {

    final jsonData = await this._getJsonDataMovie('3/movie/$movieId/watch/providers');
    final movieDetailsResponse = MovieProv.fromJson( jsonData );

    MovieProv movieProv = movieDetailsResponse;

    return movieProv;
  }

  Future<List<Backdrop>> getMovieImages( int movieId ) async {

    final jsonData = await this._getJsonDataMovie('3/movie/$movieId/images');
    final movieImagesResponse = MovieImages.fromJson( jsonData );
    List<Backdrop> movieImages;
    movieImages = movieImagesResponse.backdrops;

    return movieImages;
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

  Future<List<Profile>> getActorImages( int actorId ) async {

    final jsonData = await this._getJsonData('3/person/$actorId/images');
    final actorImagesResponse = ActorImages.fromJson( jsonData );
    List<Profile> actorImages;
    actorImages = actorImagesResponse.profiles;

    return actorImages;
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