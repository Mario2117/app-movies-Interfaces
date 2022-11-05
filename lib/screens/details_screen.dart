import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


import '../providers/movies_provider.dart';

class DetailsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    // TODO: Cambiar luego por una instancia de movie
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar( movie ),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle( movie ),
              _Overview( movie ),
              CastingCards( movie.id )
            ])
          )
        ],
      )
    );
  }
}


class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomAppBar( this.movie );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Color.fromARGB(255, 15, 52, 96),
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only( bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                  movie.title,
                  style: TextStyle( fontSize: 16 ),
                  textAlign: TextAlign.center,
                ),
              Text(
                  '(${movie.originalTitle})',
                  style: TextStyle( fontSize: 10 ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),

        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'), 
          image: NetworkImage( movie.fullBackdropPath ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


class _PosterAndTitle extends StatefulWidget {
  
  final Movie movie;

  const _PosterAndTitle( this.movie );
  
  @override
  State<_PosterAndTitle> createState() => _PosterAndTitleState();
}

class _PosterAndTitleState extends State<_PosterAndTitle> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only( top: 20 ),
      padding: EdgeInsets.symmetric( horizontal: 20 ),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Hero(
                tag: widget.movie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'), 
                    image: NetworkImage( widget.movie.fullPosterImg ),
                    height: 350,
                  ),
                ),
              ),
              IconButton(
                iconSize: 45,
                icon: selected?const Icon(Icons.favorite,color: Colors.redAccent,):const Icon(Icons.favorite_border,color: Colors.white,),
                onPressed: () {
                  setState(() {
                    selected = !selected;
                  });
                },
              ),
            ],
          ),
          SizedBox( width: 20 ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children:[
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: widget.movie.voteAverage<3.9?Color.fromARGB(255,171,40,0)
                          :widget.movie.voteAverage>3.9&&widget.movie.voteAverage<6.9?Color.fromARGB(255,247,250,97)
                          :widget.movie.voteAverage>6.9&&widget.movie.voteAverage<7.5?Color.fromARGB(255,159,207,105)
                          :Color.fromARGB(255,159,207,105),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color.fromARGB(255, 15, 52, 96),
                            width: 4
                          )
                        ),
                      ),
                      Text( widget.movie.voteAverage==0?'N.R.':'${widget.movie.voteAverage}', style: GoogleFonts.montserrat(fontSize: 30,fontWeight: FontWeight.bold) )
                    ] 
                  ),
                  SizedBox(height: 15,),
                  RatingBarIndicator(
                    rating: widget.movie.voteAverage/2,
                    itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 25.0,
                  )
                ],
              ),
              SizedBox(height: 35,),
              Row(
                children: [
                  _MovieInfo(widget.movie.id)
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}


class _Overview extends StatelessWidget {

  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        Text( 'Sinópsis', style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold) ),
        Container(
          padding: EdgeInsets.symmetric( horizontal: 30, vertical: 10),
          child: Text(
            movie.overview,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ],
    );
  }
}

class _MovieInfo extends StatefulWidget {

  final int movieId;

  const _MovieInfo( this.movieId );

  @override
  State<_MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<_MovieInfo> {
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("yyyy-MM-dd");
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: moviesProvider.getMovieDetails(widget.movieId),
      builder: ( _, AsyncSnapshot<MovieDetails> snapshot) {
        
        if( !snapshot.hasData ) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final MovieDetails details = snapshot.data!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            details.voteAverage==0?
            RichText(text: TextSpan(children: [
              TextSpan( text: 'Estatus:', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black)),
              TextSpan( text: ' ${details.status}', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.black))
            ])):SizedBox(),
            SizedBox(height: 5,),
            RichText(text: TextSpan(children: [
              TextSpan( text: 'Fecha de estreno:', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black)),
              TextSpan( text: ' ${DateFormat('MM-dd-yyyy').format(details.releaseDate)}', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.black))
            ])),
            SizedBox(height: 5,),
            RichText(text: TextSpan(children: [
              TextSpan( text: 'Género:', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black)),
              TextSpan( text: ' ${details.genres[0].name}', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.black))
            ])),
            SizedBox(height: 5,),
            RichText(text: TextSpan(children: [
              TextSpan( text: 'Duración:', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black)),
              TextSpan( text: ' ${details.runtime} minutos', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.black))
            ])),
            SizedBox(height: 5,),
            RichText(text: TextSpan(children: [
              TextSpan( text: 'Presupuesto:', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black)),
              TextSpan( text: ' ${NumberFormat("#,##0", "en_US").format(details.budget)}\$', style: GoogleFonts.firaSans(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.black))
            ])),
          ],
        );
      },
    );
  }
}




