# CV Jonathan Burongu

Application Flutter présentant le CV et les coordonnées de **Jonathan Burongu**. La connexion et la gestion des membres de famille utilisent l'API REST [api-test](https://github.com/espoirbaraka/api-test).

## Fonctionnalités

- **Authentification réelle** : création de compte et connexion vérifiées par l'API.
- **CV** : profil, formation, expériences, compétences et centres d'intérêt.
- **Famille** : consultation, ajout, modification et suppression des membres enregistrés dans la base de données de l'API.
- **Contact** : téléphone, e-mail, adresse, LinkedIn et GitHub.
- **Navigation** : barre de navigation et déconnexion.

## Démonstration vidéo

La vidéo présente le lancement de l'application et sa démonstration :

[▶ Regarder ou télécharger la vidéo de démonstration](docs/demo-tp2.mp4)

## Configuration de l'API

1. Installer et démarrer l'API selon son [README](https://github.com/espoirbaraka/api-test#installation) (Apache et MySQL/XAMPP).
2. Créer et importer la base de données `api` avec le fichier `api.sql`, puis configurer le fichier `.env` de l'API.
3. Vérifier que l'API est accessible à l'adresse `http://localhost/api-test/public`.
4. Installer les dépendances Flutter :

   ```bash
   flutter pub get
   ```

5. Lancer l'application en précisant l'adresse de l'API :

   ```bash
   # Navigateur sur le même ordinateur
   flutter run -d chrome --dart-define=API_BASE_URL=http://localhost/api-test/public

   # Émulateur Android
   flutter run --dart-define=API_BASE_URL=http://10.0.2.2/api-test/public
   ```

   Sur un téléphone physique, remplacer `localhost` par l'adresse IP locale de l'ordinateur hébergeant XAMPP, et s'assurer que le téléphone peut joindre cet ordinateur sur le réseau.

L'adresse par défaut est `http://localhost/api-test/public`. Pour un déploiement, utiliser une adresse HTTPS et la fournir avec `--dart-define=API_BASE_URL=...`.

La connexion utilise `POST /accounts/login` et l'inscription utilise `POST /accounts/register`. Les opérations de famille utilisent `GET`, `POST`, `PUT` et `DELETE` sur `/famille-membres`. Les membres sont stockés par l'API dans sa base de données, pas dans l'application.

**Limite de l'API fournie :** selon sa documentation, les endpoints des membres ne demandent pas d'authentification et la connexion ne délivre pas de jeton. L'application vérifie bien l'identifiant et le mot de passe auprès du serveur et masque ses pages avant connexion, mais l'API elle-même n'empêche pas un appel direct aux endpoints famille.

## Structure

```text
lib/
├── main.dart
├── data/
│   ├── cv_data.dart
│   └── famille_membre.dart
├── pages/
│   ├── login_page.dart
│   ├── main_shell.dart
│   ├── home_page.dart
│   ├── famille_page.dart
│   └── contact_page.dart
├── services/
│   └── api_service.dart
└── widgets/
```

## Technologies

Flutter, Dart, Material 3, `http`, `url_launcher` et API REST PHP/MySQL.

## Tests

```bash
flutter test
flutter analyze
```
