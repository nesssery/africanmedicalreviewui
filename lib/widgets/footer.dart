import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E7D32), // Vert médical profond
              Color(0xFF1976D2), // Bleu profond (medical blue)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 30),
        _buildLinksColumn(),
        SizedBox(height: 30),
        _buildSocialAndContact(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildHeader()),
        Expanded(flex: 1, child: _buildLinksColumn()),
        Expanded(flex: 2, child: _buildSocialAndContact()),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône médicale (croix) comme demandé précédemment
            Icon(
              FontAwesomeIcons.plus,
              size: 28,
              color: Color(0xFFFF6B6B), // Rouge pour le contraste
            ),
            SizedBox(width: 12),
            Text(
              "AMR",
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          "Connecting African Healthcare",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors
                .white70, // Ajusté pour contraster avec le dégradé vert-bleu
          ),
        ),
      ],
    );
  }

  Widget _buildLinksColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Navigation",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        _buildLink("Home", "/"),
        SizedBox(height: 12),
        _buildLink("Specialties", "/specialities"),
      ],
    );
  }

  Widget _buildSocialAndContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildSocialButton(FontAwesomeIcons.facebook),
            SizedBox(width: 16),
            _buildSocialButton(FontAwesomeIcons.twitter),
            SizedBox(width: 16),
            _buildSocialButton(FontAwesomeIcons.linkedin),
          ],
        ),
        SizedBox(height: 20),
        Text(
          "info@amrhealth.org",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white70, // Ajusté pour contraster avec le dégradé
          ),
        ),
        SizedBox(height: 12),
        Text(
          "© 2025 AMR Health",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.white60, // Ajusté pour contraster avec le dégradé
          ),
        ),
      ],
    );
  }

  Widget _buildLink(String title, String route) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      onHover: (hovering) => setState(() {}),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white
                  .withOpacity(0.3)), // Ajusté pour contraster avec le dégradé
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
