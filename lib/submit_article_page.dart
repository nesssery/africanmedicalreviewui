import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:africanmedicalreview/controllers/auth_controller.dart';

class SubmitArticlePage extends StatefulWidget {
  @override
  _SubmitArticlePageState createState() => _SubmitArticlePageState();
}

class _SubmitArticlePageState extends State<SubmitArticlePage> {
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

  @override
  void initState() {
    super.initState();
    fetchSpecialities();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soumettre un article"),
        backgroundColor: Colors.blue.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/account'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Choisissez une spécialité",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),

                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                        value: selectedSpeciality,
                        items: specialities.map((speciality) {
                          return DropdownMenuItem(
                            value: speciality['id'].toString(),
                            child: Text(speciality['name']),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => selectedSpeciality = value),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Sélectionnez une spécialité"),
                      ),

                SizedBox(height: 15),

                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: "Titre", border: OutlineInputBorder()),
                ),
                SizedBox(height: 15),

                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: "Description", border: OutlineInputBorder()),
                ),
                SizedBox(height: 15),

                // ✅ Boutons de sélection en ligne
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: pickFile,
                          child: Text("📄 Sélectionner un PDF"),
                        ),
                        if (selectedFileName != null)
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text("📂 $selectedFileName",
                                style: TextStyle(color: Colors.green)),
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: pickImage,
                          child: Text("🖼 Sélectionner une Image"),
                        ),
                        if (selectedImageName != null)
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text("🖼 $selectedImageName",
                                style: TextStyle(color: Colors.green)),
                          ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // ✅ Bouton Soumettre avec Loader
                Center(
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : submitArticle,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                    child: isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Soumettre",
                            style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
