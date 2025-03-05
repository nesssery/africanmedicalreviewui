import 'dart:convert';
import 'package:africanmedicalreview/widgets/articles_by_speciality_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart'; // Ajout pour Poppins (si non déjà présent)

class SpecialitiesPage extends StatefulWidget {
  @override
  _SpecialitiesPageState createState() => _SpecialitiesPageState();
}

class _SpecialitiesPageState extends State<SpecialitiesPage>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find();
  List<Map<String, dynamic>> specialities = [];
  List<Map<String, dynamic>> filteredSpecialities = []; // Liste filtrée
  bool isLoading = true;
  final TextEditingController searchController =
      TextEditingController(); // Contrôleur du champ de recherche
  late AnimationController _pageAnimationController;
  late Animation<double> _pageOpacityAnimation;

  @override
  void initState() {
    super.initState();
    isLoading = true; // Assurer que isLoading est true au démarrage
    _pageAnimationController = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: 300), // Animation d’entrée fluide pour la page
    );
    _pageOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _pageAnimationController, curve: Curves.easeInOut),
    );
    _pageAnimationController
        .forward(); // Démarrer l’animation de la page immédiatement
    fetchSpecialities();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// 🔹 Récupération des spécialités depuis l'API
  Future<void> fetchSpecialities() async {
    final String apiUrl = "http://158.69.52.19:8007/api/specialities/articles/";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          specialities = List<Map<String, dynamic>>.from(data);
          filteredSpecialities = specialities; // Initialisation des filtres
          isLoading =
              false; // Mettre isLoading à false une fois les données chargées
        });
      } else {
        print("❌ Erreur API (${response.statusCode}): ${response.body}");
        setState(() =>
            isLoading = false); // Mettre isLoading à false en cas d’erreur
      }
    } catch (error) {
      print("❌ Problème de connexion : $error");
      setState(
          () => isLoading = false); // Mettre isLoading à false en cas d’erreur
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
        title: Text(
          "Spécialités",
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
        opacity: _pageOpacityAnimation.value,
        duration: Duration(milliseconds: 300), // Animation d’entrée fluide
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF4DB6AC)), // Vert médical pour le loader
                  strokeWidth: 4,
                ),
              )
            : Column(
                children: [
                  // Champ de recherche avec un design premium
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterSpecialities, // Met à jour la liste
                      decoration: InputDecoration(
                        hintText: "Rechercher une spécialité...",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF4DB6AC)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xFF4DB6AC), width: 2),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.black),
                    ),
                  ),

                  // Liste des spécialités filtrées avec un design premium
                  Expanded(
                    child: filteredSpecialities.isEmpty
                        ? Center(
                            child: Text(
                              "Aucune spécialité trouvée",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            itemCount: filteredSpecialities.length,
                            itemBuilder: (context, index) {
                              final speciality = filteredSpecialities[index];
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_) => _showHoverEffect(true, index),
                                onExit: (_) => _showHoverEffect(false, index),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF26A69A), // Vert médical clair
                                        Color(0xFF4DB6AC) // Vert émeraude
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                            alpha: (_hoverStates[index] ??
                                                    false)
                                                ? 0.15
                                                : 0.05), // Gestion du nullable avec ?? false
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    leading: Icon(Icons.medical_services,
                                        color: Colors.white, size: 28),
                                    title: Text(
                                      speciality["name"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      speciality["description"] ?? "",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      Get.to(
                                          () => ArticlesBySpecialityPage(
                                              speciality: speciality),
                                          transition: Transition.fadeIn);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Map<int, bool> _hoverStates =
      {}; // État hover pour chaque item de la liste (non nullable par conception)

  void _showHoverEffect(bool isHovered, int index) {
    setState(() {
      _hoverStates[index] =
          isHovered; // Met à jour la map avec une valeur booléenne non nullable
    });
  }
}
