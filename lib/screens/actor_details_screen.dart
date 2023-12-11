import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:actors_app/controllers/actors_controller.dart';
import 'package:actors_app/models/actor.dart';
import 'package:actors_app/widgets/movie_item.dart';

class ActorDetailsScreen extends StatelessWidget {
  final int actorId;

  const ActorDetailsScreen({Key? key, required this.actorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ActorsController actorsController = Get.find<ActorsController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() =>
            Text(actorsController.selectedActor.value?.name ?? 'Loading...')),
      ),
      body: FutureBuilder<void>(
        future: actorsController.fetchActorDetails(actorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Obx(() {
            Actor? actor = actorsController.selectedActor.value;
            if (actor == null) {
              return const Center(child: Text('Actor not found'));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: Image.network(actor.getFoto(), fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          actor.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Biography',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          actor.biography ?? 'Biography not available',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Filmography',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        actor.knownFor.isNotEmpty
                            ? SizedBox(
                                height: 350,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: actor.knownFor.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 240,
                                      margin: EdgeInsets.only(
                                        right:
                                            (index == actor.knownFor.length - 1)
                                                ? 0
                                                : 8,
                                      ),
                                      child: MovieItem(
                                        movie: actor.knownFor[index],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Text('No movies available'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
