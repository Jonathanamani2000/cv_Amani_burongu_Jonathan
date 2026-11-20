import 'package:flutter/material.dart';

import '../data/cv_data.dart';
import '../widgets/fond_glass.dart';
import '../widgets/glass_card.dart';
import 'main_shell.dart';

/// Page 1 : connexion.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _mdpCtrl = TextEditingController();
  bool _masque = true;

  @override
  void dispose() {
    _idCtrl.dispose();
    _mdpCtrl.dispose();
    super.dispose();
  }

  void _seConnecter() {
    if (!_formKey.currentState!.validate()) return;

    final ok = _idCtrl.text.trim().toLowerCase() == CvData.identifiant &&
        _mdpCtrl.text == CvData.motDePasse;

    if (ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identifiant ou mot de passe incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: FondGlass(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.account_circle,
                            size: 72, color: theme.colorScheme.primary),
                        const SizedBox(height: 12),
                        Text(
                          'Connexion',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Accédez au CV de ${CvData.nom}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: _idCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: _style('Identifiant', Icons.person),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Entrez votre identifiant'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mdpCtrl,
                          obscureText: _masque,
                          onFieldSubmitted: (_) => _seConnecter(),
                          decoration:
                              _style('Mot de passe', Icons.lock).copyWith(
                            suffixIcon: IconButton(
                              tooltip: _masque ? 'Afficher' : 'Masquer',
                              icon: Icon(_masque
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () =>
                                  setState(() => _masque = !_masque),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Entrez votre mot de passe'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _seConnecter,
                          icon: const Icon(Icons.login),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('Se connecter'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Test : ${CvData.identifiant} / ${CvData.motDePasse}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Style commun des deux champs : fond vitré et bords arrondis.
  InputDecoration _style(String label, IconData icone) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white70, width: 1.4),
      ),
    );
  }
}
