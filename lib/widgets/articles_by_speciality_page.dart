import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/widgets/article_card.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticlesBySpecialityPage extends StatelessWidget {
  final Map<String, dynamic> speciality;

  const ArticlesBySpecialityPage({Key? key, required this.speciality})
      : super(key: key);

  // Fonction pour corriger les caractères mal encodés (version de ChatGPT)
  String fixEncoding(String text) {
    try {
      List<int> bytes = latin1.encode(text);
      return utf8.decode(bytes);
    } catch (e) {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Speciality data______: $speciality');
    // Sécuriser l'accès à speciality["articles"] pour gérer null ou vide
    final dynamic articlesData = speciality["articles"];
    final List<dynamic> articles = articlesData is List<dynamic>
        ? articlesData
        : []; // Gérer explicitement si ce n'est pas une liste
    final double screenWidth = MediaQuery.of(context).size.width;

    // Corriger les accents dans le nom de la spécialité
    String correctedSpecialityName =
        fixEncoding(speciality["name"] ?? "Spécialité");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70), // Hauteur de l'AppBar
        child: Container(
          width: double
              .infinity, // S'assure que le background s'étend sur toute la largeur
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1976D2), // Bleu médical foncé
                Color(0xFF66BB6A), // Vert émeraude
              ],
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 48.0), // Même marge que ArticleSection
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: 1200), // Limite la largeur du contenu
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Répartit les éléments
                  children: [
                    // Icône de retour
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 20),
                      onPressed: () => Get.back(),
                    ),
                    // Titre
                    Expanded(
                      child: Text(
                        correctedSpecialityName, // Utiliser le nom corrigé
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center, // Centre le titre
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Espace vide pour équilibrer (car il n'y a pas de bouton à droite)
                    SizedBox(
                        width: 48), // Compense la largeur de l'icône de retour
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: articles.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 48.0), // Même marge que ArticleSection
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: 1200), // Limite la largeur du contenu
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.medical_services,
                          color: Colors.green, size: 40), // Icône simple
                      SizedBox(height: 10), // Espacement simple
                      Text(
                        "Aucun article disponible pour cette spécialité",
                        style: GoogleFonts.poppins(
                          fontSize: 16, // Texte simple et lisible
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 48.0), // Même marge que ArticleSection
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: 1200), // Limite la largeur du contenu
                  padding: EdgeInsets.all(12), // Espacement interne
                  child: GridView.builder(
                    itemCount: articles.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600
                          ? 1 // Mobile : 1 colonne
                          : screenWidth < 1024
                              ? 2 // Tablette : 2 colonnes
                              : 3, // Bureau : 3 colonnes
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8, // Ajusté pour un affichage simple
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> article =
                          articles[index] as Map<String, dynamic>;
                      return ArticleCard(
                        article: article, // Passe l'article entier
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
