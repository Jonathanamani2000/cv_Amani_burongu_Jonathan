import 'package:flutter/material.dart';

import '../data/cv_data.dart';
import 'glass_card.dart';

/// Carte glass d'une section du CV : une pastille d'icône + le titre,
/// puis le contenu. Tout est aligné à gauche.
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return GlassCard(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

/// Liste de formations ou d'expériences, espacées régulièrement.
class EntreeListe extends StatelessWidget {
  final List<Entree> entrees;

  const EntreeListe({super.key, required this.entrees});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < entrees.length; i++) ...[
          if (i > 0) const SizedBox(height: 20),
          EntreeTile(entree: entrees[i]),
        ],
      ],
    );
  }
}

/// Une formation ou une expérience : trait coloré à gauche, puis
/// période, titre, lieu et description, tous alignés à gauche.
class EntreeTile extends StatelessWidget {
  final Entree entree;

  const EntreeTile({super.key, required this.entree});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.only(left: 14),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: accent.withValues(alpha: 0.6), width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entree.periode,
              style: theme.textTheme.bodySmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              entree.titre,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              entree.sousTitre,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white60),
            ),
            if (entree.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                entree.description,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white70, height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
