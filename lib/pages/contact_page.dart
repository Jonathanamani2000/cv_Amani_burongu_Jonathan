import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/cv_data.dart';
import '../widgets/glass_card.dart';

/// Page 4 : coordonnées. Chaque contact est cliquable
/// (appel, e-mail, carte, liens web).
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _ouvrir(BuildContext context, String lien) async {
    final messenger = ScaffoldMessenger.of(context);
    var ok = false;
    try {
      ok = await launchUrl(Uri.parse(lien), mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir ce lien sur cet appareil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Me contacter',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Touchez une ligne pour appeler, écrire ou ouvrir le lien.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white60),
              ),
            ],
          ),
        ),
        for (final c in CvData.contacts)
          GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: ListTile(
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(c.icone, size: 22, color: accent),
              ),
              // Petit libellé gris, puis la valeur en plus grand.
              title: Text(
                c.label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.white54),
              ),
              subtitle: Text(
                c.valeur,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
              trailing: c.lien == null
                  ? null
                  : const Icon(Icons.chevron_right, color: Colors.white38),
              onTap: c.lien == null ? null : () => _ouvrir(context, c.lien!),
            ),
          ),
      ],
    );
  }
}
