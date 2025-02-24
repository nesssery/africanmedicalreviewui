import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';

class InscriptionPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  var isEditorOrReader = false.obs;
  var isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AFRICAN MEDICAL REVIEW",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/home'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Formulaire d'inscription",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // 📌 Affichage des erreurs
                Obx(() => authController.errorCodes.isNotEmpty
                    ? Column(
                        children: authController.errorCodes.map((code) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              getErrorMessage(code),
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          );
                        }).toList(),
                      )
                    : Container()),

                SizedBox(height: 10),

                // 📌 Champ Nom d'utilisateur
                buildTextField(usernameController, "Nom d'utilisateur"),
                SizedBox(height: 15),

                // 📌 Champ Email
                buildTextField(emailController, "Email", isEmail: true),
                SizedBox(height: 15),

                // 📌 Champ Mot de Passe avec visibilité
                buildPasswordField(),
                SizedBox(height: 15),

                // 📌 Champ Titre
                buildTextField(titleController, "Titre"),
                SizedBox(height: 15),

                // 📌 Switch Éditeur/Lecteur
                SizedBox(
                  width: 300,
                  child: Obx(() => SwitchListTile(
                        title: Text("Éditeur/Lecteur"),
                        value: isEditorOrReader.value,
                        onChanged: (bool value) {
                          isEditorOrReader.value = value;
                        },
                      )),
                ),
                SizedBox(height: 20),

                // 📌 Bouton d'inscription
                Obx(
                  () => authController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : buildGradientButton(
                          onPressed: () {
                            authController.registerUser(
                              username: usernameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              isEditorOrReader: isEditorOrReader.value,
                              title: titleController.text,
                            );
                          },
                          text: "S'inscrire",
                        ),
                ),

                SizedBox(height: 10),

                // 📌 Bouton "Se connecter"
                buildOutlinedButton(
                  onPressed: () {
                    Get.toNamed(
                        "/login"); // ✅ Rediriger vers la page de connexion
                  },
                  text: "Se connecter",
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

  // 📌 Fonction pour construire un bouton "Se connecter"
  Widget buildOutlinedButton(
      {required VoidCallback onPressed, required String text}) {
    return SizedBox(
      width: 300,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: Colors.blue.shade600, width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.blue.shade600,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 📌 Fonction pour obtenir le message d'erreur en fonction du code
String getErrorMessage(String code) {
  switch (code) {
    case "415":
      return "L'email est déjà utilisé.";
    case "414":
      return "Le mot de passe est obligatoire.";
    case "413":
      return "Ce nom d'utilisateur est déjà pris.";
    case "412":
      return "Le champ 'Titre' est obligatoire.";
    default:
      return "Une erreur s'est produite.";
  }
}
