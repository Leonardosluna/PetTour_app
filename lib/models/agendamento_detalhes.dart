class AgendamentoDetalhes {
  final int id;
  final String data; // Vamos tratar a data como string por simplicidade na exibição
  final String status;
  final String? observacoes;
  final ServicoResumo servico;
  final PetResumo pet;

  AgendamentoDetalhes({
    required this.id,
    required this.data,
    required this.status,
    this.observacoes,
    required this.servico,
    required this.pet,
  });

  factory AgendamentoDetalhes.fromJson(Map<String, dynamic> json) {
    return AgendamentoDetalhes(
      id: json['id'],
      data: json['data'],
      status: json['status'],
      observacoes: json['observacoes'],
      servico: ServicoResumo.fromJson(json['servico']),
      pet: PetResumo.fromJson(json['pet']),
    );
  }
}

class ServicoResumo {
  final String nome;
  final double preco;

  ServicoResumo({required this.nome, required this.preco});

  factory ServicoResumo.fromJson(Map<String, dynamic> json) {
    return ServicoResumo(
      nome: json['nome'],
      preco: (json['preco'] as num).toDouble(),
    );
  }
}

class PetResumo {
  final String nome;
  final String raca;

  PetResumo({required this.nome, required this.raca});

  factory PetResumo.fromJson(Map<String, dynamic> json) {
    return PetResumo(
      nome: json['nome'],
      raca: json['raca'],
    );
  }
}