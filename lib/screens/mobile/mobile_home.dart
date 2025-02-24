import 'package:flutter/material.dart';
import 'package:africanmedicalreview/screens/tablet/tablet_navbar.dart';
import 'package:africanmedicalreview/screens/tablet/tablet_menu_drawer.dart';
import 'package:africanmedicalreview/widgets/article_section.dart';
import 'package:africanmedicalreview/widgets/footer.dart';

class MobileHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // ✅ Hauteur de la navbar
        child: TabletNavBar(), // 🍔 Navbar pour tablette
      ),
      drawer: TabletMenuDrawer(), // ✅ Menu latéral caché
      body: SingleChildScrollView(
        child: Column(
          children: [
            ArticleSection(),
            Footer(),
          ],
        ),
      ),
    );
  }
}
