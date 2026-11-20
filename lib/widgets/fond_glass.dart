import 'package:material_ui/material_ui.dart';

/// Fond minimaliste : un dégradé noir/gris très doux, avec une seule
/// tache de lumière grise (juste assez pour que l'effet glass se voie).
class FondGlass extends StatelessWidget {
  final Widget child;

  const FondGlass({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF17181C), Color(0xFF0C0D10)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8A94A6).withValues(alpha: 0.28),
                    const Color(0xFF8A94A6).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
