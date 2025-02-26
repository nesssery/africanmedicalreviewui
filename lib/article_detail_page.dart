import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart'; // Ajout pour Poppins (si non déjà présent)

class ArticleDetailPage extends StatefulWidget {
  final Map<String, dynamic> article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage>
    with SingleTickerProviderStateMixin {
  late AuthController authController;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false; // État hover pour le bouton PDF

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Animation d’entrée fluide
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      // Changé begin: 1.0 pour affichage immédiat
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    // Débogage pour vérifier les données initiales
    debugPrint("Article data: $widget.article");
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    bool isFreeAccess = widget.article["isFreeAccess"] ?? false;
    bool isUserLoggedIn = authController.isLoggedIn.value;
    bool isUserSubscribed = authController.isSubscribed.value;

    // Nouvelle logique : Si isFreeAccess est true, accès libre ; sinon, l'utilisateur doit être connecté ET abonné
    bool canDownloadPDF =
        isFreeAccess || (!isFreeAccess && isUserLoggedIn && isUserSubscribed);

    // Débogage supplémentaire pour vérifier la nouvelle logique
    debugPrint(
        "Permissions - FreeAccess: $isFreeAccess, LoggedIn: $isUserLoggedIn, Subscribed: $isUserSubscribed, CanDownload: $canDownloadPDF");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.article["title"] ?? "Titre non disponible",
          style: GoogleFonts.poppins(
            fontSize: 24, // Ajusté pour lisibilité
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Get.back(),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _opacityAnimation.value,
        duration: Duration(milliseconds: 500), // Animation d’entrée fluide
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16), // Réduit légèrement pour un look aéré
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Image de l'article avec gestion des erreurs
              Center(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.article["image_url"] ?? "",
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            "Image non disponible",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ✅ Titre et auteur avec gestion des erreurs
              Text(
                widget.article["title"] ?? "Titre non disponible",
                style: GoogleFonts.poppins(
                  fontSize: 24, // Ajusté pour lisibilité
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Par ${widget.article["author_name"] ?? "Auteur inconnu"} - ${widget.article["speciality_name"] ?? "Spécialité inconnue"}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),

              // ✅ Description de l'article avec gestion des erreurs
              Text(
                widget.article["articleDescription"] ??
                    "Description non disponible",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5, // Ligne plus espacée pour lisibilité
                ),
              ),
              SizedBox(height: 20),

              // ✅ Gestion de l'accès au PDF avec design premium
              Center(
                child: Column(
                  children: [
                    if (canDownloadPDF) // ✅ Affiche le bouton de téléchargement si l'accès est autorisé
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) => setState(() => _isHovered = true),
                        onExit: (_) => setState(() => _isHovered = false),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _isHovered
                                    ? Color(0xFF26A69A)
                                    : Color(
                                        0xFF4CAF50), // Vert médical clair au hover
                                _isHovered
                                    ? Color(0xFF4DB6AC)
                                    : Color(
                                        0xFF81C784), // Vert émeraude au hover
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                    alpha: _isHovered ? 0.15 : 0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _openPdf(
                                widget.article["article_file_url"] ?? ""),
                            icon:
                                Icon(Icons.picture_as_pdf, color: Colors.white),
                            label: Text("Télécharger le PDF",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                                  .shade600, // Remplacé 'primary' par 'backgroundColor'
                              elevation: 0, // Pas d’élévation par défaut
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (!isUserLoggedIn) // ❌ L'utilisateur n'est pas connecté
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red, width: 1),
                          ),
                          child: Text(
                            "⚠ Connectez-vous pour accéder au PDF",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else if (!isUserSubscribed) // ❌ L'utilisateur est connecté mais non abonné
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange, width: 1),
                          ),
                          child: Text(
                            "🔒 Abonnez-vous pour télécharger le PDF",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
