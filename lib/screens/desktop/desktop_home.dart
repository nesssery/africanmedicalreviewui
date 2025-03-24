import 'package:africanmedicalreview/screens/desktop/header_section.dart';
import 'package:africanmedicalreview/widgets/article_section.dart';
import 'package:africanmedicalreview/widgets/custom_scaffold.dart';
import 'package:africanmedicalreview/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/navigation_controller.dart';
import 'package:africanmedicalreview/screens/desktop/top_navbar.dart';

class DesktopHome extends StatelessWidget {
  final NavigationController navController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: TopNavBar(), // Passe TopNavBar comme appBar
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48.0), // Marge de 48 pixels
                    child: Column(
                      children: [
                        HeaderSection(), // Section avec gradient
                        ArticleSection(), // Articles scrollables
                      ],
                    ),
                  ),
                  // Le Footer est dans le flux naturel, plus besoin de Stack ou Positioned
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
