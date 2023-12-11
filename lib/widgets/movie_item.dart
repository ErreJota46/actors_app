import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:actors_app/api/api.dart';
import 'package:actors_app/models/movie.dart';
import 'package:actors_app/screens/details_screen.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth * 0.4;
    double imageHeight = itemWidth * (250 / 180);

    return GestureDetector(
      onTap: () => Get.to(
        DetailsScreen(movie: movie),
      ),
      child: Container(
        width: itemWidth,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                Api.imageBaseUrl + movie.posterPath,
                fit: BoxFit.cover,
                height: imageHeight,
                width: itemWidth,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.broken_image,
                  size: itemWidth,
                ),
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return FadeShimmer(
                    width: itemWidth,
                    height: imageHeight,
                    highlightColor: const Color(0xff22272f),
                    baseColor: const Color(0xff20252d),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                movie.title,
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
