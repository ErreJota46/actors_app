import 'package:flutter/material.dart';
import 'package:actors_app/src/pages/home_page.dart';
import 'package:actors_app/src/pages/actor_detalle.dart';
import 'package:actors_app/src/models/actores_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Actores TMDB',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'detalle') {
          final Actor actor = settings.arguments as Actor;
          return MaterialPageRoute(
            builder: (context) => ActorDetalle(actor: actor),
          );
        }
      },
    );
  }
}
