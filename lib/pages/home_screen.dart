import 'package:flutter/material.dart';
import '../api_service.dart';
import '../auth_service.dart';
import '../models/servico.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'service_detail_screen.dart';
import 'my_appointments_screen.dart';
import 'my_pets_screen.dart';
import '../utils/image_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Servico>> _servicosFuture;
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService(); // Instância do AuthService

  // Variáveis para guardar o estado de login
  bool _isLoggedIn = false;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _servicosFuture = _apiService.getServicos();
    _checkLoginStatus(); // Verifica o status de login ao iniciar a tela
  }

  // Método para verificar se o usuário está logado e buscar seus dados
  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn && mounted) {
      final userData = await _authService.getUserData();
      setState(() {
        _isLoggedIn = true;
        _userName = userData['nome'] ?? '';
      });
    } else if (mounted) {
      setState(() {
        _isLoggedIn = false;
        _userName = '';
      });
    }
  }

  // Método para lidar com o logout a partir do menu
  void _handleLogout() async {
    await _authService.logout();
    _checkLoginStatus(); // Atualiza a interface para o estado "deslogado"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Adiciona um espaço customizado para o logo
        toolbarHeight: 90,
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ), // Adiciona um pequeno espaçamento
          child: Image.asset(
            'assets/images/logo.png', // Caminho para o seu logo
            fit: BoxFit.contain,
          ),
        ),
        // O título agora mostra uma mensagem de boas-vindas se o usuário estiver logado
        title: Text(_isLoggedIn ? 'Bem-vindo, $_userName!' : 'PetTour'),
        centerTitle: true,

        // A cor do texto e dos ícones da AppBar
        titleTextStyle: const TextStyle(
          color: Colors.white, // Cor do texto do título
          fontSize: 20, // Tamanho da fonte do título
          fontWeight: FontWeight.bold,
          shadows: <Shadow>[
            // Lista de sombras
            Shadow(
              offset: Offset(3, 3), // Posição da sombra (horizontal, vertical)
              blurRadius: 10.0, // Nível de desfoque da sombra
              color: Colors.black54, // Cor da sombra
            ),
          ],
        ),
        // flexibleSpace para criar o fundo em degradê
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
          // Lógica condicional para o botão de perfil/login
          _isLoggedIn
              ? PopupMenuButton<String>(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: const [
                        Icon(Icons.person, size: 35, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Área do Cliente",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'perfil') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      ).then((_) => _checkLoginStatus());
                    } else if (value == 'pets') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyPetsScreen(),
                        ),
                      );
                    } else if (value == 'agendamentos') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAppointmentsScreen(),
                        ),
                      );
                    } else if (value == 'logout') {
                      _handleLogout();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        enabled: false,
                        child: Text(
                          'Área do Cliente',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'perfil',
                        child: Text('Meu Perfil'),
                      ),
                      const PopupMenuItem(
                        value: 'pets',
                        child: Text('Meus Pets'),
                      ),
                      const PopupMenuItem(
                        value: 'agendamentos',
                        child: Text('Meus Agendamentos'),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Sair (Logout)'),
                      ),
                    ];
                  },
                )
              : InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ).then((_) => _checkLoginStatus());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: const [
                        Icon(Icons.person, size: 35, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Login / Cadastro",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // WIDGET DO BANNER
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'assets/images/banner.png', // Verifique se o nome do seu ficheiro está correto
                    width: double.infinity,
                    height: isMobile ? 180 : 300, // Altura responsiva
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                  child: Text(
                    'Nossos Serviços',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // LISTA DE SERVIÇOS
              Expanded(
                // Expanded é crucial para que a lista ocupe o resto do espaço
                child: FutureBuilder<List<Servico>>(
                  future: _servicosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar serviços: ${snapshot.error}',
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Nenhum serviço encontrado.'),
                      );
                    }
                    final servicos = snapshot.data!;

                    if (isMobile) {
                      // LAYOUT PARA TELAS ESTREITAS (LISTA VERTICAL)
                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 16,
                        ),
                        itemCount: servicos.length,
                        itemBuilder: (context, index) {
                          final servico = servicos[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceDetailScreen(servico: servico),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    getImagemParaServico(servico.nome),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  // Usando ListTile para melhor gestão do espaço e evitar overflow
                                  ListTile(
                                    title: Text(
                                      servico.nome,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          servico.descricao,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Ver mais...',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      'R\$ ${servico.preco.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      // LAYOUT PARA TELAS LARGAS (GRELHA)
                      return Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 1400),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(24.0),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 400.0,
                                  childAspectRatio:
                                      0.9, // Altura maior que a largura
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                ),
                            itemCount: servicos.length,
                            itemBuilder: (context, index) {
                              final servico = servicos[index];
                              return Card(
                                margin: EdgeInsets.zero,
                                elevation: 4,
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceDetailScreen(
                                              servico: servico,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // A imagem ocupa o espaço que sobrar no topo
                                      Expanded(
                                        child: Image.asset(
                                          getImagemParaServico(servico.nome),
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // O conteúdo de texto tem uma altura previsível em baixo
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              servico.nome,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              servico.descricao,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Ver mais...',
                                                  style: TextStyle(
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'R\$ ${servico.preco.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 50, // Altura do footer
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            // A mesma paleta de cores da AppBar
            colors: [Colors.orange, Colors.cyan, Colors.orange],

            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: const Center(
          child: Text(
            '© 2025 PetTour - Todos os direitos reservados',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
