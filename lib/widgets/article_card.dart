import 'package:africanmedicalreview/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Ajout pour optimiser les images

class ArticleCard extends StatefulWidget {
  final Map<String, dynamic> article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isHovered = false;
  bool _isButtonHovered = false;

  void _showHoverEffect(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  void _showButtonHover(bool isHovered) {
    setState(() {
      _isButtonHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _showHoverEffect(true),
      onExit: (_) => _showHoverEffect(false),
      child: GestureDetector(
        onTap: () => Get.to(() => ArticleDetailPage(article: widget.article),
            transition: Transition.fadeIn), // Animation de navigation
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: Duration(milliseconds: 200), // Conserver effet hover léger
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400, // Largeur maximale pour un affichage cohérent
              minWidth: 300, // Largeur minimale pour la responsivité
            ),
            child: Card(
              elevation: 6, // Conserver pour un effet 3D premium
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Ajuster pour une hauteur dynamique
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Répartir l’espace vertical, plaçant le bouton en bas
                children: [
                  // ✅ Image optimisée avec cached_network_image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: widget.article["image_url"] != null &&
                                widget.article["image_url"]
                                    .toString()
                                    .isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.article["image_url"],
                                width: double.infinity,
                                height:
                                    160, // Augmenté pour un équilibre visuel
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/images/placeholder.jpg",
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                "assets/images/placeholder.jpg",
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF26A69A).withValues(alpha: 0.5),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ✅ Titre et Description avec contraste amélioré et flexibilité
                  Flexible(
                    fit: FlexFit.loose, // Permettre un ajustement dynamique
                    child: Padding(
                      padding: const EdgeInsets.all(
                          16.0), // Conserver pour un look aéré
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize
                            .min, // Ajuster pour une hauteur dynamique
                        children: [
                          MouseRegion(
                            onEnter: (_) => setState(() {}),
                            onExit: (_) => setState(() {}),
                            child: AnimatedDefaultTextStyle(
                              duration: Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 22, // Conserver pour un impact visuel
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]!,
                                shadows: [
                                  Shadow(
                                    blurRadius: 1.5,
                                    color: Colors.black.withValues(alpha: 0.3),
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.article["title"] ?? "Titre inconnu",
                              ),
                            ),
                          ),
                          SizedBox(height: 12), // Conserver pour un look aéré
                          Flexible(
                            child: Text(
                              widget.article["articleDescription"] ??
                                  "Description non disponible",
                              style: TextStyle(
                                fontSize:
                                    16, // Conserver pour une lisibilité optimale
                                color: Colors.grey[500]!,
                                height:
                                    1.6, // Augmenté pour une lisibilité accrue
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Points de suspension si le texte est trop long
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ✅ Bouton "Lire plus" fixé en bas et centré, amélioré
                  Container(
                    padding: EdgeInsets.only(
                        bottom: 16), // Espacement en bas pour fixer le bouton
                    child: Center(
                      // Centrer horizontalement le bouton
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => _showButtonHover(true),
                        onExit: (_) => _showButtonHover(false),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          constraints: BoxConstraints(
                            maxWidth:
                                220, // Conserver pour un look plus spacieux
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20), // Conserver pour un look premium
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _isButtonHovered
                                    ? Color(0xFF1E7C7B)
                                    : Color(0xFF26A69A),
                                _isButtonHovered
                                    ? Color(0xFF4DB6AC)
                                    : Color(0xFF66BB6A)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                24), // Bords arrondis comme dans l’image
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius:
                                    6, // Conserver pour un effet 3D premium
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            "Lire plus",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
