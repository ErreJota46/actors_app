import 'package:flutter/material.dart';
import 'package:actors_app/src/models/actores_model.dart';
import 'package:actors_app/src/models/pelicula_model.dart';
import 'package:actors_app/src/providers/actores_provider.dart';

class ActorDetalle extends StatelessWidget {
  final Actor actor;
  final actorProvider = new ActoresProvider();

  ActorDetalle({required this.actor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _crearAppbar(actor),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _nombreActor(context, actor),
            _descripcion(actor),
            _crearCreditos(actor),
          ]),
        )
      ],
    ));
  }

  Widget _crearAppbar(Actor actor) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          actor.name,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(
              "https://image.tmdb.org/t/p/w500" + actor.profilePath),
          //image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          //fadeInDuration: Duration(microseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _nombreActor(BuildContext context, Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: actor.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(actor.getFoto()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(actor.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Text(actor.voteAverage.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(actor.knownFor.toString(),
                        style: Theme.of(context).textTheme.bodyText1)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _descripcion(Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        actor.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCreditos(Actor actor) {
    final actorProvider = new ActoresProvider();

    return FutureBuilder(
      future: actorProvider.getEnTendencia(actor.castId.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          // Realiza la conversión de List<dynamic>? a List<Actor>
          List<Pelicula> pelicula = (snapshot.data as List<dynamic>).cast<Pelicula>();
          return _crearPeliculasPageView(pelicula);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearPeliculasPageView(List<Pelicula> pelicula) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: pelicula.length,
        itemBuilder: (context, i) => _peliculaTarjeta(pelicula[i]),
      ),
    );
  }

  Widget _peliculaTarjeta(Pelicula pelicula) {
    return Container(
        child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(pelicula.getPosterImg()),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          pelicula.uniqueId,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ));
  }
}
