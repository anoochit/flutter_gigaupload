import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gigaupload/const.dart';

class AppController extends GetxController {
  Rx<User>? currentUser;

  @override
  void onInit() {
    super.onInit();
    if (auth.currentUser != null) {
      currentUser?.value = auth.currentUser!;
    }
  }
}
