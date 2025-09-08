#  PetTour App (Frontend) 📱

Este é o repositório do frontend do projeto PetTour, desenvolvido com **Flutter**. Esta aplicação consome a [API PetTour](https://github.com/Leonardosluna/PetTour_api) para fornecer uma interface rica e interativa para utilizadores e administradores.

## 📸 Screenshot
.....

## ✨ Funcionalidades Implementadas

O aplicativo foi construído com uma abordagem "Content First" e possui um design responsivo que se adapta a telemóveis e ecrãs largos (web/desktop).

* **Navegação e UI:**
    * **Design Responsivo:** Layouts que se adaptam, mostrando listas em ecrãs estreitos e grelhas em ecrãs largos.
    * **Navegação Inteligente:** A interface muda com base no estado de login do utilizador.
    * **Componentes Visuais:** Logo, banner promocional e um footer estático para uma aparência profissional.

* **Fluxo de Autenticação Completo:**
    * **Cadastro de Utilizador:** Tela de cadastro com múltiplos campos (incluindo endereço) e validações.
    * **Login de Utilizador:** Comunicação com a API para autenticar e receber o token JWT.
    * **Gestão de Sessão:** O token e os dados do utilizador são guardados de forma segura no dispositivo, permitindo que o app "se lembre" do login.
    * **Logout:** Funcionalidade para limpar a sessão e deslogar o utilizador.

* **Funcionalidades do Utilizador Logado:**
    * **Visualização de Perfil:** Tela que exibe os dados do utilizador (nome, endereço, etc.).
    * **Edição de Perfil:** Um formulário completo para o utilizador atualizar os seus dados.
    * **Gestão de Pets:**
        * Listagem dos pets do utilizador.
        * Cadastro de novos pets através de um diálogo.
        * Edição e Exclusão de pets com diálogo de confirmação.
    * **Sistema de Agendamento:**
        * Visualização de detalhes de um serviço.
        * Tela de agendamento complexa que permite escolher um pet e um horário.
        * Busca dinâmica de horários disponíveis na API para evitar conflitos.
        * Listagem de "Meus Agendamentos".
        * Opção para o utilizador cancelar os seus próprios agendamentos com confirmação.

## 🛠️ Tecnologias e Pacotes Principais

* **Framework:** Flutter
* **Linguagem:** Dart
* **Pacotes Principais:**
    * `http`: Para fazer as chamadas à API REST.
    * `shared_preferences`: Para persistência local do token JWT e dados da sessão.

## 🚀 Como Executar o Projeto

Siga os passos abaixo para executar o frontend localmente.

### Pré-requisitos

1.  **Flutter SDK** instalado e configurado.
2.  Um emulador Android, iOS ou o Google Chrome para executar a aplicação.
3.  **A API Backend do PetTour precisa de estar a rodar!** Lembre-se de iniciar o seu projeto Java antes de executar o Flutter.

### Configuração

O passo de configuração mais importante é garantir que o app Flutter sabe o endereço correto da sua API.

1.  Abra o ficheiro `lib/api_service.dart`.
2.  Encontre a variável `_baseUrl`.
3.  Ajuste o endereço de acordo com o ambiente onde você vai rodar o app:
    * **Para o Emulador Android:**
        ```dart
        static const String _baseUrl = '[http://10.0.2.2:8080](http://10.0.2.2:8080)';
        ```
    * **Para o Navegador Chrome (Web) ou Desktop:**
        ```dart
        static const String _baseUrl = 'http://localhost:8080';
        ```

### Execução

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/Leonardosluna/PetTour_app.git
    cd pettour_app
    ```

2.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

3.  **Execute a aplicação:**
    * Garanta que um dispositivo (emulador ou Chrome) está selecionado no VS Code.
    * Pressione `F5` para iniciar em modo de depuração.

## 📂 Estrutura do Projeto

O código-fonte está organizado da seguinte forma dentro da pasta `lib/`:
```
lib/
├── api_service.dart      # Centraliza toda a comunicação com o backend.
├── auth_service.dart     # Gere a sessão do utilizador (salvar/ler token).
├── main.dart             # Ponto de entrada da aplicação.
├── models/               # Contém as classes modelo (Servico, Pet, etc.).
├── pages/                # Contém todas as telas da aplicação.
└── utils/                # Contém ficheiros de ajuda, como o image_helper.
```
