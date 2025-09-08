import 'package:flutter/material.dart';
import '../models/servico.dart'; // Importa nosso modelo
import 'booking_screen.dart'; // Importa a tela de agendamento
import '../utils/image_helper.dart'; // <-- 1. IMPORTA O NOSSO AJUDANTE DE IMAGENS

class ServiceDetailScreen extends StatelessWidget {
  // A tela recebe um objeto Servico para saber o que exibir
  final Servico servico;

  const ServiceDetailScreen({super.key, required this.servico});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(servico.nome, style: const TextStyle(color: Colors.white)),
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
      ),
      // --- ESTRUTURA DE RESPONSIVIDADE ADICIONADA ---
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800, // Largura máxima do conteúdo para boa legibilidade
          ),
          child: SingleChildScrollView(
            // Permite rolar a tela se o conteúdo for grande
            child: Padding(
              padding: const EdgeInsets.all(
                24.0,
              ), // Aumentei o padding para telas maiores
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha tudo à esquerda
                children: [
                  // --- IMAGEM DO SERVIÇO ATUALIZADA AQUI ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    // Usa a nossa função ajudante para obter o caminho da imagem correta
                    child: Image.asset(
                      getImagemParaServico(servico.nome),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nome do Serviço
                  Text(
                    servico.nome,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Preço
                  Text(
                    'R\$ ${servico.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Descrição
                  const Text(
                    'Sobre o serviço:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    servico.descricao,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Contato
                  const Text(
                    'Contato para mais informações:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(servico.contato, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
      // Botão flutuante no fundo da tela para agendar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.calendar_month),
          label: const Text('Agendar Este Serviço'),
          onPressed: () {
            // Ação: navegar para a tela de agendamento
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingScreen(servico: servico),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),

            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
