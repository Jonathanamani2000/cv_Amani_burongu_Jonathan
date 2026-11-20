import 'package:flutter/material.dart';

import '../data/cv_data.dart';
import '../widgets/glass_card.dart';
import '../widgets/pastille.dart';
import '../widgets/photo_avatar.dart';

/// Page 3 : famille, affichée avec un ListView de cartes glass.
class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      itemCount: CvData.famille.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final m = CvData.famille[i];
        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PhotoAvatar(asset: m.photo, radius: 34),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.nom,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Pastille(m.lien),
                    // La profession n'est affichée que si elle est renseignée.
                    if (m.profession.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        m.profession,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white60),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
