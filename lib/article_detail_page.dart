import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';

class ArticleDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;
  final AuthController authController;

  ArticleDetailPage({Key? key, required this.article})
      : authController =
            Get.find<AuthController>(), // ✅ Récupérer les infos utilisateur
        super(key: key);

  /// ✅ Fonction pour ouvrir le fichier PDF dans le navigateur
  void _openPdf(String url) async {
    final Uri pdfUrl = Uri.parse(url);
    if (await canLaunchUrl(pdfUrl)) {
      await launchUrl(pdfUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Erreur", "Impossible d'ouvrir le fichier PDF",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Vérification des permissions pour afficher le PDF
    bool isFreeAccess = article["isFreeAccess"] ?? false;
    bool isUserLoggedIn = authController.isLoggedIn.value;
    bool isUserSubscribed = authController.isSubscribed.value;
    bool canDownloadPDF = isFreeAccess || (isUserLoggedIn && isUserSubscribed);

    return Scaffold(
      appBar: AppBar(
        title: Text(article["title"]),
        backgroundColor: Colors.blue.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Image de l'article
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article["image_url"],
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "assets/images/placeholder.jpg",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // ✅ Titre et auteur
            Text(
              article["title"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Par ${article["author_name"]} - ${article["speciality_name"]}",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 15),

            // ✅ Description de l'article
            Text(
              article["articleDescription"],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // ✅ Gestion de l'accès au PDF
            Center(
              child: Column(
                children: [
                  if (canDownloadPDF) // ✅ Affiche le bouton de téléchargement si l'accès est autorisé
                    ElevatedButton.icon(
                      onPressed: () => _openPdf(article["article_file_url"]),
                      icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: Text("Télécharger le PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    )
                  else if (!isUserLoggedIn) // ❌ L'utilisateur n'est pas connecté
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "⚠ Connectez-vous pour accéder au PDF",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (!isUserSubscribed) // ❌ L'utilisateur est connecté mais non abonné
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "🔒 Abonnez-vous pour télécharger le PDF",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
