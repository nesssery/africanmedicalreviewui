import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';

class AccountPage extends StatelessWidget {
  final AuthController authController = Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ Pré-remplir les champs avec les infos actuelles de l'utilisateur
    usernameController.text = authController.username.value;
    titleController.text = authController.userTitle.value;

    return Scaffold(
      appBar: AppBar(
        title: Text("Mon Compte"),
        backgroundColor: Colors.blue.shade600,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Section : Informations Personnelles
            _buildSection(
              title: "Informations Personnelles",
              child: Column(
                children: [
                  _buildTextField("Nom d'utilisateur", usernameController),
                  SizedBox(height: 10),
                  _buildTextField(
                      "Email",
                      TextEditingController(
                          text: authController.userEmail.value),
                      readOnly: true),
                  SizedBox(height: 10),
                  _buildTextField("Titre", titleController),
                  SizedBox(height: 15),

                  // ✅ Bouton de mise à jour
                  Obx(() => authController.isLoading.value
                      ? CircularProgressIndicator()
                      : _buildButton("Mettre à jour", Colors.green.shade600,
                          () {
                          authController.updateUserInfo(
                            newUsername: usernameController.text,
                            newTitle: titleController.text,
                          );
                        })),
                ],
              ),
            ),
            SizedBox(height: 20),

            // ✅ Section : Soumission d'article (Affiché seulement si isEditorOrReader est true)
            Obx(() => authController.isEditorOrReader.value
                ? _buildSection(
                    title: "Soumission d'article",
                    child: _buildButton(
                        "Soumettre un article", Colors.blue.shade600, () {
                      Get.toNamed(
                          '/submit-article'); // ✅ Redirection vers la page de soumission
                    }),
                  )
                : Container()),

            SizedBox(height: 20),

            // ✅ Section : Actions
            _buildSection(
              title: "Actions",
              child: Center(
                child: _buildButton("Se Déconnecter", Colors.red.shade600, () {
                  authController.logout();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Fonction pour afficher une section avec un titre
  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  // ✅ Fonction pour un champ de texte
  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: readOnly,
          fillColor: readOnly ? Colors.grey.shade200 : null,
        ),
      ),
    );
  }

  // ✅ Fonction pour créer un bouton compact
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}
