import 'package:bayer/costante/export.dart';

class MenuController extends GetxController {
  var menuIndex = 0.obs;
  var currentIndex = 0;
  void onChange() {
    menuIndex.value = currentIndex;
  }
}
