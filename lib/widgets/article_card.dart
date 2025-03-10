import 'package:africanmedicalreview/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    // Ajuster minWidth pour les petits écrans (ex. iPhone SE)
    double minWidth = screenWidth * 0.3;
    double effectiveMinWidth = minWidth > 400
        ? 400
        : screenWidth < 400
            ? screenWidth * 0.9 // 90% de la largeur sur petits écrans
            : minWidth.clamp(300, 400);

    // Ajuster maxLines en fonction de la largeur de l'écran
    int titleMaxLines = effectiveMinWidth < 350 ? 1 : 2;
    // Réduire à 1 ligne pour la description sur petits écrans
    int descriptionMaxLines = screenWidth < 400
        ? 1
        : effectiveMinWidth < 350
            ? 2
            : 3;

    // Ajuster la taille de la police pour les petits écrans
    double titleFontSize = screenWidth < 400 ? 16 : 18;
    double descriptionFontSize = screenWidth < 400 ? 12 : 14;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _showHoverEffect(true),
        onExit: (_) => _showHoverEffect(false),
        child: GestureDetector(
          onTap: () => Get.to(
            () => ArticleDetailPage(article: widget.article),
            transition: Transition.fadeIn,
          ),
          child: AnimatedScale(
            scale: _isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 400,
                minWidth: effectiveMinWidth,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2E7D32),
                    Color(0xFF1976D2),
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
              child: Card(
                elevation: 0,
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image section with responsive height
                    AspectRatio(
                      aspectRatio: 3 / 2,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: widget.article["image_url"] != null &&
                                widget.article["image_url"]
                                    .toString()
                                    .isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: widget.article["image_url"],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/images/placeholder.jpg",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Image.asset(
                                "assets/images/placeholder.jpg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    ),

                    // Content section
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.article["title"] ?? "Titre inconnu",
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                shadows: [
                                  Shadow(
                                    blurRadius: 1.5,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              maxLines: titleMaxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                widget.article["articleDescription"] ??
                                    "Description non disponible",
                                style: TextStyle(
                                  fontSize: descriptionFontSize,
                                  color: Colors.grey[500],
                                  height: 1.5,
                                ),
                                maxLines:
                                    descriptionMaxLines, // 1 ligne sur petits écrans
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Button section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                      child: Center(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => _showButtonHover(true),
                          onExit: (_) => _showButtonHover(false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            constraints: const BoxConstraints(maxWidth: 180),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _isButtonHovered
                                      ? const Color(0xFF1E7C7B)
                                      : const Color(0xFF26A69A),
                                  _isButtonHovered
                                      ? const Color(0xFF4DB6AC)
                                      : const Color(0xFF66BB6A),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              "Lire plus",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
      ),
    );
  }
}
