import 'package:flutter/material.dart';
import '../api_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Controladores para pegar o texto dos campos
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _logradouroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();

  // Chave para validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Instância do nosso serviço de API
  final _apiService = ApiService();
  bool _isLoading = false;

  // Método para lidar com o clique no botão de registrar
  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      final success = await _apiService.registrarUsuario(
        nome: _nameController.text,
        email: _emailController.text,
        senha: _passwordController.text,
        logradouro: _logradouroController.text,
        numero: _numeroController.text,
        complemento: _complementoController.text,
        bairro: _bairroController.text,
      );

      setState(() { _isLoading = false; });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Cadastro realizado com sucesso! Pode fazer o login.' : 'Falha no cadastro. Verifique os dados ou o console.'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) {
          // Se o cadastro for bem-sucedido, fecha a tela e volta para a de Login
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crie a sua Conta'),
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
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500, // Largura máxima do formulário
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Dados Pessoais',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nome Completo', border: OutlineInputBorder()),
                      validator: (value) => (value == null || value.isEmpty) ? 'Por favor, insira seu nome' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || !value.contains('@')) ? 'Por favor, insira um email válido' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 6) ? 'A senha deve ter no mínimo 6 caracteres' : null,
                    ),
                    const SizedBox(height: 24),
                    const Text('Endereço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _logradouroController,
                      decoration: const InputDecoration(labelText: 'Rua / Logradouro', border: OutlineInputBorder()),
                      validator: (value) => (value == null || value.isEmpty) ? 'Por favor, insira a sua rua' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _numeroController,
                            decoration: const InputDecoration(labelText: 'Número', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (value) => (value == null || value.isEmpty) ? 'Insira o nº' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _complementoController,
                            decoration: const InputDecoration(labelText: 'Complemento', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bairroController,
                      decoration: const InputDecoration(labelText: 'Bairro', border: OutlineInputBorder()),
                      validator: (value) => (value == null || value.isEmpty) ? 'Por favor, insira o seu bairro' : null,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _handleRegister,
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                            child: const Text('Finalizar Cadastro'),
                          ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Apenas fecha a tela de cadastro e volta para a anterior (Login)
                        Navigator.pop(context);
                      },
                      child: const Text('Já tem uma conta? Faça login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}