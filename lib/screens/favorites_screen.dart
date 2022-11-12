import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peliculas/models/actor_model.dart';

import 'package:provider/provider.dart';

import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';


class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon( Icons.home ),
              onPressed: () => Navigator.pushNamed(context, 'home',), 
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
              child: Text( 'Mis Favoritas', style: GoogleFonts.eczar(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            // Tarjetas principales
            moviesProvider.favMovies.isEmpty
            ?Container(
                child: Center(
                  child: Icon( Icons.movie_creation_outlined, color: Colors.black38, size: 130, ),
                ),
              )
            :CardSwiper( movies: moviesProvider.favMovies ),
            moviesProvider.favActors.isEmpty
            ?Container(
                child: Center(
                  child: Icon( Icons.person_add, color: Colors.black38, size: 130, ),
                ),
              )
            :Column(
              children: [
                SizedBox(height: 5,),
                Text( 'Actores Favoritos', style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold) ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only( bottom: 30 ),
                  width: double.infinity,
                  height: 201,
                  child: ListView.builder(
                    itemCount: moviesProvider.favActors.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ( _, int index) => _ActorCard( moviesProvider.favActors[index] ),
                  ),
                ),
              ],
            ),
            // Slider de películas populares
            /* MovieSlider(
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
            ), */
            
          ],
        ),
      )
    );
  }
}

class _ActorCard extends StatelessWidget {

  final ActorDetails actor;

  const _ActorCard( this.actor );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric( horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'actorDet', arguments: actor.id ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'), 
                image: NetworkImage( actor.fullProfilePath ),
                height: 140,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox( height: 5 ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.firaSans(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)
          )

        ],
      ),
    );
  }
}