import 'dart:convert';
import 'package:africanmedicalreview/widgets/articles_by_speciality_page.dart';
import 'package:africanmedicalreview/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialitiesPage extends StatefulWidget {
  @override
  _SpecialitiesPageState createState() => _SpecialitiesPageState();
}

class _SpecialitiesPageState extends State<SpecialitiesPage>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find();
  List<Map<String, dynamic>> specialities = [];
  List<Map<String, dynamic>> filteredSpecialities = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  late AnimationController _pageAnimationController;
  late Animation<double> _pageOpacityAnimation;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _pageAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _pageOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _pageAnimationController, curve: Curves.easeInOut),
    );
    _pageAnimationController.forward();
    fetchSpecialities();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchSpecialities() async {
    final String apiUrl =
        "https://api.africanmedicalreview.com/api/specialities/articles/";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Décoder manuellement les données brutes en UTF-8 avant de les passer à jsonDecode
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(decodedBody);
        setState(() {
          specialities = List<Map<String, dynamic>>.from(data);
          filteredSpecialities = specialities;
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
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          width: double.infinity,
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
                        "Spécialités",
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
        opacity: _pageOpacityAnimation.value,
        duration: Duration(milliseconds: 300),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
                  strokeWidth: 4,
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48.0, vertical: 12),
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 1200),
                        child: TextField(
                          controller: searchController,
                          onChanged: filterSpecialities,
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
                              borderSide: BorderSide(
                                  color: Color(0xFF4DB6AC), width: 2),
                            ),
                          ),
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filteredSpecialities.isEmpty
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 48.0),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 1200),
                                child: Text(
                                  "Aucune spécialité trouvée",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 48.0),
                            child: Center(
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 1200),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: ListView.builder(
                                  itemCount: filteredSpecialities.length,
                                  itemBuilder: (context, index) {
                                    final speciality =
                                        filteredSpecialities[index];
                                    return MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      onEnter: (_) =>
                                          _showHoverEffect(true, index),
                                      onExit: (_) =>
                                          _showHoverEffect(false, index),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        margin: EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF26A69A),
                                              Color(0xFF4DB6AC),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                  alpha: (_hoverStates[index] ??
                                                          false)
                                                      ? 0.15
                                                      : 0.05),
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Map<int, bool> _hoverStates = {};

  void _showHoverEffect(bool isHovered, int index) {
    setState(() {
      _hoverStates[index] = isHovered;
    });
  }
}
