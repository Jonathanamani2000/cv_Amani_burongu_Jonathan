import 'package:material_ui/material_ui.dart';

/// ============================================================
///  TOUTES LES INFOS PERSONNELLES SONT ICI.
///  Modifie ce fichier pour adapter l'application (textes, photos,
///  famille, contacts). Les pages n'ont pas besoin d'être touchées.
/// ============================================================

class Entree {
  final String titre;
  final String sousTitre;
  final String periode;
  final String description;

  const Entree({
    required this.titre,
    required this.sousTitre,
    required this.periode,
    this.description = '',
  });
}

class ContactInfo {
  final String label;
  final String valeur;
  final IconData icone;

  /// Lien ouvert au clic : tel:, mailto: ou https://
  final String? lien;

  const ContactInfo({
    required this.label,
    required this.valeur,
    required this.icone,
    this.lien,
  });
}

class CvData {
  CvData._();

  // ---- Identité ----
  static const photoMoi = 'assets/images/jonathan.png';
  static const nom = 'Jonathan Burongu';
  static const titre =
      'Étudiant en informatique de gestion · Développeur Flutter & Web · Freelance';
  static const profil =
      'Étudiant en dernière année de licence en informatique de gestion des '
      'entreprises (LIAGE) à l\'ISIGE Goma, passionné par le développement '
      'd\'applications web et mobiles, le design graphique et le motion design. '
      'Je travaille en freelance et je construis mes compétences pour créer '
      'des applications utiles, de la conception jusqu\'au déploiement.';

  // ---- Formation ----
  static const formations = <Entree>[
    Entree(
      titre: 'Licence en informatique de gestion des entreprises (LIAGE)',
      sousTitre: 'ISIGE Goma',
      periode: '3ème année (dernière année)',
      description: 'Informatique de gestion, bases de données, programmation.',
    ),
  ];

  // ---- Expériences (stages, projets, emplois) ----
  static const experiences = <Entree>[
    Entree(
      titre: 'Freelance — Design & création numérique',
      sousTitre: 'Creative Impact, Goma',
      periode: 'En cours',
      description:
          'Conception de visuels, affiches, papeterie et documents administratifs '
          'pour des clients et des événements.',
    ),
    Entree(
      titre: 'Projet : Amani Business',
      sousTitre: 'Application de gestion de business',
      periode: '2026',
      description:
          'Suivi des budgets, des dettes, du capital, des bénéfices et des '
          'entrées quotidiennes.',
    ),
    Entree(
      titre: 'Projet : studios de création',
      sousTitre: 'Affiches de citation, logos de thèmes',
      periode: '2026',
      description:
          'Outils de génération d\'affiches et de logos typographiques pour '
          'des événements.',
    ),
    Entree(
      titre: 'Projet : CV Flutter',
      sousTitre: 'Application mobile (ce projet)',
      periode: 'Novembre 2026',
      description:
          'Application Flutter avec connexion, CV, famille et contact.',
    ),
  ];

  // ---- Compétences ----
  static const competencesTechniques = <String>[
    'Flutter / Dart',
    'JavaScript',
    'React (en apprentissage)',
    'Git & GitHub',
    'Bases de données',
    'Microsoft Office',
    'Outlook & Teams',
    'Design graphique',
    'Motion design (After Effects)',
    'Montage vidéo',
  ];

  static const competencesLinguistiques = <String>[
    'Français · Courant',
    'Swahili · Courant',
    'Anglais · Intermédiaire',
  ];

  // ---- Centres d'intérêt ----
  static const interets = <String>[
    'Développement mobile et web',
    'Design graphique',
    'Motion design',
    'Entrepreneuriat',
    'Création de contenus',
  ];

  // ---- Contacts (valeurs d'exemple : remplace-les par les tiens) ----
  static const contacts = <ContactInfo>[
    ContactInfo(
      label: 'Téléphone',
      valeur: '+243 812 345 678',
      icone: Icons.phone,
      lien: 'tel:+243812345678',
    ),
    ContactInfo(
      label: 'E-mail',
      valeur: 'jonathan.burongu@gmail.com',
      icone: Icons.email,
      lien: 'mailto:jonathan.burongu@gmail.com',
    ),
    ContactInfo(
      label: 'Adresse',
      valeur: 'Goma, Nord-Kivu, RDC',
      icone: Icons.location_on,
      lien: 'https://www.google.com/maps/search/?api=1&query=Goma',
    ),
    ContactInfo(
      label: 'LinkedIn',
      valeur: 'linkedin.com/in/jonathan-burongu',
      icone: Icons.work,
      lien: 'https://www.linkedin.com/in/jonathan-burongu',
    ),
    ContactInfo(
      label: 'GitHub',
      valeur: 'github.com/jonathanburongu',
      icone: Icons.code,
      lien: 'https://github.com/jonathanburongu',
    ),
  ];
}
