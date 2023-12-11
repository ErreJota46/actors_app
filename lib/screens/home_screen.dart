import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:actors_app/api/api_service.dart';
import 'package:actors_app/controllers/movies_controller.dart';
import 'package:actors_app/controllers/search_controller.dart';
import 'package:actors_app/widgets/tab_builder.dart';
import 'package:actors_app/widgets/top_rated_item.dart';
import 'package:actors_app/controllers/actors_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final MoviesController controller = Get.put(MoviesController());
  final ActorsController actorController = Get.put(ActorsController());
  final SearchController1 searchController = Get.put(SearchController1());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular actors',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 34,
            ),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: actorController.popularActors.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, index) => TopRatedItem(
                            actor: actorController.popularActors[index],
                            index: index + 1),
                      ),
                    )),
            ),
            const SizedBox(
              height: 34,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending actors',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                    indicatorWeight: 4,
                    indicatorColor: Color(0xFF3A3F47),
                    tabs: [
                      Tab(text: 'Daily'),
                      Tab(text: 'Weekly'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        TabBuilder(future: ApiService.getTrendActor("day")),
                        TabBuilder(future: ApiService.getTrendActor("week")),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
