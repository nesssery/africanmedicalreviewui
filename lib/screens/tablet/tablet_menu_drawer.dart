import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ajout de l’importation pour GetX (Transition et Get)
import 'package:google_fonts/google_fonts.dart'; // Ajout pour Poppins (si non déjà présent)

// Importez les pages cibles et le contrôleur
import 'package:africanmedicalreview/acount_page.dart'; // Ajustez le chemin
import 'package:africanmedicalreview/inscription_page.dart'; // Ajustez le chemin (SignupPage)
import 'package:africanmedicalreview/screens/tablet/tablet_home.dart'; // Ajustez le chemin
import 'package:africanmedicalreview/widgets/specialities_page.dart'; // Ajustez le chemin
import 'package:africanmedicalreview/controllers/auth_controller.dart'; // Ajustez le chemin

class TabletMenuDrawer extends StatefulWidget {
  @override
  _TabletMenuDrawerState createState() => _TabletMenuDrawerState();
}

class _TabletMenuDrawerState extends State<TabletMenuDrawer> {
  late AuthController
      authController; // Instance du contrôleur d’authentification
  bool _isHovered = false; // Variable d’instance unique pour gérer l’état hover

  @override
  void initState() {
    super.initState();
    authController =
        Get.find<AuthController>(); // Récupérer le contrôleur via GetX
  }

  void _showHoverEffect(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero), // Conserver sans bord arrondi
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding:
                EdgeInsets.all(20), // Conserver pour un look aéré sur tablette
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1976D2), // Bleu médical foncé
                  Color(0xFF66BB6A) // Vert émeraude
                ], // Conserver dégradé bleu virant au vert médical
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "Menu",
              style: GoogleFonts.poppins(
                fontSize: 28, // Conserver pour un impact premium sur tablette
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 1.5, // Conserver pour un contraste accru
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 12), // Conserver pour un look aéré
            child: Center(
              child: _buildDrawerButton(
                  Icons.home,
                  "Accueil",
                  () => Get.to(() => TabletHome(),
                      transition: Transition.fadeIn)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 12), // Conserver pour un look aéré
            child: Center(
              child: _buildDrawerButton(
                  Icons.article,
                  "Spécialités",
                  () => Get.to(() => SpecialitiesPage(),
                      transition: Transition.fadeIn)),
            ),
          ),
          // Ajout de la section demandée
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20), // Espacement cohérent sur tablette
            child: Obx(() {
              return authController.isLoggedIn.value
                  ? PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "compte") {
                          Get.to(() => AccountPage(),
                              transition:
                                  Transition.fadeIn); // Navigation avec Get.to
                        } else if (value == "logout") {
                          authController.logout();
                        }
                      },
                      icon: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => _showHoverEffect(true),
                        onExit: (_) => _showHoverEffect(false),
                        child: AnimatedScale(
                          scale:
                              _isHovered ? 1.15 : 1.0, // Conserver effet hover
                          duration: Duration(milliseconds: 200),
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size:
                                32, // Conserver pour une visibilité améliorée sur tablette
                            shadows: [
                              Shadow(
                                blurRadius: 1.5,
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: "compte",
                          child: Text(
                            "Mon Compte",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[800],
                              fontSize:
                                  18, // Conserver pour une lisibilité optimale sur tablette
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: "logout",
                          child: Text(
                            "Déconnexion",
                            style: GoogleFonts.poppins(
                              color: Colors.grey[800],
                              fontSize:
                                  18, // Conserver pour une lisibilité optimale sur tablette
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  : MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => _showHoverEffect(true),
                      onExit: (_) => _showHoverEffect(false),
                      child: AnimatedScale(
                        scale: _isHovered ? 1.15 : 1.0, // Conserver effet hover
                        duration: Duration(milliseconds: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => InscriptionPage(),
                                transition: Transition
                                    .fadeIn); // Navigation avec Get.to
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 16), // Conserver pour tablette
                            minimumSize: Size(240, 0), // Conserver largeur fixe
                          ),
                          child: Text(
                            "S'inscrire",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize:
                                  18, // Conserver pour une lisibilité optimale sur tablette
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerButton(IconData icon, String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _showHoverEffect(true),
      onExit: (_) => _showHoverEffect(false),
      child: GestureDetector(
        onTap: () {
          onTap(); // Exécute la navigation GetX
          Get.back(); // Ferme le drawer après la navigation
        },
        behavior:
            HitTestBehavior.opaque, // S’assurer que le widget reçoit les events
        child: Container(
          width: 240, // Forcer la largeur fixe pour couvrir tout le bouton
          height:
              52, // Forcer la hauteur fixe pour correspondre au padding et au contenu
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _isHovered
                    ? Color(0xFF155A5E)
                    : Color(0xFF1E7C7B), // Vert médical plus foncé au hover
                _isHovered
                    ? Color(0xFF26A69A)
                    : Color(0xFF4DB6AC) // Vert émeraude plus foncé au hover
              ], // Conserver dégradé vert médical plus foncé et professionnel
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8), // Conserver bords arrondis
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.05), // Ombre légère constante
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
              if (_isHovered)
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.15), // Ombre plus marquée au hover
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onTap, // Utiliser onPressed pour la navigation
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.transparent, // Fond transparent pour le dégradé
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Conserver bords arrondis
              ),
              elevation:
                  0, // Supprimer l’élévation par défaut pour éviter les conflits
              padding: EdgeInsets
                  .zero, // Supprimer le padding interne pour utiliser celui du Container
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Conserver centrage horizontal
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 28, // Conserver pour une visibilité améliorée
                ),
                SizedBox(
                    width:
                        12), // Conserver espacement entre l’icône et le texte
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize:
                        18, // Conserver pour une lisibilité optimale sur tablette
                    fontWeight:
                        FontWeight.bold, // Conserver pour un impact premium
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
