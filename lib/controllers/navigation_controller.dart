import 'package:africanmedicalreview/screens/category_page.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  final screens = [
    CategoryPage(),
  ];

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
