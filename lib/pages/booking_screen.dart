import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/pet.dart';
import '../models/servico.dart';
import 'my_pets_screen.dart';

class BookingScreen extends StatefulWidget {
  final Servico servico; // A tela recebe o serviço que foi selecionado

  const BookingScreen({super.key, required this.servico});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ApiService _apiService = ApiService();

  // Variáveis para guardar o estado da tela
  List<Pet> _meusPets = [];
  Pet? _petSelecionado;
  DateTime? _dataSelecionada;
  List<String> _horariosDisponiveis = [];
  String? _horarioSelecionado;
  bool _isLoading = true;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _fetchMeusPets(); // Busca os pets do usuário ao iniciar a tela
  }

  // Busca a lista de pets do usuário
  Future<void> _fetchMeusPets() async {
    // Garante que a tela mostre o loading ao re-buscar os pets
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final pets = await _apiService.getMeusPets();
      if (mounted) {
        setState(() {
          _meusPets = pets;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao buscar pets: $e')));
      }
    }
  }

  // Busca os horários disponíveis para uma data
  Future<void> _fetchHorarios(DateTime data) async {
    setState(() {
      _dataSelecionada = data;
      _horariosDisponiveis = []; // Limpa os horários antigos
      _horarioSelecionado = null; // Limpa a seleção
      _isLoading = true;
    });

    try {
      final horarios = await _apiService.getHorariosDisponiveis(data);
      if (mounted) {
        setState(() {
          _horariosDisponiveis = horarios;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao buscar horários: $e')));
      }
    }
  }

  // Finaliza o agendamento
  void _handleAgendamento() async {
    if (_petSelecionado == null ||
        _dataSelecionada == null ||
        _horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione o pet, a data e o horário.'),
        ),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    // Combina a data e o horário selecionados
    final parts = _horarioSelecionado!.split(':');
    final dataFinal = DateTime(
      _dataSelecionada!.year,
      _dataSelecionada!.month,
      _dataSelecionada!.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    final success = await _apiService.criarAgendamento(
      idServico: widget.servico.id,
      idPet: _petSelecionado!.id,
      data: dataFinal,
    );
    setState(() {
      _isBooking = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Agendamento realizado com sucesso!'
                : 'Falha ao agendar. Tente outro horário.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {
        Navigator.of(
          context,
        ).popUntil((route) => route.isFirst); // Volta para a HomeScreen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agendar ${widget.servico.nome}',
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white, // Cor inicial (esquerda)
                Colors.cyan, // Cor do meio (azul turquesa)
                Colors.orange, // Cor final (direita)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading && _meusPets.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _meusPets
                .isEmpty // VERIFICA SE A LISTA DE PETS ESTÁ VAZIA
          // SE ESTIVER VAZIA, MOSTRA A MENSAGEM E O BOTÃO
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pets, size: 80, color: Colors.grey),
                    const SizedBox(height: 24),
                    const Text(
                      'Nenhum pet cadastrado!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Você precisa de ter um pet cadastrado para poder solicitar um agendamento.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Cadastrar Meu Pet'),
                      onPressed: () {
                        // Navega para a tela de pets e, quando voltar, re-busca a lista
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyPetsScreen(),
                          ),
                        ).then((_) => _fetchMeusPets());
                      },
                    ),
                  ],
                ),
              ),
            )
          // SE NÃO ESTIVER VAZIA, MOSTRA O FORMULÁRIO NORMAL
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Seleção do Pet
                      const Text(
                        '1. Selecione o seu Pet:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Pet>(
                        value: _petSelecionado,
                        hint: const Text('Escolha um pet'),
                        isExpanded: true,
                        items: _meusPets.map((pet) {
                          return DropdownMenuItem(
                            value: pet,
                            child: Text(pet.nome),
                          );
                        }).toList(),
                        onChanged: (pet) =>
                            setState(() => _petSelecionado = pet),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Seleção da Data
                      const Text(
                        '2. Escolha uma data:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _dataSelecionada == null
                              ? 'Selecionar Data'
                              : "${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}",
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          final data = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            firstDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 90),
                            ),
                            locale: const Locale('pt', 'BR'),
                          );
                          if (data != null) {
                            _fetchHorarios(data);
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // 3. Seleção do Horário
                      if (_dataSelecionada != null) ...[
                        const Text(
                          '3. Escolha um horário disponível:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _horariosDisponiveis.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Nenhum horário disponível para esta data.',
                                  ),
                                ),
                              )
                            : Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _horariosDisponiveis.map((horario) {
                                  final isSelected =
                                      _horarioSelecionado == horario;
                                  return ChoiceChip(
                                    label: Text(horario.substring(0, 5)),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setState(
                                        () => _horarioSelecionado = horario,
                                      );
                                    },
                                    selectedColor: Colors.deepPurple,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar:
          _meusPets
              .isEmpty // Também esconde o botão de confirmar
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isBooking
                  ? const Center(
                      heightFactor: 1,
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: _handleAgendamento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Confirmar Agendamento'),
                    ),
            ),
    );
  }
}
