import 'dart:convert';
import 'dart:typed_data';
import 'package:africanmedicalreview/widgets/custom_scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitArticlePage extends StatefulWidget {
  @override
  _SubmitArticlePageState createState() => _SubmitArticlePageState();
}

class _SubmitArticlePageState extends State<SubmitArticlePage>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();
  final TextEditingController authorsInfoController = TextEditingController();

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
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    fetchSpecialities();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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
    specialityController.dispose();
    authorsInfoController.dispose();
    super.dispose();
  }

  Future<void> fetchSpecialities() async {
    setState(() => isLoading = true);
    final String apiUrl = "http://158.69.52.19:8007/api/specialities/";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer ${authController.token.value}"},
      );

      if (response.statusCode == 200) {
        // Décoder manuellement les données brutes en UTF-8 avant de les passer à jsonDecode
        final String decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);
        setState(() {
          specialities = List<Map<String, dynamic>>.from(data["specialities"]);
          isLoading = false;
        });
      } else {
        print("❌ Erreur API (${response.statusCode}): ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (error) {
      print("❌ Problème de connexion : $error");
      setState(() => isLoading = false);
    }
  }

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

  Future<void> submitArticle() async {
    // Validation des champs obligatoires
    if (selectedSpeciality == null) {
      Get.snackbar("Erreur", "Veuillez sélectionner une spécialité médicale",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (titleController.text.isEmpty) {
      Get.snackbar("Erreur", "Veuillez entrer le titre de l'article",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (descriptionController.text.isEmpty) {
      Get.snackbar("Erreur", "Veuillez entrer le résumé de l'article",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (selectedFileBytes == null) {
      Get.snackbar("Erreur", "Veuillez sélectionner un fichier PDF",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => isSubmitting = true);

    final String apiUrl = "http://158.69.52.19:8007/api/articles/submit/";
    var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

    request.headers['Authorization'] = "Bearer ${authController.token.value}";
    request.headers['Accept'] = "application/json";

    request.fields['articleSpeciality'] = selectedSpeciality!;
    request.fields['title'] = titleController.text;
    request.fields['articleDescription'] = descriptionController.text;
    request.fields['authorsInfo'] = authorsInfoController.text;

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
        specialityController.clear();
        authorsInfoController.clear();
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

  Widget _buildButton(String text, Color baseColor, VoidCallback onPressed) {
    final isGreenOrBlue =
        baseColor == Colors.green.shade600 || baseColor == Colors.blue.shade600;
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? 350
          : MediaQuery.of(context).size.width * 0.8,
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
                      _isHovered ? Color(0xFF26A69A) : Color(0xFF4CAF50),
                      _isHovered ? Color(0xFF4DB6AC) : Color(0xFF81C784),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isGreenOrBlue ? Colors.blue.shade600 : null,
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
              backgroundColor: Colors.transparent,
              elevation: 0,
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
                      fontSize:
                          MediaQuery.of(context).size.width > 600 ? 16 : 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double paddingHorizontal = screenWidth > 600 ? 16 : 4;
    final double paddingVertical = screenWidth > 600 ? 20 : 10;

    return CustomScaffold(
      appBar: AppBar(
        title: Text(
          "Soumettre un article",
          style: GoogleFonts.poppins(
            fontSize: screenWidth > 600 ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: null,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1976D2),
                Color(0xFF66BB6A),
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
        ),
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.white, size: screenWidth > 600 ? 24 : 20),
          onPressed: () => Get.offAllNamed('/account'),
        ),
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _opacityAnimation.value,
            duration: Duration(milliseconds: 500),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingHorizontal,
                    vertical: paddingVertical,
                  ),
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 1200),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                screenWidth > 600 ? 16 : 12)),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth > 600 ? 20 : 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Soumettez votre article",
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth > 600 ? 28 : 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: screenWidth > 600 ? 15 : 10),
                              // Ajout du texte descriptif des conditions de rédaction, centré comme le formulaire
                              SizedBox(
                                width:
                                    screenWidth > 600 ? 600 : double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Conditions de rédaction pour African Medical Review",
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth > 600 ? 18 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Pour soumettre un article à *African Medical Review*, veuillez respecter les directives suivantes :",
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth > 600 ? 14 : 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "• Format de l'article : Soumettez votre article au format PDF. Assurez-vous qu'il est complet et formaté selon les normes académiques (ex. : police Times New Roman, taille 12, interligne 1.5).\n"
                                        "• Taille maximale : Le fichier PDF ne doit pas dépasser 10 Mo. L'image de couverture (JPEG ou PNG) ne doit pas dépasser 2 Mo.\n"
                                        "• Structure de l'article :\n"
                                        "  - Titre : Un titre clair et concis (max. 150 caractères).\n"
                                        "  - Résumé : Un résumé structuré (objectif, méthodes, résultats, conclusions) de 150 à 250 mots.\n"
                                        "  - Auteurs : Indiquez les noms complets, titres professionnels, et affiliations de tous les auteurs.\n"
                                        "• Spécialité médicale : Sélectionnez la spécialité correspondant à votre article (ex. : Cardiologie, Neurologie).\n"
                                        "• Image de couverture : Ajoutez une image représentative (ex. : graphique, illustration) pour illustrer votre article.\n"
                                        "• Langue : Les articles doivent être rédigés en français ou en anglais, avec une grammaire et une orthographe irréprochables.\n"
                                        "• Originalité : Les articles doivent être originaux et ne pas avoir été publiés ailleurs.\n\n"
                                        "Pour plus de détails, consultez nos directives complètes ou contactez notre équipe éditoriale.",
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth > 600 ? 14 : 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: screenWidth > 600 ? 15 : 10),
                              SizedBox(
                                width:
                                    screenWidth > 600 ? 600 : double.infinity,
                                child: isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : TypeAheadFormField<Map<String, dynamic>>(
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                          controller: specialityController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenWidth > 600
                                                          ? 12
                                                          : 10),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenWidth > 600
                                                          ? 12
                                                          : 10),
                                              borderSide: BorderSide(
                                                  color: Color(0xFF4DB6AC),
                                                  width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText:
                                                "Sélectionnez une spécialité",
                                            hintStyle: GoogleFonts.poppins(
                                              fontSize:
                                                  screenWidth > 600 ? 16 : 14,
                                              color: Colors.grey[600],
                                            ),
                                            prefixIcon: Icon(Icons.category,
                                                color: Color(0xFF4DB6AC),
                                                size: screenWidth > 600
                                                    ? 24
                                                    : 20),
                                            suffixIcon: specialityController
                                                    .text.isNotEmpty
                                                ? IconButton(
                                                    icon: Icon(Icons.clear,
                                                        color: Colors.grey),
                                                    onPressed: () {
                                                      setState(() {
                                                        specialityController
                                                            .clear();
                                                        selectedSpeciality =
                                                            null;
                                                      });
                                                    },
                                                  )
                                                : null,
                                          ),
                                          style: GoogleFonts.poppins(
                                            fontSize:
                                                screenWidth > 600 ? 16 : 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        suggestionsCallback: (pattern) {
                                          if (pattern.length < 2) {
                                            return [];
                                          }
                                          return specialities
                                              .where((speciality) =>
                                                  speciality['name']
                                                      .toLowerCase()
                                                      .contains(pattern
                                                          .toLowerCase()))
                                              .take(5)
                                              .toList();
                                        },
                                        itemBuilder: (context,
                                            Map<String, dynamic> suggestion) {
                                          return ListTile(
                                            title: Text(
                                              suggestion['name'],
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    screenWidth > 600 ? 16 : 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          );
                                        },
                                        onSuggestionSelected:
                                            (Map<String, dynamic> suggestion) {
                                          setState(() {
                                            selectedSpeciality =
                                                suggestion['id'].toString();
                                            specialityController.text =
                                                suggestion['name'];
                                          });
                                        },
                                        noItemsFoundBuilder: (context) =>
                                            Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Aucune spécialité trouvée",
                                            style: GoogleFonts.poppins(
                                              fontSize:
                                                  screenWidth > 600 ? 16 : 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        hideSuggestionsOnKeyboardHide: true,
                                        suggestionsBoxDecoration:
                                            SuggestionsBoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          elevation: 4,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: SizedBox(
                                  width:
                                      screenWidth > 600 ? 600 : double.infinity,
                                  child: Text(
                                    "Sélectionnez la spécialité médicale correspondant à votre article (ex. : Cardiologie, Neurologie).",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 12 : 10,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenWidth > 600 ? 15 : 10),
                              SizedBox(
                                width:
                                    screenWidth > 600 ? 600 : double.infinity,
                                child: TextField(
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    labelText: "Titre de l'article",
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      color: Colors.grey[600],
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth > 600 ? 12 : 10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth > 600 ? 12 : 10),
                                      borderSide: BorderSide(
                                          color: Color(0xFF4DB6AC), width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(Icons.title,
                                        color: Color(0xFF4DB6AC),
                                        size: screenWidth > 600 ? 24 : 20),
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      color: Colors.black87),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: SizedBox(
                                  width:
                                      screenWidth > 600 ? 600 : double.infinity,
                                  child: Text(
                                    "Entrez un titre clair et concis qui reflète le contenu de votre article (ex. : 'Étude sur les effets des bêta-bloquants en cardiologie').",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 12 : 10,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenWidth > 600 ? 15 : 10),
                              SizedBox(
                                width:
                                    screenWidth > 600 ? 600 : double.infinity,
                                child: TextField(
                                  controller: authorsInfoController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    labelText: "Informations sur les auteurs",
                                    hintText:
                                        "Exemple : Dr. John Doe, Hôpital XYZ",
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      color: Colors.grey[600],
                                    ),
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      color: Colors.grey[400],
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth > 600 ? 12 : 10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth > 600 ? 12 : 10),
                                      borderSide: BorderSide(
                                          color: Color(0xFF4DB6AC), width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(Icons.person,
                                        color: Color(0xFF4DB6AC),
                                        size: screenWidth > 600 ? 24 : 20),
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      color: Colors.black87),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: SizedBox(
                                  width:
                                      screenWidth > 600 ? 600 : double.infinity,
                                  child: Text(
                                    "Indiquez les noms complets, titres professionnels et affiliations des auteurs (ex. : Dr. John Doe, Cardiologue, Hôpital XYZ).",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 12 : 10,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenWidth > 600 ? 15 : 10),
                              SizedBox(
                                width:
                                    screenWidth > 600 ? 600 : double.infinity,
                                child: TextField(
                                  controller: descriptionController,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    labelText: "Résumé de l'article",
                                    hintText:
                                        "Entrez un résumé de votre article",
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      color: Colors.grey[600],
                                    ),
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      color: Colors.grey[400],
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth > 600 ? 12 : 10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth > 600 ? 12 : 10),
                                      borderSide: BorderSide(
                                          color: Color(0xFF4DB6AC), width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(Icons.description,
                                        color: Color(0xFF4DB6AC),
                                        size: screenWidth > 600 ? 24 : 20),
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      color: Colors.black87),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: SizedBox(
                                  width:
                                      screenWidth > 600 ? 600 : double.infinity,
                                  child: Text(
                                    "Fournissez un résumé structuré incluant l'objectif, les méthodes, les résultats et les conclusions (150-250 mots).",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth > 600 ? 12 : 10,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenWidth > 600 ? 15 : 10),
                              Center(
                                child: screenWidth > 600
                                    ? IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  _buildButton(
                                                      "📄 Sélectionnez votre article au format PDF",
                                                      Colors.green.shade600,
                                                      pickFile),
                                                  if (selectedFileName != null)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: screenWidth > 600
                                                              ? 5
                                                              : 3),
                                                      child: Text(
                                                        "📂 $selectedFileName",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth > 600
                                                                  ? 14
                                                                  : 12,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: SizedBox(
                                                      width: screenWidth > 600
                                                          ? 350
                                                          : screenWidth * 0.65,
                                                      child: Text(
                                                        "Téléchargez le PDF de votre article (max. 10 Mo).",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth > 600
                                                                  ? 12
                                                                  : 8,
                                                          color:
                                                              Colors.grey[600],
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 6,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                width: screenWidth > 600
                                                    ? 20
                                                    : 10),
                                            Flexible(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  _buildButton(
                                                      "🖼 Sélectionner l'image de couverture",
                                                      Colors.green.shade600,
                                                      pickImage),
                                                  if (selectedImageName != null)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: screenWidth > 600
                                                              ? 5
                                                              : 3),
                                                      child: Text(
                                                        "🖼 $selectedImageName",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth > 600
                                                                  ? 14
                                                                  : 12,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: SizedBox(
                                                      width: screenWidth > 600
                                                          ? 350
                                                          : screenWidth * 0.65,
                                                      child: Text(
                                                        "Ajoutez une image (JPEG/PNG, max. 2 Mo).",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth > 600
                                                                  ? 12
                                                                  : 8,
                                                          color:
                                                              Colors.grey[600],
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 6,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildButton(
                                              "📄 Sélectionnez votre article au format PDF",
                                              Colors.green.shade600,
                                              pickFile),
                                          if (selectedFileName != null)
                                            Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: Text(
                                                "📂 $selectedFileName",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: SizedBox(
                                              width: screenWidth * 0.65,
                                              child: Text(
                                                "Téléchargez le PDF de votre article (max. 10 Mo).",
                                                style: GoogleFonts.poppins(
                                                  fontSize: screenWidth > 600
                                                      ? 12
                                                      : 8,
                                                  color: Colors.grey[600],
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 6,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          _buildButton(
                                              "🖼 Sélectionner l'image de couverture",
                                              Colors.green.shade600,
                                              pickImage),
                                          if (selectedImageName != null)
                                            Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: Text(
                                                "🖼 $selectedImageName",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: SizedBox(
                                              width: screenWidth * 0.65,
                                              child: Text(
                                                "Ajoutez une image (JPEG/PNG, max. 2 Mo).",
                                                style: GoogleFonts.poppins(
                                                  fontSize: screenWidth > 600
                                                      ? 12
                                                      : 8,
                                                  color: Colors.grey[600],
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(height: screenWidth > 600 ? 20 : 15),
                              Center(
                                child: _buildButton("Soumettre",
                                    Colors.blue.shade600, submitArticle),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Ajout du loader global lors de la soumission
          if (isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Soumission en cours...",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
