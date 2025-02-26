import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart'; // Ajout pour Poppins (si non déjà présent)

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final AuthController authController =
      Get.find(); // ✅ Récupère l'instance existante

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false; // État hover pour les boutons/liens

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Animation d’entrée fluide
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      // Changé begin: 1.0 pour affichage immédiat
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    // Débogage pour vérifier l'initialisation de AuthController
    debugPrint("AuthController initialized: $authController");
    debugPrint("isPasswordVisible: $isPasswordVisible");
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// ✅ Widget pour construire un champ de texte générique
  Widget buildTextField(TextEditingController controller, String label,
      {bool isEmail = false, IconData? icon}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 350 : 300,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              icon != null ? Icon(icon, color: Color(0xFF4DB6AC)) : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF4DB6AC), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
      ),
    );
  }

  /// ✅ Widget pour le champ de mot de passe avec visibilité
  Widget buildPasswordField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 350 : 300,
      child: Obx(() => TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              prefixIcon: Icon(Icons.lock, color: Color(0xFF4DB6AC)),
              suffixIcon: IconButton(
                icon: Icon(isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
                color: Color(0xFF4DB6AC),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF4DB6AC), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
            obscureText: !isPasswordVisible.value,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          )),
    );
  }

  /// ✅ Widget pour construire un bouton avec un gradient
  Widget buildGradientButton(
      {required VoidCallback onPressed, required String text}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 350 : 300,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
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
            ),
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
              backgroundColor:
                  Colors.transparent, // Fond transparent pour le dégradé
              elevation: 0, // Pas d’élévation par défaut
              padding: EdgeInsets.symmetric(vertical: 14),
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

  /// ✅ Widget pour construire un lien "Créer un compte"
  Widget buildTextButton(
      {required VoidCallback onPressed, required String text}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _isHovered ? Color(0xFF4DB6AC) : Colors.blue.shade600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Débogage pour vérifier si le build est appelé
    debugPrint("Building LoginPage");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Connexion",
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
        opacity: _opacityAnimation.value,
        duration: Duration(milliseconds: 500), // Animation d’entrée fluide
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 20), // Ajusté pour un look aéré
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Connexion à votre compte",
                    style: GoogleFonts.poppins(
                      fontSize: 28, // Augmenté pour un impact visuel
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 30),

                  // 📌 Affichage des erreurs avec design premium
                  Obx(() => authController.loginError.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                authController.loginError.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink()),

                  // 📌 Champ Email
                  buildTextField(emailController, "Email", icon: Icons.email),
                  SizedBox(height: 15),

                  // 📌 Champ Mot de Passe avec visibilité
                  buildPasswordField(),
                  SizedBox(height: 15),

                  // 📌 Bouton Connexion avec design premium
                  Obx(
                    () => authController.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4DB6AC)),
                              strokeWidth: 4,
                            ),
                          )
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

                  SizedBox(height: 15),

                  // 📌 Lien "Créer un compte" avec design premium
                  buildTextButton(
                    onPressed: () {
                      Get.toNamed("/signup"); // ✅ Redirige vers l'inscription
                    },
                    text: "Créer un compte",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
