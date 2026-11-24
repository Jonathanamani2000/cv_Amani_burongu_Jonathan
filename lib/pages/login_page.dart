import 'package:flutter/material.dart';

import '../data/cv_data.dart';
import '../services/api_service.dart';
import '../widgets/fond_glass.dart';
import '../widgets/glass_card.dart';
import 'main_shell.dart';

/// Page de connexion et de création d'un compte auprès de l'API.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _mdpCtrl = TextEditingController();
  final _api = ApiService();
  bool _masque = true;
  bool _inscription = false;
  bool _chargement = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _mdpCtrl.dispose();
    super.dispose();
  }

  Future<void> _soumettre() async {
    if (!_formKey.currentState!.validate() || _chargement) return;
    setState(() => _chargement = true);

    try {
      if (_inscription) {
        await _api.register(_emailCtrl.text.trim(), _mdpCtrl.text);
        if (!mounted) return;
        setState(() => _inscription = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte créé. Vous pouvez maintenant vous connecter.'),
          ),
        );
      } else {
        await _api.login(_emailCtrl.text.trim(), _mdpCtrl.text);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } finally {
      if (mounted) setState(() => _chargement = false);
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
                          _inscription ? 'Créer un compte' : 'Connexion',
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
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _style('E-mail', Icons.email),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty || !email.contains('@')) {
                              return 'Entrez une adresse e-mail valide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mdpCtrl,
                          obscureText: _masque,
                          onFieldSubmitted: (_) => _soumettre(),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez votre mot de passe';
                            }
                            if (_inscription && value.length < 6) {
                              return 'Le mot de passe doit contenir 6 caractères minimum';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _chargement ? null : _soumettre,
                          icon: _chargement
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : Icon(_inscription ? Icons.person_add : Icons.login),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(_inscription
                                ? 'Créer le compte'
                                : 'Se connecter'),
                          ),
                        ),
                        TextButton(
                          onPressed: _chargement
                              ? null
                              : () => setState(
                                    () => _inscription = !_inscription,
                                  ),
                          child: Text(
                            _inscription
                                ? 'J’ai déjà un compte'
                                : 'Créer un compte',
                          ),
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

  InputDecoration _style(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
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
