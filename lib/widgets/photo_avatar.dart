import 'package:material_ui/material_ui.dart';

/// Photo ronde chargée depuis les assets, avec un fin cadre blanc.
/// Si le fichier n'existe pas, une icône est affichée à la place.
class PhotoAvatar extends StatelessWidget {
  final String asset;
  final double radius;
  final IconData fallback;

  const PhotoAvatar({
    super.key,
    required this.asset,
    this.radius = 32,
    this.fallback = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
      ),
      child: ClipOval(
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.white12,
              child: Icon(fallback, size: radius, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
