import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'edit_profile_screen.dart';
import 'my_appointments_screen.dart';
import 'my_pets_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  String _userName = 'A carregar...';
  String _userPhotoUrl = ''; // Variável para a foto
  String _logradouro = '';
  String _numero = '';
  String _complemento = '';
  String _bairro = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para carregar os dados do utilizador guardados no dispositivo
  Future<void> _loadUserData() async {
    final userData = await _authService.getUserData();
    if (mounted) {
      setState(() {
        _userName = userData['nome'] ?? 'Nome não encontrado';
        _userPhotoUrl = userData['fotoUrl'] ?? '';
        _logradouro = userData['logradouro'] ?? 'Endereço não informado';
        _numero = userData['numero'] ?? '';
        _complemento = userData['complemento'] ?? '';
        _bairro = userData['bairro'] ?? '';
      });
    }
  }

  // Método para lidar com o clique no botão de logout
  void _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      // Volta para a HomeScreen e a força a reconstruir seu estado
      // O popUntil garante que voltamos até a primeira tela da pilha
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 30, color: Colors.white,),
            onPressed: () {
              // Navega para a tela de edição e atualiza os dados quando voltar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              ).then((result) {
                // Se a tela de edição indicar que houve sucesso (retornando true),
                // recarregamos os dados do perfil para mostrar as alterações.
                if (result == true) {
                  _loadUserData();
                }
              });
            },
          ),
        ],
      ),
      // --- ESTRUTURA DE RESPONSIVIDADE ADICIONADA ---
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            // Permite rolar a tela
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 30.0,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centraliza os itens principais
              children: [
                // Avatar (pode ser a foto no futuro)
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _userPhotoUrl.isNotEmpty
                      ? NetworkImage(_userPhotoUrl)
                      : null,
                  child: _userPhotoUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.deepPurple,
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                // Informações do Usuário
                Text(
                  _userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Secção de Endereço
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Meu Endereço',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 16),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'RUA: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _logradouro,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'NÚMERO: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(_numero, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'COMPLEMENTO: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            _complemento,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            'BAIRRO: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(_bairro, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Botões de Ação
                ElevatedButton.icon(
                  icon: const Icon(Icons.pets),
                  label: const Text('Meus Pets'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPetsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ), // Faz o botão ocupar a largura toda
                    alignment:
                        Alignment.centerLeft, // Alinha o conteúdo à esquerda
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Meus Agendamentos'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyAppointmentsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),

                const SizedBox(height: 50),

                // Botão de Logout
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair (Logout)'),
                  onPressed: _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
