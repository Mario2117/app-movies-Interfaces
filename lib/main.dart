import 'package:flutter/material.dart';
import 'package:peliculas/screens/screens.dart';
import 'package:provider/provider.dart';

import 'package:peliculas/providers/movies_provider.dart';
 
void main() => runApp(AppState());


class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => MoviesProvider(), lazy: false ),
      ],
      child: MyApp(),
    );
  }
}


 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: 'home',
      routes: {
        'home':    ( _ ) => HomeScreen(),
        'details': ( _ ) => DetailsScreen(),
        'actorDet': ( _ ) => ActorDetailsScreen(),
        'favorites': ( _ ) => FavoritesScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 15, 52, 96)
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 241, 255, 	250)
      ),
    );
  }
}