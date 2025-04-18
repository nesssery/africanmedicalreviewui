import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Ajout pour Poppins (si non déjà présent)

class TabletNavBar extends StatefulWidget {
  @override
  _TabletNavBarState createState() => _TabletNavBarState();
}

class _TabletNavBarState extends State<TabletNavBar> {
  bool _isHovered = false; // Variable d’instance unique pour gérer l’état hover

  void _showHoverEffect(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          null, // Supprimer la couleur unie pour utiliser le dégradé
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E7D32), // Vert médical profond
              Color(0xFF1976D2), // Bleu profond (medical blue)
            ], // Dégradé bleu virant au vert médical
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4, // Ombre légère pour un effet premium
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      elevation: 4, // Conserver pour un effet flottant premium
      title: Text(
        "African Medical Review",
        style: GoogleFonts.poppins(
          fontSize: 24, // Ajusté pour une lisibilité optimale sur tablette
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 1.0,
              color: Colors.black.withValues(alpha: 0.5),
              offset: Offset(0.5, 0.5),
            ),
          ],
        ),
      ),
      leading: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _showHoverEffect(true),
        onExit: (_) => _showHoverEffect(false),
        child: IconButton(
          icon: AnimatedScale(
            scale: _isHovered ? 1.1 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Icon(
              Icons.menu,
              color: Colors.white,
              size: 30, // Conserver pour une visibilité améliorée sur tablette
              shadows: [
                Shadow(
                  blurRadius: 1.0,
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Ouvre le menu drawer
          },
        ),
      ),
    );
  }
}
