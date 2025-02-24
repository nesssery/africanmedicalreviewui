import 'package:africanmedicalreview/screens/desktop/header_section.dart';
import 'package:africanmedicalreview/widgets/article_section.dart';
import 'package:africanmedicalreview/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/navigation_controller.dart';
import 'package:africanmedicalreview/screens/desktop/top_navbar.dart';

class DesktopHome extends StatelessWidget {
  final NavigationController navController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopNavBar(), // ✅ Barre de navigation fixe
          Expanded(
            child: SingleChildScrollView(
              // ✅ Ajout du scroll
              child: Column(
                children: [
                  HeaderSection(), // ✅ Section avec gradient
                  ArticleSection(), // ✅ Articles scrollables
                  Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
