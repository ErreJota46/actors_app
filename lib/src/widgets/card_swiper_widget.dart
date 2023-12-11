import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:actors_app/src/models/actores_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Actor> actores;

  CardSwiper({required this.actores});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: CarouselSlider.builder(
        itemCount: actores.length,
        options: CarouselOptions(
          aspectRatio: 0.8,
          enlargeCenterPage: true,
        ),
        itemBuilder: (BuildContext context, int index, int realIndex) {
          actores[index].uniqueId = '${actores[index].id}-tarjeta';

          return Hero(
            tag: actores[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detalle', arguments: actores[index]),
                child: FadeInImage(
                  image: NetworkImage(actores[index].getFoto()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
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
