import 'package:flutter/material.dart';

import '../data/cv_data.dart';
import '../widgets/glass_card.dart';
import '../widgets/photo_avatar.dart';
import '../widgets/section_card.dart';

/// Page 2 : accueil, avec le CV complet.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      // 110 en bas : la barre de navigation en verre ne cache pas la fin.
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      children: [
        // En-tête : photo, nom et titre, centrés.
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const PhotoAvatar(
                  asset: CvData.photoMoi,
                  radius: 56,
                  fallback: Icons.person,
                ),
                const SizedBox(height: 16),
                Text(
                  CvData.nom,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  CvData.titre,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        ),
        SectionCard(
          title: 'Profil',
          icon: Icons.badge_outlined,
          child: Text(
            CvData.profil,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: Colors.white70, height: 1.5),
          ),
        ),
        SectionCard(
          title: 'Formation',
          icon: Icons.school_outlined,
          child: EntreeListe(entrees: CvData.formations),
        ),
        SectionCard(
          title: 'Expériences et projets',
          icon: Icons.work_outline,
          child: EntreeListe(entrees: CvData.experiences),
        ),
        SectionCard(
          title: 'Compétences techniques',
          icon: Icons.build_outlined,
          child: _chips(CvData.competencesTechniques),
        ),
        SectionCard(
          title: 'Langues',
          icon: Icons.translate,
          child: _chips(CvData.competencesLinguistiques),
        ),
        SectionCard(
          title: 'Centres d\'intérêt',
          icon: Icons.favorite_border,
          child: _chips(CvData.interets),
        ),
      ],
    );
  }

  /// Étiquettes alignées à gauche, avec le même espacement partout.
  Widget _chips(List<String> items) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: [for (final t in items) Chip(label: Text(t))],
      ),
    );
  }
}
