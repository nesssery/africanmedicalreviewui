import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Ajout du package
import 'package:google_fonts/google_fonts.dart'; // Ajout de l’importation pour GoogleFonts
import 'package:get/get.dart'; // Ajout de GetX pour la navigation

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  bool _isHovered = false; // Variable d’instance unique pour gérer l’état hover

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1024;

    debugPrint("Footer is being built with width: $screenWidth"); // Débogage

    return Container(
      constraints: BoxConstraints(minHeight: 250), // Augmenté pour un look aéré
      padding: EdgeInsets.symmetric(
        vertical: 50, // Augmenté pour un look premium
        horizontal: isMobile
            ? 20
            : isTablet
                ? 50
                : 120, // Augmenté pour grand écran
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1976D2), // Bleu médical foncé
            Color(0xFF66BB6A) // Vert émeraude
          ], // Conserver dégradé bleu virant au vert médical
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Centré sur grand écran
        children: [
          // 📌 Logo ou titre du footer avec effet hover sur grand écran
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedScale(
              scale: !isMobile && _isHovered ? 1.05 : 1.0,
              duration: Duration(milliseconds: 200),
              child: Text(
                "African Medical Review",
                style: GoogleFonts.poppins(
                  fontSize: 26, // Augmenté pour un impact premium
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 1.5, // Augmenté pour un contraste accru
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 25), // Augmenté pour un look aéré

          // 🔗 Liens utiles & Contact
          if (isMobile) ...[
            // ✅ Affichage en colonne sur mobile
            _buildFooterLinks(),
            SizedBox(height: 25),
            _buildContactSection(),
          ] else
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centré sur grand écran
              children: [
                _buildFooterLinks(),
                SizedBox(width: 80), // Espacement accru entre liens et contact
                _buildContactSection(),
              ],
            ),

          SizedBox(height: 30), // Augmenté pour un look aéré

          // 📜 Copyright
          Divider(color: Colors.white.withValues(alpha: 0.3)),
          SizedBox(height: 15), // Augmenté pour un look aéré
          Center(
            child: Text(
              "© 2025 African Medical Review. Tous droits réservés.",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 16, // Augmenté pour une lisibilité optimale
              ),
              textAlign: TextAlign.center, // ✅ Centré sur mobile
            ),
          ),
        ],
      ),
    );
  }

  // 🔗 Liens utiles avec effet hover et navigation GetX
  Widget _buildFooterLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFooterLink("Accueil", '/'),
        _buildFooterLink("Spécialités", '/specialities'),
      ],
    );
  }

  // 📧 Contact & Réseaux sociaux avec effet hover
  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact : contact@africanmedicalreview.com",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 16, // Conserver pour lisibilité
          ),
        ),
        SizedBox(height: 15), // Conserver pour un look aéré
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centré sur grand écran
          children: [
            _buildSocialIcon(FontAwesomeIcons.facebook),
            SizedBox(width: 20), // Augmenté pour un alignement clair
            _buildSocialIcon(FontAwesomeIcons.twitter),
            SizedBox(width: 20),
            _buildSocialIcon(FontAwesomeIcons.instagram),
          ],
        ),
      ],
    );
  }

  // Fonction pour créer un lien avec effet hover et navigation GetX
  Widget _buildFooterLink(String text, String routeName) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12.0), // Augmenté pour un look aéré
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _showHoverEffect(true),
        onExit: (_) => _showHoverEffect(false),
        child: GestureDetector(
          onTap: () => Get.toNamed(routeName), // Navigation avec Get.toNamed
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: _isHovered ? Colors.grey[300]! : Colors.white,
              fontWeight: FontWeight.normal,
              decoration:
                  _isHovered ? TextDecoration.underline : TextDecoration.none,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  // Fonction pour créer une icône sociale avec effet hover
  Widget _buildSocialIcon(IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _showHoverEffect(true),
      onExit: (_) => _showHoverEffect(false),
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: Duration(milliseconds: 200),
        child: Icon(
          icon,
          color: Colors.white,
          size: 26, // Augmenté pour un impact visuel
          shadows: [
            Shadow(
              blurRadius: 1.5, // Augmenté pour un effet premium
              color: Colors.black.withValues(alpha: 0.3),
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  void _showHoverEffect(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
