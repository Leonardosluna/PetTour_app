import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/servico.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  late Future<List<Servico>> _servicosFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _refreshServices();
  }

  void _refreshServices() {
    setState(() {
      _servicosFuture = _apiService.getServicos();
    });
  }

  // Diálogo para Adicionar ou Editar um Serviço
  void _showServiceDialog({Servico? servico}) {
    final isEditing = servico != null;
    final nameController = TextEditingController(text: servico?.nome ?? '');
    final descriptionController = TextEditingController(text: servico?.descricao ?? '');
    final priceController = TextEditingController(text: servico?.preco.toString() ?? '');
    final contactController = TextEditingController(text: servico?.contato ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Serviço' : 'Adicionar Novo Serviço'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome do Serviço')),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Descrição')),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Preço'), keyboardType: TextInputType.number),
                TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contato')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                final nome = nameController.text;
                final descricao = descriptionController.text;
                final preco = double.tryParse(priceController.text) ?? 0.0;
                final contato = contactController.text;

                if (isEditing) {
                  await _apiService.updateServico(servico.id, nome, descricao, preco, contato);
                } else {
                  await _apiService.createServico(nome, descricao, preco, contato);
                }
                Navigator.pop(context);
                _refreshServices();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Diálogo para confirmar a exclusão
  void _showDeleteConfirmationDialog(Servico servico) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem a certeza de que quer excluir o serviço "${servico.nome}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final success = await _apiService.deleteServico(servico.id);
                Navigator.pop(context);
                if (success) {
                  _refreshServices();
                }
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerir Serviços')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: FutureBuilder<List<Servico>>(
            future: _servicosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar serviços: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhum serviço cadastrado.'));
              }
              final servicos = snapshot.data!;
              return ListView.builder(
                itemCount: servicos.length,
                itemBuilder: (context, index) {
                  final servico = servicos[index];
                  return ListTile(
                    leading: const Icon(Icons.miscellaneous_services),
                    title: Text(servico.nome),
                    subtitle: Text('R\$ ${servico.preco.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showServiceDialog(servico: servico)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _showDeleteConfirmationDialog(servico)),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showServiceDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}