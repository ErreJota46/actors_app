import 'package:get/get.dart';
import 'package:actors_app/api/api_service.dart';
import 'package:actors_app/models/actor.dart';

class ActorsController extends GetxController {
  var isLoading = false.obs;
  var popularActors = <Actor>[].obs;
  var selectedActor = Rxn<Actor>();

  @override
  void onInit() async {
    super.onInit();
    await fetchPopularActors();
  }

  Future<void> fetchPopularActors() async {
    isLoading.value = true;
    var actors = await ApiService.getPopularActors();
    if (actors != null) {
      popularActors.value = actors;
    }
    isLoading.value = false;
  }

  Future<void> fetchActorDetails(int actorId) async {
    isLoading.value = true;
    var actorDetails = await ApiService.getActorDetails(actorId);
    if (actorDetails != null) {
      selectedActor.value = actorDetails;
    }
    isLoading.value = false;
  }
}
