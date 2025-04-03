import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection>
    with SingleTickerProviderStateMixin {
  bool _isImageHovered = false;
  bool _isButtonHovered = false;
  late AnimationController _animationController;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showImageHover(bool isHovered) {
    setState(() {
      _isImageHovered = isHovered;
    });
  }

  void _showButtonHover(bool isHovered) {
    setState(() {
      _isButtonHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return Container(
      constraints: BoxConstraints(maxWidth: 1200),
      margin: EdgeInsets.only(
        top: isSmallScreen
            ? 20
            : 30, // Ajouter une marge supérieure pour descendre le header
        left: isSmallScreen ? 16 : 0,
        right: isSmallScreen ? 16 : 0,
      ),
      padding: EdgeInsets.symmetric(
        vertical:
            isSmallScreen ? 15 : 25, // Réduire légèrement le padding vertical
        horizontal: isSmallScreen ? 16 : 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2E7D32), // Vert
            Color(0xFF1976D2), // Bleu
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image avec effet de survol
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => _showImageHover(true),
              onExit: (_) => _showImageHover(false),
              child: AnimatedScale(
                scale: _isImageHovered ? 1.05 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(_isImageHovered ? 0.3 : 0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://api.africanmedicalreview.com/media/StaticImages/image-desktop-header.jpg",
                      width: isSmallScreen ? 300 : 550,
                      height: isSmallScreen ? 250 : 450,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          width: isSmallScreen ? 300 : 550,
                          height: isSmallScreen ? 250 : 450,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Container(
                          width: isSmallScreen ? 300 : 550,
                          height: isSmallScreen ? 250 : 450,
                          color: Colors.grey,
                          child: Center(
                            child: Text(
                              "Erreur de chargement",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 20 : 50),
            Expanded(
              child: FadeTransition(
                opacity: _textOpacityAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "African Medical Review",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 28 : 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Text(
                      "La référence médicale africaine pour médecins, pharmaciens, infirmiers, étudiants et chercheurs. Explorez des ressources fiables, soumettez vos articles et rejoignez une communauté passionnée pour faire avancer la santé en Afrique.",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 20,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      maxLines: isSmallScreen ? 4 : 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallScreen ? 15 : 25),
                    // Bouton d'appel à l'action
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => _showButtonHover(true),
                      onExit: (_) => _showButtonHover(false),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _isButtonHovered
                                  ? Color(0xFF26A69A)
                                  : Color(0xFF4CAF50),
                              _isButtonHovered
                                  ? Color(0xFF4DB6AC)
                                  : Color(0xFF81C784),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(_isButtonHovered ? 0.3 : 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed('/specialities');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 20 : 30,
                              vertical: isSmallScreen ? 10 : 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Découvrir maintenant",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
