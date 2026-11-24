class FamilleMembre {
  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  const FamilleMembre({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  factory FamilleMembre.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse(json['id'].toString());
    if (id == null) {
      throw const FormatException('Identifiant de membre invalide.');
    }

    return FamilleMembre(
      id: id,
      nom: _stringField(json, 'nom'),
      postnom: _stringField(json, 'postnom'),
      prenom: _stringField(json, 'prenom'),
      lieuNaissance: _stringField(json, 'lieu_naissance'),
      dateNaissance: _stringField(json, 'date_naissance'),
      parente: _stringField(json, 'parente'),
      imageUrl: json['image_url'] as String?,
    );
  }

  static String _stringField(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String) {
      throw FormatException('Champ "$key" invalide dans la réponse API.');
    }
    return value;
  }
}
