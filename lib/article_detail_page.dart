import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    debugPrint("Article data: $widget.article");
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
    bool isFreeAccess = widget.article["isFreeAccess"] ?? false;
    bool isUserLoggedIn = authController.isLoggedIn.value;
    bool isUserSubscribed = authController.isSubscribed.value;

    bool canDownloadPDF =
        isFreeAccess || (!isFreeAccess && isUserLoggedIn && isUserSubscribed);

    debugPrint(
        "Permissions - FreeAccess: $isFreeAccess, LoggedIn: $isUserLoggedIn, Subscribed: $isUserSubscribed, CanDownload: $canDownloadPDF");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.article["title"] ?? "Titre non disponible",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: null,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Get.back(),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _opacityAnimation.value,
        duration: Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image responsive occupant tout l'espace disponible
              AspectRatio(
                aspectRatio: 16 / 9, // Ratio standard pour maximiser l'espace
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.article["image_url"] != null &&
                          widget.article["image_url"].toString().isNotEmpty
                      ? Image.network(
                          widget.article["image_url"],
                          width: double.infinity,
                          fit:
                              BoxFit.cover, // Remplit l'espace sans déformation
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
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
                        )
                      : Container(
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
              SizedBox(height: 20),

              // Titre et auteur
              Text(
                widget.article["title"] ?? "Titre non disponible",
                style: GoogleFonts.poppins(
                  fontSize: 24,
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

              // Description de l'article
              Text(
                widget.article["articleDescription"] ??
                    "Description non disponible",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),

              // Gestion de l'accès au PDF
              Center(
                child: Column(
                  children: [
                    if (canDownloadPDF)
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
                                    : Color(0xFF4CAF50),
                                _isHovered
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
                                    .withOpacity(_isHovered ? 0.15 : 0.05),
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
                              backgroundColor:
                                  Colors.transparent, // Pas de couleur fixe
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (!isUserLoggedIn)
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
                    else if (!isUserSubscribed)
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
