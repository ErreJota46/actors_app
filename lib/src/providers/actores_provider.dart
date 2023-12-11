import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:actors_app/src/models/actores_model.dart';
import 'package:actors_app/src/models/pelicula_model.dart';

class ActoresProvider {
  String _apikey = 'd3337e9131ad0277148db887b307b3d8';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Actor> _populares = [];

  final _popularesStreamController = StreamController<List<Actor>>.broadcast();

  Function(List<Actor>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Actor>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Actor>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['results']);
    

    return cast.actores;
  }

  Future<List<Actor>> getEnTendencia(String string) async {
    final url = Uri.https(_url, '3/trending/person/day', {'api_key': _apikey, 'language': _language}); // Actor
    return await _procesarRespuesta(url);
  }

  Future<List<Actor>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;
    _popularesPage++;

    final url = Uri.https(_url, '3/person/popular', {'api_key': _apikey, 'language': _language, 'page': _popularesPage.toString()});  // Actor
    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Pelicula>> getCredits(String actorId) async {
    final url = Uri.https(_url, '3/person/$actorId/movie_credits3', {'api_key': _apikey, 'language': _language});  // actor
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['cast']); 

    return peliculas.items;
  }

  Future<List<Actor>> buscarActor(String query) async {
    final url = Uri.https(_url, '3/search/person', {'api_key': _apikey, 'language': _language, 'query': query});  // Actor
    
    return await _procesarRespuesta(url);
  }
}
