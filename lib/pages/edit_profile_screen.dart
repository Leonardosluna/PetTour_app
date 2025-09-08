import 'package:flutter/material.dart';
import '../api_service.dart';
import '../auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _authService = AuthService();
  bool _isLoading = false;

  // Controladores para todos os campos
  final _nameController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _fotoUrlController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Carrega os dados atuais do utilizador para pré-preencher o formulário
  Future<void> _loadUserData() async {
    final userData = await _authService.getUserData();
    if (mounted) {
      _nameController.text = userData['nome'] ?? '';
      _telefoneController.text = userData['telefone'] ?? '';
      _fotoUrlController.text = userData['fotoUrl'] ?? '';
      _logradouroController.text = userData['logradouro'] ?? '';
      _numeroController.text = userData['numero'] ?? '';
      _complementoController.text = userData['complemento'] ?? '';
      _bairroController.text = userData['bairro'] ?? '';
    }
  }

  // Lógica para salvar as alterações
  void _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> dados = {
        "nome": _nameController.text,
        "telefone": _telefoneController.text,
        "fotoUrl": _fotoUrlController.text,
        "logradouro": _logradouroController.text,
        "numero": _numeroController.text,
        "complemento": _complementoController.text,
        "bairro": _bairroController.text,
      };

      final success = await _apiService.updatePerfil(dados);
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Perfil atualizado com sucesso!'
                  : 'Falha ao atualizar o perfil.',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) {
          Navigator.pop(
            context,
            true,
          ); // Retorna 'true' para indicar que houve atualização
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
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
            maxWidth: 500,
          ), // Define a largura máxima do formulário
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Dados Pessoais',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fotoUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL da Foto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Endereço',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _logradouroController,
                    decoration: const InputDecoration(
                      labelText: 'Rua / Logradouro',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _numeroController,
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _complementoController,
                    decoration: const InputDecoration(
                      labelText: 'Complemento',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _bairroController,
                    decoration: const InputDecoration(
                      labelText: 'Bairro',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleUpdate,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Salvar Alterações'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
