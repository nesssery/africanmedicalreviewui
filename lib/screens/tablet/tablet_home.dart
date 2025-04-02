import 'package:africanmedicalreview/screens/tablet/tablet_section.dart';
import 'package:flutter/material.dart';
import 'package:africanmedicalreview/screens/tablet/tablet_navbar.dart';
import 'package:africanmedicalreview/screens/tablet/tablet_menu_drawer.dart';
import 'package:africanmedicalreview/widgets/article_section.dart';
import 'package:africanmedicalreview/widgets/footer.dart';

class TabletHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallTablet = screenWidth < 800; // Tablettes plus petites

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TabletNavBar(),
      ),
      drawer: TabletMenuDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallTablet
                ? 32.0
                : 48.0, // Marge de 32px pour les petites tablettes, 48px sinon
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
