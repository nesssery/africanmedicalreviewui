import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabletNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey.shade900, // ✅ Couleur de la navbar
      elevation: 0,
      title:
          Text("African Medical Review", style: TextStyle(color: Colors.white)),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white), // 🍔 Icone menu
        onPressed: () {
          Scaffold.of(context).openDrawer(); // ✅ Ouvre le menu drawer
        },
      ),
    );
  }
}
