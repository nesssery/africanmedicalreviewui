import 'package:africanmedicalreview/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:africanmedicalreview/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({Key? key}) : super(key: key);

  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var selectedProfession = "Étudiant en santé".obs; // Valeur par défaut
  final List<String> professions = [
    "Étudiant en santé",
    "Médecin",
    "Pharmacien",
    "Infirmier / Infirmière",
    "Dentiste",
    "Chercheur en santé",
    "Autre professionnel de santé",
    "Autres professions",
  ];
  var isEditorOrReader = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var passwordMismatchError = "".obs;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    debugPrint("AuthController initialized: $authController");
    debugPrint(
        "isEditorOrReader: $isEditorOrReader, isPasswordVisible: $isPasswordVisible");
  }

  @override
  void dispose() {
    _animationController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String getErrorMessage(String code) {
    switch (code) {
      case "415":
        return "L'email est déjà utilisé.";
      case "414":
        return "Le mot de passe est obligatoire.";
      case "413":
        return "Ce nom d'utilisateur est déjà pris.";
      case "412":
        return "Le champ 'Profession' est obligatoire.";
      default:
        return "Une erreur s'est produite.";
    }
  }

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

  Widget buildConfirmPasswordField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 350 : 300,
      child: Obx(() => TextField(
            controller: confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirmation de mot de passe",
              prefixIcon: Icon(Icons.lock, color: Color(0xFF4DB6AC)),
              suffixIcon: IconButton(
                icon: Icon(isConfirmPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  isConfirmPasswordVisible.value =
                      !isConfirmPasswordVisible.value;
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
              errorText: passwordMismatchError.value.isNotEmpty
                  ? passwordMismatchError.value
                  : null,
            ),
            obscureText: !isConfirmPasswordVisible.value,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            onChanged: (value) {
              // Réinitialiser l'erreur lorsque l'utilisateur modifie le champ
              if (passwordMismatchError.value.isNotEmpty) {
                passwordMismatchError.value = "";
              }
            },
          )),
    );
  }

  Widget buildProfessionDropdown() {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 350 : 300,
      child: Obx(() => DropdownButtonFormField<String>(
            value: selectedProfession.value,
            decoration: InputDecoration(
              labelText: "Profession",
              prefixIcon: Icon(Icons.work_outline, color: Color(0xFF4DB6AC)),
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
            items: professions.map((String profession) {
              return DropdownMenuItem<String>(
                value: profession,
                child: Text(
                  profession,
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                selectedProfession.value = newValue;
              }
            },
          )),
    );
  }

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
                _isHovered ? Color(0xFF26A69A) : Color(0xFF4CAF50),
                _isHovered ? Color(0xFF4DB6AC) : Color(0xFF81C784),
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
              backgroundColor: Colors.transparent,
              elevation: 0,
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

  Widget buildOutlinedButton(
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
            border: Border.all(
              color: _isHovered ? Color(0xFF4DB6AC) : Colors.blue.shade600,
              width: 2,
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
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
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
                color: _isHovered ? Color(0xFF4DB6AC) : Colors.blue.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building InscriptionPage");

    return CustomScaffold(
      appBar: AppBar(
        title: Text(
          "AFRICAN MEDICAL REVIEW",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: null,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1976D2),
                Color(0xFF66BB6A),
              ],
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
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Get.offAllNamed('/home'),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _opacityAnimation.value,
        duration: Duration(milliseconds: 500),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Formulaire d'inscription",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 30),
                  Obx(() => authController.errorCodes.isNotEmpty
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
                              child: Column(
                                children: authController.errorCodes.map((code) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      getErrorMessage(code),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink()),
                  buildTextField(usernameController, "Nom d'utilisateur",
                      icon: Icons.person),
                  SizedBox(height: 15),
                  buildTextField(emailController, "Email",
                      isEmail: true, icon: Icons.email),
                  SizedBox(height: 15),
                  buildPasswordField(),
                  SizedBox(height: 15),
                  buildConfirmPasswordField(),
                  SizedBox(height: 15),
                  buildProfessionDropdown(), // Remplacement du champ "Titre" par le dropdown
                  SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 600 ? 350 : 300,
                    child: Obx(() => SwitchListTile(
                          title: Text(
                            "Éditeur",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: isEditorOrReader.value,
                          onChanged: (bool value) {
                            isEditorOrReader.value = value;
                          },
                          activeColor: Color(0xFF4DB6AC),
                          tileColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        )),
                  ),
                  SizedBox(height: 20),
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
                              // Vérifier si les mots de passe correspondent
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                passwordMismatchError.value =
                                    "Les mots de passe ne correspondent pas.";
                                return;
                              }
                              // Réinitialiser l'erreur si les mots de passe correspondent
                              passwordMismatchError.value = "";
                              // Appeler la méthode d'inscription
                              authController.registerUser(
                                username: usernameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                isEditorOrReader: isEditorOrReader.value,
                                title: selectedProfession
                                    .value, // Utiliser la profession sélectionnée
                              );
                            },
                            text: "S'inscrire",
                          ),
                  ),
                  SizedBox(height: 15),
                  buildOutlinedButton(
                    onPressed: () {
                      Get.toNamed("/login");
                    },
                    text: "Se connecter",
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
