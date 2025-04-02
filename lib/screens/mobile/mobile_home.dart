import 'package:africanmedicalreview/screens/mobile/mobile_section.dart';
import 'package:flutter/material.dart';
import 'package:africanmedicalreview/screens/tablet/tablet_navbar.dart';
import 'package:africanmedicalreview/screens/tablet/tablet_menu_drawer.dart';
import 'package:africanmedicalreview/widgets/article_section.dart';
import 'package:africanmedicalreview/widgets/footer.dart';

class MobileHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isVerySmallScreen =
        screenWidth < 360; // Écrans très petits (ex. iPhone 5)

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TabletNavBar(),
      ),
      drawer: TabletMenuDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmallScreen
                ? 8.0
                : 16.0, // Marge de 8px pour les très petits écrans, 16px sinon
          ),
          child: Column(
            children: [
              ArticleSection(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
