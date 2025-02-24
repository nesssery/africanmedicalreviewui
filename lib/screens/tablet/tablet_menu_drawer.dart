import 'package:flutter/material.dart';

class TabletMenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero), // ✅ Supprime le border radius
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.blueGrey.shade900, // ✅ En-tête du menu
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(Icons.home, "Accueil", () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.article, "Articles", () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.info, "À propos", () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.contact_page, "Contact", () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      onTap: onTap,
    );
  }
}
