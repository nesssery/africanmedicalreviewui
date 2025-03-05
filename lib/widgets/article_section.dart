import 'package:flutter/material.dart';
import 'package:africanmedicalreview/services/api_service.dart';
import 'package:africanmedicalreview/widgets/article_card.dart';

class ArticleSection extends StatefulWidget {
  @override
  _ArticleSectionState createState() => _ArticleSectionState();
}

class _ArticleSectionState extends State<ArticleSection> {
  List<Map<String, dynamic>> articles = [];
  List<Map<String, dynamic>> filteredArticles = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  /// 🔍 Filtrage dynamique des articles en fonction de la recherche utilisateur
  void filterArticles(String query) {
    setState(() {
      filteredArticles = articles
          .where((article) =>
              article["title"].toLowerCase().contains(query.toLowerCase()) ||
              article["articleDescription"]
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  /// ✅ Récupération des 10 derniers articles via l'API
  Future<void> fetchArticles() async {
    try {
      List<Map<String, dynamic>> fetchedArticles =
          await ApiService.fetchLatestArticles();
      setState(() {
        articles = fetchedArticles;
        filteredArticles =
            fetchedArticles; // ✅ Initialise avec tous les articles
        isLoading = false;
      });
    } catch (e) {
      print("❌ Erreur API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 700 ? 1 : (screenWidth < 1024 ? 2 : 3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷 Titre de la section avec nouvelle couleur
          Text(
            "Articles Récents",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF26A69A), // Teal médical pour cohérence
            ),
          ),
          SizedBox(height: 10),

          // 🔎 Champ de recherche large avec design amélioré
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: double.infinity, // Largeur maximale pour grand écran
              child: TextField(
                controller: searchController,
                onChanged:
                    filterArticles, // ✅ Met à jour la liste en temps réel
                onTap: () => setState(() {}), // Activer l’animation au focus
                decoration: InputDecoration(
                  hintText: "Rechercher un article...",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  prefixIcon: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.0,
                      duration: Duration(milliseconds: 200),
                      child:
                          Icon(Icons.search, color: Colors.grey[700], size: 24),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Bordures plus arrondies
                    borderSide: BorderSide(
                        color: Color(0xFF26A69A),
                        width: 2), // Teal pour la bordure
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(0xFF26A69A),
                        width: 2), // Teal plus marqué au focus
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                        color: Color(0xFF26A69A),
                        width: 2), // Teal pour l’état normal
                  ),
                  filled: true,
                  fillColor:
                      Colors.white, // Fond blanc pour un contraste optimal
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16), // Padding accru pour un look premium
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // 🔄 Loader ou affichage des articles
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (filteredArticles.isEmpty)
            Center(
                child: Text("Aucun article disponible",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.9,
              ),
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) =>
                  ArticleCard(article: filteredArticles[index]),
            ),
        ],
      ),
    );
  }
}
