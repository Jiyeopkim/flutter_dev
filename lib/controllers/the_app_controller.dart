
import 'package:get/get.dart';

class TheAppController extends GetxController {
  var isDataLoading = false.obs;

  RxString title = 'lesson'.obs;  
  RxInt selectedIndex = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}
}
