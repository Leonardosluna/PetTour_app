class Pet {
  final int id;
  final String nome;
  final String raca;
  final String? fotoUrl; // Pode ser nulo

  Pet({
    required this.id,
    required this.nome,
    required this.raca,
    this.fotoUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      nome: json['nome'],
      raca: json['raca'],
      fotoUrl: json['fotoUrl'],
    );
  }
}