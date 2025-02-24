import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController =
      Get.find(); // ✅ Récupère l'instance existante

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connexion",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Connexion à votre compte",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // 📌 Affichage des erreurs de connexion
                Obx(() => authController.loginError.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          authController.loginError.value,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      )
                    : Container()),

                // 📌 Champ Email
                buildTextField(emailController, "Email", isEmail: true),
                SizedBox(height: 15),

                // 📌 Champ Mot de Passe avec visibilité
                buildPasswordField(),
                SizedBox(height: 15),

                // 📌 Bouton Connexion
                Obx(
                  () => authController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : buildGradientButton(
                          onPressed: () {
                            authController.loginUser(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          },
                          text: "Se connecter",
                        ),
                ),

                SizedBox(height: 10),

                // 📌 Lien vers l'inscription
                TextButton(
                  onPressed: () {
                    Get.toNamed("/signup"); // ✅ Redirige vers l'inscription
                  },
                  child: Text(
                    "Créer un compte",
                    style: TextStyle(color: Colors.blue.shade600, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📌 Fonction pour construire un champ de texte générique
  Widget buildTextField(TextEditingController controller, String label,
      {bool isEmail = false}) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }

  // 📌 Fonction pour le champ de mot de passe avec visibilité
  Widget buildPasswordField() {
    return SizedBox(
      width: 300,
      child: Obx(() => TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
              ),
            ),
            obscureText: !isPasswordVisible.value,
          )),
    );
  }

  // 📌 Fonction pour construire un bouton avec un gradient
  Widget buildGradientButton(
      {required VoidCallback onPressed, required String text}) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.blue.shade700,
          elevation: 5,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(minHeight: 50),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
