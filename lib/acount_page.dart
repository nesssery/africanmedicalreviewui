import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart'; // Ajout pour Poppins (si non déjà présent)

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false; // État hover pour les boutons

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs avec les infos actuelles de l'utilisateur
    usernameController.text = authController.username.value;
    titleController.text = authController.userTitle.value;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Animation d’entrée fluide
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      // Changé begin: 1.0 pour affichage immédiat
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    // Débogage pour vérifier les données initiales
    debugPrint(
        "Username: ${authController.username.value}, Title: ${authController.userTitle.value}, Email: ${authController.userEmail.value}");
  }

  @override
  void dispose() {
    _animationController.dispose();
    usernameController.dispose();
    titleController.dispose();
    super.dispose();
  }

  /// ✅ Widget pour afficher une section avec un titre
  Widget _buildSection({required String title, required Widget child}) {
    return AnimatedOpacity(
      opacity: _opacityAnimation.value,
      duration: Duration(milliseconds: 500),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4CAF50).withOpacity(0.1), // Vert médical clair
              Color(0xFF81C784).withOpacity(0.1), // Vert émeraude clair
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centré horizontalement
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  /// ✅ Widget pour un champ de texte
  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 350 : 300,
      child: MouseRegion(
        cursor: readOnly ? SystemMouseCursors.basic : SystemMouseCursors.click,
        onEnter: readOnly ? null : (_) => setState(() => _isHovered = true),
        onExit: readOnly ? null : (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: readOnly ? Colors.grey.shade200 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: readOnly
                  ? Color(0xFF4DB6AC)
                  : _isHovered
                      ? Color(0xFF4DB6AC)
                      : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: _isHovered && !readOnly ? 0.15 : 0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              prefixIcon: readOnly
                  ? null
                  : Icon(
                      label == "Nom d'utilisateur"
                          ? Icons.person
                          : label == "Email"
                              ? Icons.email
                              : Icons.work_outline,
                      color: Color(0xFF4DB6AC),
                    ),
            ),
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  /// ✅ Widget pour créer un bouton avec un gradient ou couleur
  Widget _buildButton(String text, Color baseColor, VoidCallback onPressed) {
    final isGreenOrBlue =
        baseColor == Colors.green.shade600 || baseColor == Colors.blue.shade600;
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 350 : 300,
      height: 50,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: isGreenOrBlue
                ? LinearGradient(
                    colors: [
                      _isHovered
                          ? Color(0xFF26A69A)
                          : Color(0xFF4CAF50), // Vert médical clair au hover
                      _isHovered
                          ? Color(0xFF4DB6AC)
                          : Color(0xFF81C784), // Vert émeraude au hover
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isGreenOrBlue
                ? Colors.red.shade600
                : null, // Rouge pour "Se Déconnecter"
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors
                  .transparent, // Fond transparent pour le dégradé/couleur
              elevation: 0, // Pas d’élévation par défaut
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Débogage pour vérifier si le build est appelé
    debugPrint("Building AccountPage");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mon Compte",
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
          onPressed: () => Get.offAllNamed('/'),
        ),
      ),
      body: Center(
        // Centré verticalement et horizontalement
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 20), // Ajusté pour un look aéré
          child: Column(
            mainAxisSize: MainAxisSize.min, // Limite la hauteur pour centrer
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centré horizontalement
            children: [
              // ✅ Section : Informations Personnelles
              _buildSection(
                title: "Informations Personnelles",
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centré horizontalement
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centré horizontalement
                  children: [
                    _buildTextField("Nom d'utilisateur", usernameController),
                    SizedBox(height: 15),
                    _buildTextField(
                        "Email",
                        TextEditingController(
                            text: authController.userEmail.value),
                        readOnly: true),
                    SizedBox(height: 15),
                    _buildTextField("Titre", titleController),
                    SizedBox(height: 20),

                    // ✅ Bouton de mise à jour avec design premium
                    Obx(() => authController.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4DB6AC)),
                              strokeWidth: 4,
                            ),
                          )
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
                      child: Center(
                        // Centré horizontalement
                        child: _buildButton(
                            "Soumettre un article", Colors.blue.shade600, () {
                          Get.toNamed('/submit-article'); // ✅ Redirection
                        }),
                      ),
                    )
                  : SizedBox.shrink()),

              SizedBox(height: 20),

              // ✅ Section : Actions
              _buildSection(
                title: "Actions",
                child: Center(
                  // Centré horizontalement
                  child:
                      _buildButton("Se Déconnecter", Colors.red.shade600, () {
                    authController.logout();
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
