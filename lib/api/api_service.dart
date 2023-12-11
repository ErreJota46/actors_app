import 'dart:convert';
import 'package:actors_app/api/api.dart';
import 'package:actors_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:actors_app/models/review.dart';
import 'package:actors_app/api/api_end_points.dart';
import 'package:actors_app/models/actor.dart';

class ApiService {
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en_US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=YourApiKey&language=en_US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en_US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>?> getTrendActor(String period) async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.trendingActors}/$period?api_key=${Api.apiKey}&language=en_US'));
      var res = jsonDecode(response.body);
      if (res['results'] != null) {
        res['results'].forEach(
          (a) => actors.add(
            Actor.fromMap(a),
          ),
        );
      }
      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>?> getPopularActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.popularActors}?api_key=${Api.apiKey}&language=en_US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (a) => actors.add(Actor.fromMap(a)),
      );

      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<Actor?> getActorDetails(int actorId) async {
    try {
      http.Response detailsResponse = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.actorDetails}$actorId?api_key=${Api.apiKey}&language=en_US'));
      var detailsData = jsonDecode(detailsResponse.body);

      http.Response filmographyResponse = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.actorMovieCredits.replaceFirst('{actor_id}', actorId.toString())}?api_key=${Api.apiKey}&language=en_US'));
      var filmographyData = jsonDecode(filmographyResponse.body);

      detailsData['known_for'] = filmographyData['cast'] ?? [];

      return Actor.fromMap(detailsData);
    } catch (e) {
      return null;
    }
  }

  static Future<List<Actor>?> getSearchedActors(String query) async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/person?api_key=${Api.apiKey}&language=en_US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (a) => actors.add(
          Actor.fromMap(a),
        ),
      );
      return actors;
    } catch (e) {
      return null;
    }
  }
}
