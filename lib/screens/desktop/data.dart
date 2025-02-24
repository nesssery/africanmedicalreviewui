import 'package:africanmedicalreview/widgets/specialities_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/navigation_controller.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';

class TopNavBar extends StatelessWidget {
  final NavigationController navController = Get.find();
  final AuthController authController = Get.find();

  final List<String> menuItems = [
    "Accueil",
    "Spécialités",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 70, // ✅ Augmente la hauteur pour un effet plus premium
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.purple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ✅ Logo avec une meilleure visibilité
          Text(
            "African Medical Review",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          Spacer(),

          // ✅ Menu Items avec un hover effect
          Obx(() => Row(
                children: List.generate(menuItems.length, (index) {
                  return buildMenuItem(menuItems[index], index);
                }),
              )),

          SizedBox(width: 20),

          // ✅ Icône de Recherche interactive
          InkWell(
            onTap: () {
              print("Recherche activée !");
              // ✅ Ajouter une logique pour ouvrir un champ de recherche
            },
            child: Icon(Icons.search, color: Colors.white, size: 26),
          ),
          SizedBox(width: 20),

          // ✅ Bouton dynamique : Inscription ➝ Compte
          Obx(() {
            return authController.isLoggedIn.value
                ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "compte") {
                        Get.toNamed('/account');
                      } else if (value == "logout") {
                        authController.logout();
                      }
                    },
                    icon: Icon(Icons.account_circle,
                        color: Colors.white, size: 28),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(value: "compte", child: Text("Mon Compte")),
                      PopupMenuItem(
                          value: "logout", child: Text("Déconnexion")),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  );
          }),
        ],
      ),
    );
  }

  /// 🔹 **Gestion du clic sur les éléments du menu avec effet hover**
  Widget buildMenuItem(String title, int index) {
    return MouseRegion(
      onEnter: (_) => print(
          "Hover sur $title"), // ✅ Ajoute un hover event (peut être remplacé par un effet)
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            Get.to(() => SpecialitiesPage());
          } else {
            navController.changePage(index);
          }
          authController.checkLoginStatus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: navController.selectedIndex.value == index
                  ? Colors.white
                  : Colors.white70,
              fontWeight: navController.selectedIndex.value == index
                  ? FontWeight.bold
                  : FontWeight.normal,
              decoration: navController.selectedIndex.value == index
                  ? TextDecoration.underline
                  : null, // ✅ Ajoute un soulignement sur l'élément actif
            ),
          ),
        ),
      ),
    );
  }
}
