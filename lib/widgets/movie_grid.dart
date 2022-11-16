import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peliculas/models/models.dart';

class MovieGrid extends StatefulWidget {

  final List<Movie> movies;
  final String? title;

  const MovieGrid({
    Key? key, 
    required this.movies, 
    this.title, 
  }) : super(key: key);

  @override
  _MovieGridState createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {

  final ScrollController scrollController = new ScrollController();

  @override
  void initState() { 
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    List<Movie> movie = widget.movies.skip(1).toList();
    return Container(
      width: double.infinity,
      height: 275, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          if ( this.widget.title != null )
            Center(
              child: Text( this.widget.title!, style: GoogleFonts.spaceMono(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
              ),
              controller: scrollController,
              scrollDirection: Axis.vertical,
              itemCount: movie.length,
              itemBuilder: ( _, int index) => _MoviePoster( movie[index], '${ widget.title }-$index-${ movie[index].id }' )
            ),
          ),
        ],
      ),
    );
  }
}


class _MoviePoster extends StatelessWidget {

  
  final Movie movie;
  final String heroId;

  const _MoviePoster( this.movie, this.heroId );

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 240,
      child: Column(
        children: [

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie ),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage( movie.fullPosterImg ),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox( height: 5 ),

          Text( 
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.firaSans(),
          )

        ],
      ),
    );
  }
}