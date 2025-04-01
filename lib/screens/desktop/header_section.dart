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
      constraints: BoxConstraints(maxWidth: 1200), // Limite la largeur maximale
      padding:
          const EdgeInsets.symmetric(vertical: 50), // Garde le padding vertical
      // La propriété decoration est supprimée pour retirer le background
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
                  width: 550, // Augmenter la largeur de 450 à 550
                  height: 450, // Augmenter la hauteur de 350 à 450
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(
                      width:
                          550, // Ajuster la taille du conteneur de chargement
                      height: 450,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          color: Colors.black, // Ajuste la couleur du loader
                        ),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Container(
                      width: 550, // Ajuster la taille du conteneur d'erreur
                      height: 450,
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
          SizedBox(width: 50), // Réduire l'espacement de 100 à 50
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "African Medical Review : La Référence Médicale Africaine.",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Médecins, pharmaciens, infirmiers, étudiants et chercheurs y trouvent des ressources fiables et actualisées. Nous promouvons l’excellence scientifique en valorisant les travaux des experts locaux et internationaux. Explorez nos publications, soumettez vos articles et rejoignez une communauté passionnée. Accédez à des contenus exclusifs pour enrichir vos connaissances et pratiques. Ensemble, faisons avancer la santé en Afrique.",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    height: 1.5,
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
