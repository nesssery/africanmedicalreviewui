import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabletHeaderSection extends StatefulWidget {
  const TabletHeaderSection({super.key});

  @override
  _TabletHeaderSectionState createState() => _TabletHeaderSectionState();
}

class _TabletHeaderSectionState extends State<TabletHeaderSection>
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
    return Container(
      constraints: BoxConstraints(maxWidth: 1200),
      margin: EdgeInsets.only(
        top: 20, // Marge supérieure pour descendre le header
        left: 32, // Marge latérale pour tablette
        right: 32,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 16,
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
        padding: EdgeInsets.all(16),
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
                      "http://158.69.52.19:8007/media/StaticImages/image-desktop-header.jpg",
                      width: 400, // Taille adaptée pour tablette
                      height: 300,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Container(
                          width: 400,
                          height: 300,
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
                          width: 400,
                          height: 300,
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
            SizedBox(width: 30),
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
                        fontSize: 32,
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
                    SizedBox(height: 15),
                    Text(
                      "La référence médicale africaine pour médecins, pharmaciens, infirmiers, étudiants et chercheurs. Explorez des ressources fiables, soumettez vos articles et rejoignez une communauté passionnée pour faire avancer la santé en Afrique.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
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
                            Get.toNamed('/articles');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Découvrir maintenant",
                            style: TextStyle(
                              fontSize: 15,
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
