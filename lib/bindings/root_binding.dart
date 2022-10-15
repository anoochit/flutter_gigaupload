import 'package:get/get.dart';
import 'package:gigaupload/controller/app_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
  }
}
