import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Chaves para guardar os dados

  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userPhotoKey = 'user_photo';
  static const String _logradouroKey = 'user_logradouro';
  static const String _numeroKey = 'user_numero';
  static const String _complementoKey = 'user_complemento';
  static const String _bairroKey = 'user_bairro';

  // MÉTODO PARA PEGAR O TOKEN ---
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Método para salvar os dados da sessão
  Future<void> saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, data['token']);
    await prefs.setInt(_userIdKey, data['id']);
    await prefs.setString(_userNameKey, data['nome']);
    // Salva a fotoUrl se ela existir, senão salva uma string vazia
    await prefs.setString(_userPhotoKey, data['fotoUrl'] ?? '');
    await prefs.setString(_logradouroKey, data['logradouro'] ?? '');
    await prefs.setString(_numeroKey, data['numero'] ?? '');
    await prefs.setString(_complementoKey, data['complemento'] ?? '');
    await prefs.setString(_bairroKey, data['bairro'] ?? '');
  }

  // Verifica se existe um token salvo
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  // Busca os dados do usuário que estão salvos
  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt(_userIdKey),
      'nome': prefs.getString(_userNameKey),
      'fotoUrl': prefs.getString(_userPhotoKey),
      'logradouro': prefs.getString(_logradouroKey),
      'numero': prefs.getString(_numeroKey),
      'complemento': prefs.getString(_complementoKey),
      'bairro': prefs.getString(_bairroKey),
    };
  }

  // Limpa todos os dados da sessão (faz o logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
