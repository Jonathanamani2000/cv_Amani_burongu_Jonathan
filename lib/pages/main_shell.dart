import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/fond_glass.dart';
import 'contact_page.dart';
import 'famille_page.dart';
import 'home_page.dart';
import 'login_page.dart';

/// Structure affichée après la connexion :
/// une BottomNavigationBar en verre pour passer d'une page à l'autre.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _titres = ['Mon CV', 'Ma famille', 'Contact'];
  static const _pages = <Widget>[HomePage(), FamillePage(), ContactPage()];

  void _deconnexion() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FondGlass(
      child: Scaffold(
        // Le contenu passe derrière la barre du bas, qui le floute.
        extendBody: true,
        appBar: AppBar(
          title: Text(_titres[_index]),
          actions: [
            IconButton(
              tooltip: 'Se déconnecter',
              icon: const Icon(Icons.logout),
              onPressed: _deconnexion,
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: IndexedStack(index: _index, children: _pages),
          ),
        ),
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Accueil'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.family_restroom), label: 'Famille'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_phone), label: 'Contact'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
