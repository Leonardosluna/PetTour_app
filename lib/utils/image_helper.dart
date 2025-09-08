// Função para obter o caminho da imagem com base no nome do serviço

String getImagemParaServico(String nomeDoServico) {
  switch (nomeDoServico) {
    case 'Passeio Rápido':
      return 'assets/images/passeio_rapido.png';
    case 'Passeio no Parque':
      return 'assets/images/passeio_parque.png';
    case 'Passeio Aventura':
      return 'assets/images/passeio_aventura.png';
    case 'PetTáxi':
      return 'assets/images/pet_taxi.png';
    default:
      // Uma imagem padrão caso o nome não corresponda
      return 'assets/images/logo.png';
  }
}
