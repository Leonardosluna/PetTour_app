import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/agendamento_detalhes.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  late Future<List<AgendamentoDetalhes>> _appointmentsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _refreshAppointments();
  }

  // Método para (re)buscar a lista de agendamentos
  void _refreshAppointments() {
    setState(() {
      _appointmentsFuture = _apiService.getMeusAgendamentos();
    });
  }

  // Lógica para mostrar o diálogo de confirmação antes de cancelar
  void _showCancelConfirmationDialog(AgendamentoDetalhes appointment) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Cancelamento'),
          content: Text(
            'Tem a certeza de que quer cancelar o serviço "${appointment.servico.nome}" para o pet "${appointment.pet.nome}"?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Apenas fecha o diálogo
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Sim, Cancelar',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Fecha o diálogo primeiro
                final success = await _apiService.cancelarAgendamento(
                  appointment.id,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Agendamento cancelado com sucesso!'
                            : 'Falha ao cancelar.',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                  if (success) {
                    _refreshAppointments(); // Atualiza a lista
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus Agendamentos',
          style: TextStyle(color: Colors.white),
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
      // --- ESTRUTURA DE RESPONSIVIDADE ADICIONADA ---
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ), // Largura máxima da lista
          child: FutureBuilder<List<AgendamentoDetalhes>>(
            future: _appointmentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar agendamentos: ${snapshot.error}',
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Você não tem nenhum agendamento.'),
                );
              }
              final appointments = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  final isCancelled = appointment.status == 'CANCELADO';
                  final isConcluded = appointment.status == 'CONCLUIDO';
                  final canCancel = !(isCancelled || isConcluded);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    color: isCancelled || isConcluded
                        ? Colors.grey.shade300
                        : Colors.white,
                    child: ListTile(
                      title: Text(
                        appointment.servico.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pet: ${appointment.pet.nome}'),
                          Text('Data: ${appointment.data}'),
                          Text(
                            'Status: ${appointment.status}',
                            style: TextStyle(
                              color: isCancelled
                                  ? Colors.red
                                  : (isConcluded
                                        ? Colors.green
                                        : Colors.orange),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: canCancel
                          ? TextButton(
                              onPressed: () =>
                                  _showCancelConfirmationDialog(appointment),
                              child: const Text('Cancelar'),
                            )
                          : null, // Não mostra botão se já estiver cancelado ou concluído
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
