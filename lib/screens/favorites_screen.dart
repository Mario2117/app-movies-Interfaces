import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peliculas/models/actor_model.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

import 'package:provider/provider.dart';

import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';


class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = new ScrollController();
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon( Icons.home ),
              onPressed: () => Navigator.pushNamed(context, 'home',), 
        ),
        elevation: 0,
        actions: [
          MaterialButton(
                onPressed: () {
                  ArtSweetAlert.show(
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                      type: ArtSweetAlertType.question,
                      title: "Add to your favorites!",
                      text: "Add your favorite films and actors by clicking on the heart at their profile.",
                      /* decorationImage: DecorationImage(
                        image: NetworkImage( 'https://myhero.com/content/images/thumbs/0147520.jpeg?t=1648656270418'),
                        fit: BoxFit.cover,
                      ) */
                    )
                  );
                },
                child: Icon( Icons.help, color: Colors.white, size: 25, ),
              ),
          IconButton(
            icon: Icon( Icons.search_outlined ),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate() ),
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Center(
                child: Text( 'Favorites', style: GoogleFonts.eczar(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              // Tarjetas principales
              moviesProvider.favMovies.isEmpty
              ?Container(
                  child: Center(
                    child: Column(
                      children: [Icon( Icons.movie_creation_outlined, color: Colors.black38, size: 130, ),
                      
                      //Text( 'Add your favorite films and actors by clicking on the heart at their profile.', textAlign: TextAlign.center, style: GoogleFonts.eczar(fontSize: 28)),
                      //Icon( Icons.favorite, color: Colors.red, size: 30, ),
                      ]
                    ),
                  ),
                )
              :Container(
                width: size.width*0.7,
                height: size.height * 0.42,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'details', arguments: moviesProvider.favMovies[0]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/no-image.jpg'),
                      image: NetworkImage( moviesProvider.favMovies[0].fullPosterImg ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              moviesProvider.favMovies.isEmpty
              ?SizedBox()
              :MovieGrid(movies: moviesProvider.favMovies),
            ],
          ),
          moviesProvider.favActors.isEmpty
          ?Container(
            child: Column(
              children: [
                SizedBox(height: 5,),
                Text( 'Favorite Actors', style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold) ),
                //SizedBox(height: 10,),
                Container(
                    child: Center(
                      child: Icon( Icons.person_add, color: Colors.black38, size: 130, ),
                    ),
                  ),
              ],
            ),
          )
          :Container(
            /* constraints: BoxConstraints(
              maxHeight: size.height*0.35
            ), */
            child: Column(
              children: [
                Text( 'Favorite Actors', style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold) ),
                SizedBox(height: 5,),
                Container(
                  width: double.infinity,
                  height: 170,
                  child: ListView.builder(
                    itemCount: moviesProvider.favActors.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ( _, int index) => _ActorCard( moviesProvider.favActors[index] ),
                  ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}

class _ActorCard extends StatelessWidget {

  final ActorDetails actor;

  const _ActorCard( this.actor );

  @override
  Widget build(BuildContext context) {
    print(actor.name);
    print(actor.id);
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