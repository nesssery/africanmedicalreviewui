import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/widgets/article_card.dart';

class ArticlesBySpecialityPage extends StatelessWidget {
  final Map<String, dynamic> speciality;

  const ArticlesBySpecialityPage({Key? key, required this.speciality})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> articles = speciality["articles"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(speciality["name"] ?? "Spécialité"),
        backgroundColor: Colors.blue.shade600,
      ),
      body: articles.isEmpty
          ? Center(
              child: Text(
                "Aucun article disponible pour cette spécialité",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: articles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width < 700 ? 1 : 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> article =
                      articles[index] as Map<String, dynamic>;

                  return ArticleCard(
                    article: article, // ✅ Passe l'article entier
                  );
                },
              ),
            ),
    );
  }
}
