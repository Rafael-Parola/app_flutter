import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsController {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, String>> loadData() async {
    final nome = await _storage.read(key: 'nome') ?? 'Não encontrado';
    final data = await _storage.read(key: 'data') ?? 'Não encontrado';
    final email = await _storage.read(key: 'email') ?? 'Não encontrado';

    return {
      'nome': nome,
      'data': data,
      'email': email,
    };
  }
   Future<void> logout() async {
    await _storage.deleteAll();
  }
}
