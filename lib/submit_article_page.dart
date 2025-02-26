import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart'; // Ajout pour Poppins (si non déjà présent)

class SubmitArticlePage extends StatefulWidget {
  @override
  _SubmitArticlePageState createState() => _SubmitArticlePageState();
}

class _SubmitArticlePageState extends State<SubmitArticlePage>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> specialities = [];
  String? selectedSpeciality;
  Uint8List? selectedFileBytes;
  Uint8List? selectedImageBytes;
  String? selectedFileName;
  String? selectedImageName;
  bool isLoading = false;
  bool isSubmitting = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false; // État hover pour les boutons

  @override
  void initState() {
    super.initState();
    fetchSpecialities();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Animation d’entrée fluide
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  /// ✅ Récupérer les spécialités depuis l'API
  Future<void> fetchSpecialities() async {
    setState(() => isLoading = true);
    final String apiUrl = "http://127.0.0.1:8000/api/specialities/";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer ${authController.token.value}"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          specialities = List<Map<String, dynamic>>.from(data["specialities"]);
          isLoading = false;
        });
      } else {
        print("❌ Erreur API (${response.statusCode}): ${response.body}");
      }
    } catch (error) {
      print("❌ Problème de connexion : $error");
    }
  }

  /// ✅ Sélectionner un fichier PDF
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedFileBytes = result.files.single.bytes;
        selectedFileName = result.files.single.name;
      });
    }
  }

  /// ✅ Sélectionner une image
  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        selectedImageBytes = result.files.single.bytes;
        selectedImageName = result.files.single.name;
      });
    }
  }

  /// ✅ Soumettre l'article avec un Loader
  Future<void> submitArticle() async {
    if (selectedSpeciality == null ||
        titleController.text.isEmpty ||
        selectedFileBytes == null) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => isSubmitting = true);

    final String apiUrl = "http://127.0.0.1:8000/api/articles/submit/";
    var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

    request.headers['Authorization'] = "Bearer ${authController.token.value}";
    request.headers['Accept'] = "application/json";

    request.fields['articleSpeciality'] = selectedSpeciality!;
    request.fields['title'] = titleController.text;
    request.fields['articleDescription'] = descriptionController.text;

    if (selectedFileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'articleFile',
        selectedFileBytes!,
        filename: selectedFileName!,
      ));
    }

    if (selectedImageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        selectedImageBytes!,
        filename: selectedImageName!,
      ));
    }

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        Get.snackbar("Succès", "Article soumis avec succès !",
            backgroundColor: Colors.green, colorText: Colors.white);
        titleController.clear();
        descriptionController.clear();
        setState(() {
          selectedSpeciality = null;
          selectedFileBytes = null;
          selectedFileName = null;
          selectedImageBytes = null;
          selectedImageName = null;
        });
      } else {
        print("❌ Erreur API (${response.statusCode}): $responseData");
        Get.snackbar("Erreur", "Échec de la soumission",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      print("❌ Exception: $error");
      Get.snackbar("Erreur", "Problème de connexion au serveur",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  /// ✅ Widget pour un bouton avec un gradient ou couleur
  Widget _buildButton(String text, Color baseColor, VoidCallback onPressed) {
    final isGreenOrBlue =
        baseColor == Colors.green.shade600 || baseColor == Colors.blue.shade600;
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? 350
          : MediaQuery.of(context).size.width * 0.8, // Réduit pour mobile
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: isGreenOrBlue
                ? LinearGradient(
                    colors: [
                      _isHovered
                          ? Color(0xFF26A69A)
                          : Color(0xFF4CAF50), // Vert médical clair au hover
                      _isHovered
                          ? Color(0xFF4DB6AC)
                          : Color(0xFF81C784), // Vert émeraude au hover
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isGreenOrBlue
                ? Colors.blue.shade600
                : null, // Bleu pour "Soumettre"
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors
                  .transparent, // Fond transparent pour le dégradé/couleur
              elevation: 0, // Pas d’élévation par défaut
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isSubmitting && text == "Soumettre"
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width > 600
                          ? 16
                          : 14, // Réduit sur mobile
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingHorizontal =
        screenWidth > 600 ? 16 : 10; // Réduit padding sur mobile
    final double paddingVertical =
        screenWidth > 600 ? 20 : 10; // Réduit padding sur mobile

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Soumettre un article",
          style: GoogleFonts.poppins(
            fontSize: screenWidth > 600 ? 24 : 20, // Réduit sur mobile
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
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.white,
              size: screenWidth > 600 ? 24 : 20), // Réduit sur mobile
          onPressed: () => Get.offAllNamed('/account'),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _opacityAnimation.value,
        duration: Duration(milliseconds: 500), // Animation d’entrée fluide
        child: Center(
          // Centré verticalement et horizontalement
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: paddingVertical), // Ajusté dynamiquement
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      screenWidth > 600 ? 16 : 12)), // Réduit sur mobile
              child: Padding(
                padding: EdgeInsets.all(
                    screenWidth > 600 ? 20 : 12), // Réduit sur mobile
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Limite la hauteur pour centrer
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centré horizontalement
                  children: [
                    Text(
                      "Soumettre un article",
                      style: GoogleFonts.poppins(
                        fontSize:
                            screenWidth > 600 ? 28 : 22, // Réduit sur mobile
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                        height:
                            screenWidth > 600 ? 30 : 15), // Réduit sur mobile

                    Text("Choisissez une spécialité",
                        style: GoogleFonts.poppins(
                          fontSize:
                              screenWidth > 600 ? 18 : 16, // Réduit sur mobile
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        )),
                    SizedBox(
                        height:
                            screenWidth > 600 ? 10 : 8), // Réduit sur mobile

                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                            value: selectedSpeciality,
                            items: specialities.map((speciality) {
                              return DropdownMenuItem(
                                value: speciality['id'].toString(),
                                child: Text(
                                  speciality['name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth > 600
                                        ? 16
                                        : 14, // Réduit sur mobile
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => selectedSpeciality = value),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    screenWidth > 600
                                        ? 12
                                        : 10), // Réduit sur mobile
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    screenWidth > 600
                                        ? 12
                                        : 10), // Réduit sur mobile
                                borderSide: BorderSide(
                                    color: Color(0xFF4DB6AC), width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Sélectionnez une spécialité",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: screenWidth > 600
                                    ? 16
                                    : 14, // Réduit sur mobile
                                color: Colors.grey[600],
                              ),
                              prefixIcon: Icon(Icons.category,
                                  color: Color(0xFF4DB6AC),
                                  size: screenWidth > 600
                                      ? 24
                                      : 20), // Réduit sur mobile
                            ),
                          ),

                    SizedBox(
                        height:
                            screenWidth > 600 ? 15 : 10), // Réduit sur mobile

                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Titre",
                        labelStyle: GoogleFonts.poppins(
                          fontSize:
                              screenWidth > 600 ? 16 : 14, // Réduit sur mobile
                          color: Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              screenWidth > 600 ? 12 : 10), // Réduit sur mobile
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              screenWidth > 600 ? 12 : 10), // Réduit sur mobile
                          borderSide:
                              BorderSide(color: Color(0xFF4DB6AC), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.title,
                            color: Color(0xFF4DB6AC),
                            size: screenWidth > 600
                                ? 24
                                : 20), // Réduit sur mobile
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth > 600 ? 16 : 14,
                          color: Colors.black87), // Réduit sur mobile
                    ),
                    SizedBox(
                        height:
                            screenWidth > 600 ? 15 : 10), // Réduit sur mobile

                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: GoogleFonts.poppins(
                          fontSize:
                              screenWidth > 600 ? 16 : 14, // Réduit sur mobile
                          color: Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              screenWidth > 600 ? 12 : 10), // Réduit sur mobile
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              screenWidth > 600 ? 12 : 10), // Réduit sur mobile
                          borderSide:
                              BorderSide(color: Color(0xFF4DB6AC), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.description,
                            color: Color(0xFF4DB6AC),
                            size: screenWidth > 600
                                ? 24
                                : 20), // Réduit sur mobile
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth > 600 ? 16 : 14,
                          color: Colors.black87), // Réduit sur mobile
                    ),
                    SizedBox(
                        height:
                            screenWidth > 600 ? 15 : 10), // Réduit sur mobile

                    // ✅ Boutons de sélection en ligne/colonnes, centrés
                    Center(
                      child: screenWidth > 600
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildButton("📄 Sélectionner un PDF",
                                        Colors.green.shade600, pickFile),
                                    if (selectedFileName != null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: screenWidth > 600
                                                ? 5
                                                : 3), // Réduit sur mobile
                                        child: Text(
                                          "📂 $selectedFileName",
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth > 600
                                                ? 14
                                                : 12, // Réduit sur mobile
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(
                                    width: screenWidth > 600
                                        ? 20
                                        : 10), // Réduit sur mobile
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildButton("🖼 Sélectionner une Image",
                                        Colors.green.shade600, pickImage),
                                    if (selectedImageName != null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: screenWidth > 600
                                                ? 5
                                                : 3), // Réduit sur mobile
                                        child: Text(
                                          "🖼 $selectedImageName",
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth > 600
                                                ? 14
                                                : 12, // Réduit sur mobile
                                            color: Colors.green,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildButton("📄 Sélectionner un PDF",
                                    Colors.green.shade600, pickFile),
                                if (selectedFileName != null)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3), // Réduit sur mobile
                                    child: Text(
                                      "📂 $selectedFileName",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12, // Réduit sur mobile
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 10), // Espacement sur mobile
                                _buildButton("🖼 Sélectionner une Image",
                                    Colors.green.shade600, pickImage),
                                if (selectedImageName != null)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3), // Réduit sur mobile
                                    child: Text(
                                      "🖼 $selectedImageName",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12, // Réduit sur mobile
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),

                    SizedBox(
                        height:
                            screenWidth > 600 ? 20 : 15), // Réduit sur mobile

                    // ✅ Bouton Soumettre avec Loader, centré
                    Center(
                      child: _buildButton(
                          "Soumettre", Colors.blue.shade600, submitArticle),
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
