import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/widgets/article_card.dart';
import 'package:google_fonts/google_fonts.dart'; // Ajout pour Poppins (si non déjà présent)

class ArticlesBySpecialityPage extends StatelessWidget {
  final Map<String, dynamic> speciality;

  const ArticlesBySpecialityPage({Key? key, required this.speciality})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Speciality data______: $speciality');
    // Sécuriser l'accès à speciality["articles"] pour gérer null ou vide
    final dynamic articlesData = speciality["articles"];
    final List<dynamic> articles = articlesData is List<dynamic>
        ? articlesData
        : []; // Gérer explicitement si ce n'est pas une liste
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          speciality["name"] ?? "Spécialité",
          style: GoogleFonts.poppins(
            fontSize: 20, // Simplifié pour lisibilité basique
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:
            null, // Supprimer la couleur unie pour utiliser le dégradé
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1976D2), // Bleu médical foncé
                Color(0xFF66BB6A) // Vert émeraude
              ], // Dégradé bleu virant au vert médical
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
        ),
        elevation: 4, // Ombre légère pour un effet premium
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: articles.isEmpty
          ? Center(
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
            )
          : Padding(
              padding: EdgeInsets.all(12), // Padding simple
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
    );
  }
}
