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
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFFB2DFDB)],
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
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => _showImageHover(true),
            onExit: (_) => _showImageHover(false),
            child: AnimatedScale(
              scale: _isImageHovered ? 1.05 : 1.0,
              duration: Duration(milliseconds: 200),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "http://158.69.52.19:8007/media/StaticImages/image-desktop-header.jpg",
                  width: 450,
                  height: 350,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image chargée, afficher l'image
                    }
                    return Container(
                      width: 450,
                      height: 350,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null, // Progression ou indéterminé
                          color: Colors.white, // Couleur assortie au thème
                        ),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Container(
                      width: 450,
                      height: 350,
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
          SizedBox(width: 100),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "African Medical Review",
                  style: TextStyle(
                    fontSize: 36,
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
                    fontSize: 24,
                    color: Colors.white,
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
