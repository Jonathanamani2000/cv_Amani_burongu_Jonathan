# cv_flutter_jonathan

Application mobile Flutter qui présente le CV, la famille et les coordonnées de **Jonathan Burongu**.
L'accès à l'application se fait par une page de connexion.

## Fonctionnalités

- **Page 1 : Connexion** : identifiant, mot de passe masqué (avec bouton œil) et bouton « Se connecter ».
- **Page 2 : Accueil (CV)** : photo, nom, profil, formation, expériences et projets, compétences techniques, langues et centres d'intérêt.
- **Page 3 : Famille** : liste de cartes (`ListView` + `Card`) avec photo, nom, lien de parenté et profession.
- **Page 4 : Contact** : téléphone, e-mail, adresse, LinkedIn et GitHub, tous cliquables (appel, e-mail, carte, liens web).
- **Navigation** : `BottomNavigationBar` après la connexion, avec un bouton de déconnexion.
- **Design** : design minimaliste (noir, blanc, gris) avec un effet *glass* (verre dépoli) discret grâce à `BackdropFilter`.

## Identifiants de test

| Identifiant | Mot de passe |
|-------------|--------------|
| `jonathan`  | `flutter2026` |

## Captures d'écran

### 1. Page de connexion
![Page de connexion](docs/screenshots/01_connexion.png)

### 2. Page d'accueil (CV)
![Page d'accueil](docs/screenshots/02_accueil.png)

### 3. Page famille
![Page famille](docs/screenshots/03_famille.png)

### 4. Page contact
![Page contact](docs/screenshots/04_contact.png)

## Lancer le projet

```bash
flutter pub get
flutter run -d chrome   # ou : flutter run (téléphone Android branché)
```

## Structure

```
lib/
├── main.dart                 # point d'entrée et thème sombre
├── data/cv_data.dart         # toutes les données personnelles
├── pages/
│   ├── login_page.dart       # page 1
│   ├── main_shell.dart       # navigation (BottomNavigationBar)
│   ├── home_page.dart        # page 2
│   ├── famille_page.dart     # page 3
│   └── contact_page.dart     # page 4
└── widgets/
    ├── fond_glass.dart       # fond dégradé
    ├── glass_card.dart       # carte effet verre
    ├── photo_avatar.dart
    └── section_card.dart
```

## Technologies

Flutter, Dart, Material 3, `url_launcher`, effet glass (`BackdropFilter`).
