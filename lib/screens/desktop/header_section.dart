import 'package:flutter/material.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection>
    with SingleTickerProviderStateMixin {
  bool _isImageHovered = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 100, vertical: 50), // Conserver pour un look premium
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1976D2),
            Color(0xFFB2DFDB)
          ], // Dégradé bleu médical à vert sauge
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 📷 Image inchangée avec effet hover
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => _showImageHover(true),
            onExit: (_) => _showImageHover(false),
            child: AnimatedScale(
              scale: _isImageHovered ? 1.05 : 1.0,
              duration: Duration(milliseconds: 200),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12), // Bordures arrondies subtiles
                child: Image.network(
                  "http://158.69.52.19:8007/media/StaticImages/image-desktop-header.jpg",
                  width: 450,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 100), // Espacement accru pour un équilibre visuel

          // 📝 Texte à droite, visible immédiatement sans animation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "African Medical Review",
                  style: TextStyle(
                    fontSize: 36, // Conserver pour un impact premium
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Donec elementum odio ut suscipit congue. Fusce magna mattis vel fermentum, ultricies et velit. "
                  "Suspendisse viverra, ante in eleifend vulputate, lacus lorem pretium ligula, tincidunt posuere sapien.",
                  style: TextStyle(
                    fontSize: 24, // Augmenté pour une lisibilité accrue
                    color: Colors.white, // Maximiser le contraste
                    height: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
