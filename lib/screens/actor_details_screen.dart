import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
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
                  _MovieInfo( castId ),
                  _Gallery(castId)
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
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: moviesProvider.getActorImages(actor.id),
      builder: ( _, AsyncSnapshot<List<Profile>> snapshot) {
        
        return SliverAppBar(
          backgroundColor: Color.fromARGB(255, 15, 52, 96),
          expandedHeight: 300,
          floating: false,
          pinned: true,
          actions: [
            IconButton(
              icon: Icon( Icons.home ),
              onPressed: () => Navigator.pushNamed(context, 'home',),
            ),
          ],
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
                ],
              ),
            ),
            background: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'), 
              image: NetworkImage( snapshot.data == null?'https://static.vecteezy.com/system/resources/thumbnails/008/174/698/original/animation-loading-circle-icon-loading-gif-loading-screen-gif-loading-spinner-gif-loading-animation-loading-on-black-background-free-video.jpg'
              :snapshot.data!.length>1? snapshot.data![1].fullPosterImg
              :snapshot.data!.isEmpty? 'https://www.nailseatowncouncil.gov.uk/wp-content/uploads/blank-profile-picture-973460_1280.jpg'
              :snapshot.data![0].fullPosterImg),
              fit: BoxFit.cover,
              alignment: Alignment(0, -0.3),
            ),
          ),
        );
      },
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

    var isInFavsAct = context.select<MoviesProvider, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (favList) => favList.favActorsIds.contains(widget.actor.id),
    );

    return Container(
      margin: EdgeInsets.only( top: 20 ),
      padding: EdgeInsets.symmetric( horizontal: 20 ),
      child: Column(
        children: [
          SizedBox( height: 20 ),
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
                icon: isInFavsAct?const Icon(Icons.favorite,color: Colors.redAccent,):const Icon(Icons.favorite_border,color: Colors.white,),
                onPressed: isInFavsAct
                ?() {
                  setState(() {
                    var favsAct = context.read<MoviesProvider>();
                    favsAct.removeFavActor(widget.actor);
                  });
                }
                : () {
                  setState(() {
                    var favsAct = context.read<MoviesProvider>();
                    favsAct.favActor(widget.actor);
                  });
                },
              ),
            ],
          ),
          SizedBox( height: 5),
          Text(
            '${widget.actor.name}',
            style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold ),
            textAlign: TextAlign.center,
          ),
          SizedBox( height: 2),
          Text(
            widget.actor.deathday != null?'(${widget.actor.alsoKnownAs[0]})':'',
            style: TextStyle( fontSize: 15, fontStyle: FontStyle.italic ),
            textAlign: TextAlign.center,
          ),
          SizedBox( height: 5),
          Text(
            'Known for: ${widget.actor.knownForDepartment}',
            style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold ),
            textAlign: TextAlign.center,
          ),
          SizedBox( height: 15),
          Text(
            'Born: ${DateFormat('MMMM dd yyyy').format(widget.actor.birthday)} | ${widget.actor.placeOfBirth}',
            style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold ),
            textAlign: TextAlign.center,
          ),
          widget.actor.deathday != null? Text(
            'Died: ${DateFormat('MMMM dd yyyy').format(widget.actor.deathday!)}',
            style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold ),
            textAlign: TextAlign.center,
          ):SizedBox(),
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
    return actor.biography.length>3?Column(
      children: [
        SizedBox(height: 20,),
        Text( 'Biography', style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold) ),
        Container(
          padding: EdgeInsets.symmetric( horizontal: 30, vertical: 10),
          child: Text(
            actor.biography,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ],
    ):SizedBox();
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
        
        return MovieSlider(movies: actorCredits , onNextPage: (){},title: 'Appears on:');

      },
    );
  }
}

class _Gallery extends StatefulWidget {//maybe borrar si no aplica usar el movieSlider

  final int actorId;

  const _Gallery( this.actorId );

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: moviesProvider.getActorImages(widget.actorId),
      builder: ( _, AsyncSnapshot<List<Profile>> snapshot) {
        
        if( !snapshot.hasData ) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }

        final List<Profile> actorImages = snapshot.data!;
        final size = MediaQuery.of(context).size;
        return actorImages.isNotEmpty? Column(
          children: [
            Text( 'Gallery', style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold) ),
            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              height: 250,
              child: Swiper(
                itemCount: actorImages.length,
                layout: SwiperLayout.CUSTOM,
                customLayoutOption: new CustomLayoutOption(
                    startIndex: -1,
                    stateCount: 3
                ).addTranslate([
                  new Offset(-200.0, 10.0),
                  new Offset(0.0, 0.0),
                  new Offset(200.0, 10.0)
                ]).addOpacity([0.6,1,0.6]
                ),
                itemWidth: size.width * 0.6,
                itemHeight: size.height * 0.4,
                itemBuilder: ( _ , int index ) {

                  final image = actorImages[index];


                  return FadeInImage(
                    placeholder: AssetImage('assets/no-image.jpg'),
                    image: NetworkImage( image.fullPosterImg ),
                    fit: BoxFit.contain,
                  );

                },
              ),
            ),
            SizedBox(height: 45,),
          ],
        ):SizedBox();
      },
    );
  }
}




