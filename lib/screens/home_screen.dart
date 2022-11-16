import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon( Icons.favorite_rounded),
            onPressed: () => Navigator.pushNamed(context, 'favorites',), 
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon( Icons.search_outlined ),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate() ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text( 'En cartelera', style: GoogleFonts.eczar(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            // Tarjetas principales
            CardSwiper( movies: moviesProvider.onDisplayMovies ),

            // Slider de películas populares
            MovieSlider(
              movies: moviesProvider.popularMovies,// populares,
              title: 'Populares', // opcional
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
            SizedBox(height: 10,),
            // Slider de películas populares
            MovieSlider(
              movies: moviesProvider.topRatedMovies,// populares,
              title: 'Mejores Calificadas', // opcional
              onNextPage: () => moviesProvider.getTopRatedMovies(),
            ),
            
          ],
        ),
      )
    );
  }
}