import 'package:africanmedicalreview/acount_page.dart';
import 'package:africanmedicalreview/inscription_page.dart';
import 'package:africanmedicalreview/login_page.dart';
import 'package:africanmedicalreview/submit_article_page.dart';
import 'package:africanmedicalreview/widgets/specialities_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/mobile/mobile_home.dart';
import 'screens/tablet/tablet_home.dart';
import 'screens/desktop/desktop_home.dart';
import 'widgets/responsive_widget.dart';
import 'controllers/navigation_controller.dart';
import 'controllers/auth_controller.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthController());
  Get.put(NavigationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'African Medical review',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Option 1 : Couleur unie douce (gris clair)
        scaffoldBackgroundColor: Colors.grey[100], // Gris clair user-friendly

        // Option 2 : Dégradé subtil (commentée, décommente pour utiliser)
        /*
        scaffoldBackgroundColor: Colors.transparent, // Nécessaire pour un dégradé
        // Définir un background global avec un dégradé
        // Note : Pour un dégradé, il faut envelopper chaque Scaffold dans un Container avec un decoration,
        // ou utiliser un thème personnalisé pour chaque page. Voici une solution alternative :
        */
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => ResponsiveWidget(
            mobile: MobileHome(),
            tablet: TabletHome(),
            desktop: DesktopHome(),
          ),
        ),
        GetPage(
          name: '/signup',
          page: () => InscriptionPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/login',
          page: () => LoginPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/account',
          page: () => AccountPage(),
        ),
        GetPage(
          name: '/submit-article',
          page: () => SubmitArticlePage(),
        ),
        GetPage(
          name: '/specialities',
          page: () => SpecialitiesPage(),
        ),
      ],
    );
  }
}
