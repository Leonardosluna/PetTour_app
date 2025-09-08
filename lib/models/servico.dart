class Servico {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String contato;

  // Construtor padrão da classe
  Servico({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.contato,
  });

  // Um "construtor de fábrica" para criar uma instância de Servico a partir de um JSON.
  // É o "tradutor" de JSON para um objeto Dart.
  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      // Convertemos o preço para double, pois JSON não tem tipo BigDecimal
      preco: (json['preco'] as num).toDouble(), 
      contato: json['contato'],
    );
  }
}