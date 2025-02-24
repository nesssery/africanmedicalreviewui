import 'dart:convert';
import 'package:africanmedicalreview/widgets/articles_by_speciality_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:africanmedicalreview/controllers/auth_controller.dart';

class SpecialitiesPage extends StatefulWidget {
  @override
  _SpecialitiesPageState createState() => _SpecialitiesPageState();
}

class _SpecialitiesPageState extends State<SpecialitiesPage> {
  final AuthController authController = Get.find();
  List<Map<String, dynamic>> specialities = [];
  List<Map<String, dynamic>> filteredSpecialities = []; // ✅ Liste filtrée
  bool isLoading = true;
  final TextEditingController searchController =
      TextEditingController(); // ✅ Contrôleur du champ de recherche

  @override
  void initState() {
    super.initState();
    fetchSpecialities();
  }

  /// 🔹 Récupération des spécialités depuis l'API
  Future<void> fetchSpecialities() async {
    final String apiUrl = "http://127.0.0.1:8000/api/specialities/articles/";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          specialities = List<Map<String, dynamic>>.from(data);
          filteredSpecialities = specialities; // ✅ Initialisation des filtres
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

  /// 🔍 Filtre les spécialités en fonction du texte saisi
  void filterSpecialities(String query) {
    setState(() {
      filteredSpecialities = specialities
          .where((speciality) =>
              speciality["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spécialités"),
        backgroundColor: Colors.blue.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // ✅ Loader
          : Column(
              children: [
                // ✅ Champ de recherche
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterSpecialities, // ✅ Met à jour la liste
                    decoration: InputDecoration(
                      hintText: "Rechercher une spécialité...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                // ✅ Liste des spécialités filtrées
                Expanded(
                  child: filteredSpecialities.isEmpty
                      ? Center(child: Text("Aucune spécialité trouvée"))
                      : ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: filteredSpecialities.length,
                          itemBuilder: (context, index) {
                            final speciality = filteredSpecialities[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 10),
                              elevation: 3,
                              child: ListTile(
                                leading: Icon(Icons.medical_services,
                                    color: Colors.blue),
                                title: Text(speciality["name"]),
                                subtitle: Text(speciality["description"] ?? ""),
                                onTap: () {
                                  Get.to(() => ArticlesBySpecialityPage(
                                      speciality: speciality));
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
