import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


import '../providers/movies_provider.dart';

class ActorDetailsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    // TODO: Cambiar luego por una instancia de movie
    final int castId = ModalRoute.of(context)!.settings.arguments as int;
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getActorDetails(castId),
      builder: ( _, AsyncSnapshot<ActorDetails> snapshot){

        if( !snapshot.hasData ) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final ActorDetails actor = snapshot.data!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _CustomAppBar( actor ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _PosterAndTitle( actor ),
                  _Overview( actor ),
                  _MovieInfo( castId )
                ])
              )
            ],
          )
        );
      }
      
    );
  }
}


class _CustomAppBar extends StatelessWidget {

  final ActorDetails actor;

  const _CustomAppBar( this.actor );

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
                  actor.name,
                  style: TextStyle( fontSize: 16 ),
                  textAlign: TextAlign.center,
                ),
              Text(
                  '(${actor.alsoKnownAs[0]})',
                  style: TextStyle( fontSize: 10 ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),

        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'), 
          image: NetworkImage( actor.fullProfilePath ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


class _PosterAndTitle extends StatefulWidget {
  
  final ActorDetails actor;

  const _PosterAndTitle( this.actor );
  
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
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage( widget.actor.fullProfilePath ),
                  height: 350,
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
              SizedBox(height: 35,),
              Row(
                children: [
                  //_MovieInfo(widget.actor.id)
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

  final ActorDetails actor;

  const _Overview(this.actor);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        Text( 'Biografía', style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold) ),
        Container(
          padding: EdgeInsets.symmetric( horizontal: 30, vertical: 10),
          child: Text(
            actor.biography,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ],
    );
  }
}

class _MovieInfo extends StatefulWidget {//maybe borrar si no aplica usar el movieSlider

  final int actorId;

  const _MovieInfo( this.actorId );

  @override
  State<_MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<_MovieInfo> {
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("yyyy-MM-dd");
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: moviesProvider.getActorCredits(widget.actorId),
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot) {
        
        if( !snapshot.hasData ) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final List<Movie> actorCredits = snapshot.data!;
        
        return MovieSlider(movies: actorCredits , onNextPage: (){},title: 'Aparece en');

      },
    );
  }
}




