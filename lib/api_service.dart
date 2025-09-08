import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/servico.dart';
import 'models/pet.dart';
import 'auth_service.dart';
import 'models/agendamento_detalhes.dart';

class ApiService {
  // ATENÇÃO: Escolha a URL correta para o seu ambiente de teste!
  // Se estiver a usar o Emulador Android:
  static const String _baseUrl = 'http://localhost:8080';
  // Se estiver a usar o Chrome (Web):
  // static const String _baseUrl = 'http://localhost:5000'; // Lembre-se que fixámos a porta 5000 para web

  final AuthService _authService = AuthService();

  // --- MÉTODO AJUDANTE PARA PEGAR O CABEÇALHO DE AUTORIZAÇÃO ---
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Token não encontrado, faça o login novamente.');
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // --- MÉTODOS DE AUTENTICAÇÃO E USUÁRIO ---

  // MÉTODO PARA FAZER LOGIN
  Future<Map<String, dynamic>?> login(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // MÉTODO PARA REGISTRAR UM NOVO USUÁRIO
  Future<bool> registrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String logradouro,
    required String numero,
    String? complemento,
    required String bairro,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/registrar');
    final body = jsonEncode({
      'nome': nome,
      'email': email,
      'senha': senha,
      'logradouro': logradouro,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
    });
    print(">>> [FLUTTER ENVIOU] JSON de Registro: $body");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // MÉTODO PARA ATUALIZAR O PERFIL DO USUÁRIO
  Future<bool> updatePerfil(Map<String, String> dados) async {
    final url = Uri.parse('$_baseUrl/perfil');
    try {
      final response = await http.put(
        url,
        headers: await _getAuthHeaders(),
        body: jsonEncode(dados),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // --- MÉTODOS DE SERVIÇOS ---

  // MÉTODO PARA PEGAR A LISTA DE SERVIÇOS
  Future<List<Servico>> getServicos() async {
    final url = Uri.parse('$_baseUrl/servicos');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return jsonList.map((json) => Servico.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar os serviços.');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // --- MÉTODOS DE PETS ---

  // MÉTODO PARA PEGAR A LISTA DE PETS DO USUÁRIO LOGADO
  Future<List<Pet>> getMeusPets() async {
    final url = Uri.parse('$_baseUrl/perfil/pets');
    try {
      final response = await http.get(url, headers: await _getAuthHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return jsonList.map((json) => Pet.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar os pets.');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // MÉTODO PARA CRIAR UM NOVO PET PARA O USUÁRIO LOGADO
  Future<Pet?> createPet(String nome, String raca, String? fotoUrl) async {
    final url = Uri.parse('$_baseUrl/perfil/pets');
    try {
      final response = await http.post(
        url,
        headers: await _getAuthHeaders(),
        body: jsonEncode({'nome': nome, 'raca': raca, 'fotoUrl': fotoUrl}),
      );
      if (response.statusCode == 201) {
        return Pet.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // MÉTODO PARA ATUALIZAR UM PET
  Future<Pet?> updatePet(
    int id,
    String nome,
    String raca,
    String? fotoUrl,
  ) async {
    final url = Uri.parse('$_baseUrl/perfil/pets/$id');
    try {
      final response = await http.put(
        url,
        headers: await _getAuthHeaders(),
        body: jsonEncode({'nome': nome, 'raca': raca, 'fotoUrl': fotoUrl}),
      );
      if (response.statusCode == 200) {
        return Pet.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // MÉTODO PARA DELETAR UM PET
  Future<bool> deletePet(int id) async {
    final url = Uri.parse('$_baseUrl/perfil/pets/$id');
    try {
      final response = await http.delete(url, headers: await _getAuthHeaders());
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  // --- MÉTODOS PARA AGENDAMENTO ---

  // Método para buscar os horários disponíveis para uma data específica
  Future<List<String>> getHorariosDisponiveis(DateTime data) async {
    final String dataFormatada =
        "${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";
    final url = Uri.parse(
      '$_baseUrl/agendamentos/horarios-disponiveis?data=$dataFormatada',
    );
    try {
      final response = await http.get(url, headers: await _getAuthHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.cast<String>();
      } else {
        throw Exception('Falha ao buscar horários.');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Método para criar um novo agendamento
  Future<bool> criarAgendamento({
    required int idServico,
    required int idPet,
    required DateTime data,
    String? observacoes,
  }) async {
    final url = Uri.parse('$_baseUrl/agendamentos');
    final String dataFormatada =
        "${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}T"
        "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}:00";
    try {
      final response = await http.post(
        url,
        headers: await _getAuthHeaders(),
        body: jsonEncode({
          'idServico': idServico,
          'idPet': idPet,
          'data': dataFormatada,
          'observacoes': observacoes ?? '',
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao criar agendamento: $e');
      return false;
    }
  }

  // Método para buscar a lista de agendamentos do utilizador logado
  Future<List<AgendamentoDetalhes>> getMeusAgendamentos() async {
    final url = Uri.parse('$_baseUrl/agendamentos');
    try {
      final response = await http.get(url, headers: await _getAuthHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return jsonList
            .map((json) => AgendamentoDetalhes.fromJson(json))
            .toList();
      } else {
        throw Exception('Falha ao carregar os agendamentos.');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Método para cancelar um agendamento
  Future<bool> cancelarAgendamento(int id) async {
    final url = Uri.parse('$_baseUrl/agendamentos/$id/cancelar');
    try {
      final response = await http.patch(url, headers: await _getAuthHeaders());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
