import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = authController.username.value;
    titleController.text = authController.userTitle.value;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
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

  /// Widget pour afficher une section avec un titre
  Widget _buildSection({required String title, required Widget child}) {
    return AnimatedOpacity(
      opacity: _opacityAnimation.value,
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        margin:
            const EdgeInsets.symmetric(vertical: 8), // Marge pour espacement
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4CAF50).withOpacity(0.1),
              const Color(0xFF81C784).withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  /// Widget pour un champ de texte
  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    // Ajuster la largeur en fonction de la taille de l'écran
    double screenWidth = MediaQuery.of(context).size.width;
    double fieldWidth = screenWidth > 600
        ? 350
        : screenWidth * 0.8; // 80% de la largeur sur petits écrans

    return SizedBox(
      width: fieldWidth.clamp(300, 350), // Limiter entre 300 et 350
      child: MouseRegion(
        cursor: readOnly ? SystemMouseCursors.basic : SystemMouseCursors.click,
        onEnter: readOnly ? null : (_) => setState(() => _isHovered = true),
        onExit: readOnly ? null : (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: readOnly ? Colors.grey.shade200 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: readOnly
                  ? const Color(0xFF4DB6AC)
                  : _isHovered
                      ? const Color(0xFF4DB6AC)
                      : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(_isHovered && !readOnly ? 0.15 : 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      color: const Color(0xFF4DB6AC),
                    ),
            ),
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  /// Widget pour créer un bouton avec un gradient ou couleur
  Widget _buildButton(String text, Color baseColor, VoidCallback onPressed) {
    final isGreenOrBlue =
        baseColor == Colors.green.shade600 || baseColor == Colors.blue.shade600;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth > 600 ? 350 : screenWidth * 0.8;

    return SizedBox(
      width: buttonWidth.clamp(300, 350),
      height: 50,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: isGreenOrBlue
                ? LinearGradient(
                    colors: [
                      _isHovered
                          ? const Color(0xFF26A69A)
                          : const Color(0xFF4CAF50),
                      _isHovered
                          ? const Color(0xFF4DB6AC)
                          : const Color(0xFF81C784),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isGreenOrBlue ? Colors.red.shade600 : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
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
    debugPrint("Building AccountPage");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mon Compte",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: null,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1976D2),
                Color(0xFF66BB6A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Get.offAllNamed('/'),
        ),
      ),
      body: SingleChildScrollView(
        // Ajout pour permettre le défilement
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600
                ? 40
                : 16, // Plus d'espace sur grands écrans
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Section : Informations Personnelles
              _buildSection(
                title: "Informations Personnelles",
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextField("Nom d'utilisateur", usernameController),
                    const SizedBox(height: 15),
                    _buildTextField(
                      "Email",
                      TextEditingController(
                          text: authController.userEmail.value),
                      readOnly: true,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField("Titre", titleController),
                    const SizedBox(height: 20),
                    Obx(() => authController.isLoading.value
                        ? const Center(
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
              const SizedBox(height: 20),

              // Section : Soumission d'article
              Obx(() => authController.isEditorOrReader.value
                  ? _buildSection(
                      title: "Soumission d'article",
                      child: Center(
                        child: _buildButton(
                            "Soumettre un article", Colors.blue.shade600, () {
                          Get.toNamed('/submit-article');
                        }),
                      ),
                    )
                  : const SizedBox.shrink()),

              const SizedBox(height: 20),

              // Section : Actions
              _buildSection(
                title: "Actions",
                child: Center(
                  child:
                      _buildButton("Se Déconnecter", Colors.red.shade600, () {
                    authController.logout();
                  }),
                ),
              ),

              const SizedBox(
                  height:
                      20), // Espace supplémentaire en bas pour le défilement
            ],
          ),
        ),
      ),
    );
  }
}
