import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final storage = GetStorage();
  var isLoading = false.obs;
  var errorCodes =
      <String>[].obs; // ✅ Stocke les codes d'erreur de l'inscription
  var loginError = "".obs; // ✅ Stocke l'erreur de connexion
  var isLoggedIn = false.obs; // ✅ Gère l'état de connexion
  var userId = "".obs;
  var username = "".obs;
  var userEmail = "".obs;
  var userTitle = "".obs;
  var isEditorOrReader = false.obs;
  var isSubscribed = false.obs;
  var token = "".obs; // ✅ Stocke le token JWT pour les requêtes
  var refreshToken = "".obs; // ✅ Stocke le refresh token

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus(); // ✅ Vérifie l'état de connexion au démarrage
  }

  void checkLoginStatus() {
    token.value = storage.read('token') ?? "";
    userEmail.value = storage.read('email') ?? "";
    username.value = storage.read('username') ?? "";
    userTitle.value = storage.read('title') ?? "";
    isSubscribed.value = storage.read('isSubscribed') ?? false;
    isEditorOrReader.value =
        storage.read('isEditorOrReader') ?? false; // ✅ Ajout ici
    isLoggedIn.value = token.value.isNotEmpty;
  }

  /// 🔹 **Inscription d'un utilisateur**
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required bool isEditorOrReader,
    required String title,
  }) async {
    isLoading.value = true;
    errorCodes.clear();

    final String apiUrl = "http://158.69.52.19:8007/users/api/signup/";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "isEditorOrReader": isEditorOrReader,
          "title": title,
        }),
      );

      isLoading.value = false;

      if (response.statusCode == 201) {
        Get.snackbar("Succès", "Inscription réussie !",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        Get.offAllNamed("/"); // ✅ Rediriger vers la page principale
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData["code"] != null) {
          errorCodes.value = List<String>.from(errorData["code"]);
        }
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar("Erreur", "Problème de connexion.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    isLoading.value = true;
    final String apiUrl = "http://158.69.52.19:8007/users/api/login/";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // ✅ Stocker les infos utilisateur dans GetStorage
        storage.write("token", userData["access"]);
        storage.write("refreshToken", userData["refresh"]);
        storage.write("userId", userData["user"]["id"]);
        storage.write("username", userData["user"]["username"]);
        storage.write("email", userData["user"]["email"]);
        storage.write("title", userData["user"]["title"]);
        storage.write("isSubscribed", userData["user"]["suscription"]);
        storage.write("isEditorOrReader",
            userData["user"]["isEditorOrReader"]); // ✅ Ajout ici

        // ✅ Mettre à jour l'état
        token.value = userData["access"];
        refreshToken.value = userData["refresh"];
        userId.value = userData["user"]["id"].toString();
        username.value = userData["user"]["username"];
        userEmail.value = userData["user"]["email"];
        userTitle.value = userData["user"]["title"];
        isSubscribed.value = userData["user"]["suscription"];
        isEditorOrReader.value =
            userData["user"]["isEditorOrReader"]; // ✅ Ajout ici
        isLoggedIn.value = true;

        Get.snackbar("Succès", "Connexion réussie !",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        Get.offAllNamed("/account"); // ✅ Rediriger vers la page "Compte"
      } else {
        Get.snackbar("Erreur", "Identifiants incorrects ou compte inactif",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar("Erreur", "Problème de connexion",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // ✅ Fonction de souscription
  Future<void> subscribeUser() async {
    isLoading.value = true;
    final String apiUrl = "http://158.69.52.19:8007/users/api/subscribe/";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token.value}"
        },
        body: jsonEncode({"email": userEmail.value}),
      );

      if (response.statusCode == 200) {
        isSubscribed.value = true;
        Get.snackbar("Succès", "Souscription réussie",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar("Erreur", "Échec de la souscription",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      Get.snackbar("Erreur", "Problème de connexion",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ **Mise à jour de l'utilisateur**
  Future<void> updateUserInfo(
      {required String newUsername, required String newTitle}) async {
    isLoading.value = true;
    final String apiUrl = "http://158.69.52.19:8007/users/api/update/";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token.value}", // ✅ Ajout du token JWT
        },
        body: jsonEncode({"username": newUsername, "title": newTitle}),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // ✅ Mise à jour des valeurs locales après succès
        username.value = userData["user"]["username"];
        userTitle.value = userData["user"]["title"];

        Get.snackbar("Succès", "Informations mises à jour !",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
            "Erreur", errorData["message"] ?? "Échec de la mise à jour",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (error) {
      isLoading.value = false;
      Get.snackbar("Erreur", "Problème de connexion au serveur",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void logout() {
    // ✅ Supprime toutes les infos stockées
    storage.erase();
    token.value = "";
    refreshToken.value = "";
    userId.value = "";
    username.value = "";
    userEmail.value = "";
    userTitle.value = "";
    isSubscribed.value = false;
    isLoggedIn.value = false;

    Get.offAllNamed("/"); // ✅ Retour à l'accueil
  }
}
