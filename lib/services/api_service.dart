import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  /// 🔹 Récupère les 10 derniers articles en vedette
  static Future<List<Map<String, dynamic>>> fetchFeaturedArticles() async {
    final response = await http.get(Uri.parse("$baseUrl/articles/featured/"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(
          "Erreur lors de la récupération des articles en vedette.");
    }
  }

  /// 🔹 Récupère les 10 derniers articles récents
  static Future<List<Map<String, dynamic>>> fetchLatestArticles() async {
    final response = await http.get(Uri.parse("$baseUrl/articles/featured/"));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Erreur lors de la récupération des derniers articles.");
    }
  }
}
