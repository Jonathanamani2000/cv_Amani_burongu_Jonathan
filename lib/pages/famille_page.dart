import 'package:flutter/material.dart';

import '../data/famille_membre.dart';
import '../services/api_service.dart';
import '../widgets/glass_card.dart';
import '../widgets/pastille.dart';

/// Liste les membres de la famille depuis l'API et permet leur gestion.
class FamillePage extends StatefulWidget {
  const FamillePage({super.key, this.api});

  final ApiService? api;

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  late final ApiService _api;
  List<FamilleMembre> _membres = [];
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? ApiService();
    _chargerMembres();
  }

  Future<void> _chargerMembres() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      final membres = await _api.getMembres();
      if (!mounted) return;
      setState(() => _membres = membres);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _erreur = error.message);
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  Future<void> _ajouterMembre() async {
    final fields = await _ouvrirFormulaire();
    if (fields == null) return;
    try {
      await _api.createMembre(fields);
      await _chargerMembres();
      _notifier('Membre ajouté.');
    } on ApiException catch (error) {
      _notifier(error.message);
    }
  }

  Future<void> _modifierMembre(FamilleMembre membre) async {
    final fields = await _ouvrirFormulaire(membre: membre);
    if (fields == null) return;
    try {
      await _api.updateMembre(membre.id, fields);
      await _chargerMembres();
      _notifier('Membre modifié.');
    } on ApiException catch (error) {
      _notifier(error.message);
    }
  }

  Future<void> _supprimerMembre(FamilleMembre membre) async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text(
          'Cette action supprimera ${membre.prenom} ${membre.nom} de la base.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmer != true) return;
    try {
      await _api.deleteMembre(membre.id);
      await _chargerMembres();
      _notifier('Membre supprimé.');
    } on ApiException catch (error) {
      _notifier(error.message);
    }
  }

  Future<Map<String, String>?> _ouvrirFormulaire(
      {FamilleMembre? membre}) {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _MembreFormDialog(membre: membre),
    );
  }

  void _notifier(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text('Membres enregistrés dans la base de données'),
              ),
              IconButton(
                tooltip: 'Actualiser',
                onPressed: _chargement ? null : _chargerMembres,
                icon: const Icon(Icons.refresh),
              ),
              IconButton.filled(
                tooltip: 'Ajouter un membre',
                onPressed: _ajouterMembre,
                icon: const Icon(Icons.person_add),
              ),
            ],
          ),
        ),
        Expanded(
          child: _chargement
              ? const Center(child: CircularProgressIndicator())
              : _erreur != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_erreur!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _chargerMembres,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _membres.isEmpty
                      ? const Center(
                          child: Text('Aucun membre. Ajoutez le premier.'),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                          itemCount: _membres.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final membre = _membres[index];
                            return _carteMembre(membre);
                          },
                        ),
        ),
      ],
    );
  }

  Widget _carteMembre(FamilleMembre membre) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white12,
            backgroundImage:
                membre.imageUrl == null ? null : NetworkImage(membre.imageUrl!),
            onBackgroundImageError:
                membre.imageUrl == null ? null : (_, __) {},
            child: membre.imageUrl == null
                ? const Icon(Icons.person, size: 34)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${membre.prenom} ${membre.nom} ${membre.postnom}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Pastille(membre.parente),
                const SizedBox(height: 6),
                Text(
                  '${membre.lieuNaissance} · ${membre.dateNaissance}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Actions sur le membre',
            onSelected: (action) {
              if (action == 'modifier') {
                _modifierMembre(membre);
              } else {
                _supprimerMembre(membre);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'modifier',
                child: Text('Modifier'),
              ),
              PopupMenuItem(
                value: 'supprimer',
                child: Text('Supprimer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MembreFormDialog extends StatefulWidget {
  const _MembreFormDialog({this.membre});

  final FamilleMembre? membre;

  @override
  State<_MembreFormDialog> createState() => _MembreFormDialogState();
}

class _MembreFormDialogState extends State<_MembreFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final membre = widget.membre;
    _controllers = {
      'nom': TextEditingController(text: membre?.nom ?? ''),
      'postnom': TextEditingController(text: membre?.postnom ?? ''),
      'prenom': TextEditingController(text: membre?.prenom ?? ''),
      'lieu_naissance':
          TextEditingController(text: membre?.lieuNaissance ?? ''),
      'date_naissance':
          TextEditingController(text: membre?.dateNaissance ?? ''),
      'parente': TextEditingController(text: membre?.parente ?? ''),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final membre = widget.membre;
    return AlertDialog(
      title: Text(membre == null ? 'Ajouter un membre' : 'Modifier le membre'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _champ('nom', 'Nom'),
              _champ('postnom', 'Postnom'),
              _champ('prenom', 'Prénom'),
              _champ('lieu_naissance', 'Lieu de naissance'),
              _champ(
                'date_naissance',
                'Date de naissance (AAAA-MM-JJ)',
                validator: _validerDate,
              ),
              _champ('parente', 'Lien de parenté'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _enregistrer,
          child: Text(membre == null ? 'Ajouter' : 'Enregistrer'),
        ),
      ],
    );
  }

  Widget _champ(
    String key,
    String label, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(labelText: label),
        validator: validator ??
            (value) => value == null || value.trim().isEmpty
                ? 'Ce champ est obligatoire'
                : null,
      ),
    );
  }

  String? _validerDate(String? value) {
    final input = value?.trim() ?? '';
    final date = DateTime.tryParse(input);
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(input) ||
        date == null ||
        date.toIso8601String().substring(0, 10) != input ||
        date.isAfter(DateTime.now())) {
      return 'Saisissez une date valide qui n’est pas dans le futur';
    }
    return null;
  }

  void _enregistrer() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _controllers.map((key, controller) => MapEntry(key, controller.text.trim())),
    );
  }
}
