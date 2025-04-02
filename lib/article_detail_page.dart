import 'dart:convert';
import 'package:africanmedicalreview/widgets/custom_scaffold.dart';
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
    debugPrint("Article data: ${widget.article}");
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

  /// ✅ Fonction corrigée pour gérer les problèmes d'encodage (SÃ©nÃ©gal -> Sénégal)
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
    bool isFreeAccess = widget.article["isFreeAccess"] ?? false;
    bool isUserLoggedIn = authController.isLoggedIn.value;
    bool isUserSubscribed = authController.isSubscribed.value;

    bool canDownloadPDF =
        isFreeAccess || (!isFreeAccess && isUserLoggedIn && isUserSubscribed);

    String correctedTitle =
        fixEncoding(widget.article["title"] ?? "Titre non disponible");
    String correctedAuthorName =
        fixEncoding(widget.article["author_name"] ?? "Auteur inconnu");
    String correctedSpecialityName =
        fixEncoding(widget.article["speciality_name"] ?? "Spécialité inconnue");
    String correctedDescription = fixEncoding(
        widget.article["articleDescription"] ?? "Description non disponible");
    String correctedAuthorsInfo = fixEncoding(
        widget.article["authorsInfo"]?.isNotEmpty == true
            ? widget.article["authorsInfo"]
            : "Informations sur les auteurs non disponibles");

    List<String> authorsList =
        correctedAuthorsInfo == "Informations sur les auteurs non disponibles"
            ? [correctedAuthorsInfo]
            : correctedAuthorsInfo
                .split(', ')
                .map((author) => author.trim())
                .toList();

    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          width: double.infinity,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 24),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        correctedTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _opacityAnimation.value,
        duration: Duration(milliseconds: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: widget.article["image_url"] != null &&
                                widget.article["image_url"]
                                    .toString()
                                    .isNotEmpty
                            ? Image.network(
                                widget.article["image_url"],
                                width: double.infinity,
                                fit: BoxFit.cover,
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
                    Text(
                      correctedTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Par $correctedAuthorName - $correctedSpecialityName",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      correctedDescription,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "INFORMATIONS SUR LES AUTEURS",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: authorsList
                          .map((author) => Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  author,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 20),
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
                                      color: Colors.black.withOpacity(
                                          _isHovered ? 0.15 : 0.05),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () => _openPdf(
                                      widget.article["article_file_url"] ?? ""),
                                  icon: Icon(Icons.picture_as_pdf,
                                      color: Colors.white),
                                  label: Text("TÉLÉCHARGER LE PDF",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16, color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
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
                                  border:
                                      Border.all(color: Colors.red, width: 1),
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
                                  border: Border.all(
                                      color: Colors.orange, width: 1),
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
          ),
        ),
      ),
    );
  }
}
