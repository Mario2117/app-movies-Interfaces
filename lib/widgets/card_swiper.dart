import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:peliculas/models/models.dart';


class CardSwiper extends StatelessWidget {

  final List<Movie> movies;

  const CardSwiper({
    Key? key, 
    required this.movies
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    if( this.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.45,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height * 0.45,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.CUSTOM,
        customLayoutOption: new CustomLayoutOption(
            startIndex: -1,
            stateCount: 3
        ).addTranslate([
          new Offset(-350.0, 10.0),
          new Offset(0.0, 0.0),
          new Offset(350.0, 10.0)
        ]).addOpacity([0.6,1,0.6]
        ).addRotate([
          -10.0/180,
          0.0,
          10.0/180
        ]),
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: ( _ , int index ) {

          final movie = movies[index];

          movie.heroId = 'swiper-${ movie.id }';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage( movie.fullPosterImg ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );

        },
      ),
    );
  }
}