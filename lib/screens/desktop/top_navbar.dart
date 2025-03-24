import 'package:africanmedicalreview/widgets/specialities_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/navigation_controller.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final NavigationController navController = Get.find();
  final AuthController authController = Get.find();

  final List<String> menuItems = [
    "Accueil",
    "Spécialités",
  ];

  // Implémentation de PreferredSizeWidget
  @override
  Size get preferredSize => Size.fromHeight(70); // Hauteur de l'AppBar

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF1976D2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.medical_services, color: Colors.white, size: 30),
                    SizedBox(width: 15),
                    Text(
                      "African Medical Review",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(menuItems.length, (index) {
                    return buildMenuItem(menuItems[index], index);
                  }),
                ),
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
                              color: Colors.white, size: 30),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: "compte",
                              child: Text(
                                "Mon Compte",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "logout",
                              child: Text(
                                "Déconnexion",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        )
                      : MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => showButtonHover(true),
                          onExit: (_) => showButtonHover(false),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/signup');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                            ),
                            child: Text(
                              "S'inscrire",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(String title, int index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => showHoverEffect(true),
      onExit: (_) => showHoverEffect(false),
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            final isSelected = navController.selectedIndex.value == index;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void showHoverEffect(bool isHovered) {
    print(isHovered ? "Hover activé" : "Hover désactivé");
  }

  void showButtonHover(bool isHovered) {
    print(isHovered ? "Hover sur bouton activé" : "Hover sur bouton désactivé");
  }
}
