import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/pet.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  late Future<List<Pet>> _petsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _refreshPets();
  }

  void _refreshPets() {
    setState(() {
      _petsFuture = _apiService.getMeusPets();
    });
  }

  // --- LÓGICA PARA ADICIONAR/EDITAR PET ---
  void _showPetDialog({Pet? pet}) {
    final isEditing = pet != null;
    final nameController = TextEditingController(text: pet?.nome ?? '');
    final breedController = TextEditingController(text: pet?.raca ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Pet' : 'Adicionar Novo Pet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome do Pet'),
              ),
              TextField(
                controller: breedController,
                decoration: const InputDecoration(labelText: 'Raça'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (isEditing) {
                  await _apiService.updatePet(
                    pet.id,
                    nameController.text,
                    breedController.text,
                    pet.fotoUrl,
                  );
                } else {
                  await _apiService.createPet(
                    nameController.text,
                    breedController.text,
                    null,
                  );
                }
                Navigator.pop(context);
                _refreshPets(); // Atualiza a lista
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // --- LÓGICA PARA CONFIRMAR DELEÇÃO ---
  void _showDeleteConfirmationDialog(Pet pet) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text(
            'Tem a certeza de que quer excluir o pet ${pet.nome}? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final success = await _apiService.deletePet(pet.id);
                Navigator.pop(context);
                if (success) {
                  _refreshPets(); // Atualiza a lista
                }
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.white),
              ),
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
        title: const Text('Meus Pets', style: TextStyle(color: Colors.white)),
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: FutureBuilder<List<Pet>>(
            future: _petsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro ao carregar pets: ${snapshot.error}'),
                );
              }
              // --- LÓGICA ATUALIZADA PARA A TELA VAZIA ---
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.pets, size: 80, color: Colors.grey),
                        const SizedBox(height: 24),
                        const Text(
                          'Cadastre seu Pet.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Cadastrar Novo Pet'),
                          onPressed: () => _showPetDialog(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              // Se a lista não está vazia, mostra a ListView
              final pets = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.pets)),
                      title: Text(pet.nome),
                      subtitle: Text(pet.raca),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showPetDialog(pet: pet),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmationDialog(pet),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      // O botão flutuante agora só aparece se a lista NÃO estiver vazia
      floatingActionButton: FutureBuilder<List<Pet>>(
        future: _petsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () => _showPetDialog(),
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink(); // Retorna um widget vazio se a lista estiver vazia
        },
      ),
    );
  }
}
