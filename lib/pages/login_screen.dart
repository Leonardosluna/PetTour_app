import 'package:flutter/material.dart';
import '../api_service.dart';
import '../auth_service.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Instâncias dos nossos serviços
  final _apiService = ApiService();
  final _authService = AuthService();
  bool _isLoading = false; // Variável para controlar o estado de carregamento

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      }); // Ativa o indicador de carregamento

      final email = _emailController.text;
      final senha = _passwordController.text;

      final result = await _apiService.login(email, senha);

      setState(() {
        _isLoading = false;
      }); // Desativa o indicador de carregamento

      if (result != null) {
        await _authService.saveSession(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              
  
              content: Text('Login realizado com sucesso!'),
              
              backgroundColor: Colors.green,
              
            ),
          );
          // Volta para a tela anterior (HomeScreen)
        
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email ou senha inválidos.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
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
        // Centraliza o conteúdo na tela
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400, // Define a largura máxima do formulário
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          (value == null || !value.contains('@'))
                          ? 'Por favor, insira um email válido'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Por favor, insira sua senha'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    // Botão com indicador de carregamento
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Entrar'),
                          ),
                    const SizedBox(height: 20),
                    const Center(child: Text("Ainda não tem conta?")),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // Navega para a tela de cadastro
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text('Faça seu cadastro'),
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
