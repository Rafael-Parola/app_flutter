import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterController with ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getData(String key) async {
    final value = await _storage.read(key: key);

    return value;
  }

  Future<void> clearData() async {
    await _storage.deleteAll();
  }

  Future<void> initializeForm(
      TextEditingController nomeController,
      TextEditingController dataController,
      TextEditingController emailController) async {

    final nome = await getData('nome');
    final data = await getData('data');
    final email = await getData('email');

    if (nome != null && data != null && email != null) {
      nomeController.text = nome;
      dataController.text = data;
      emailController.text = email;


      notifyListeners();
      return;
    }

    
    nomeController.text = '';
    dataController.text = '';
    emailController.text = '';
    notifyListeners();
  }

  Future<bool> hasData() async {
    final nome = await getData('nome');
    final data = await getData('data');
    final email = await getData('email');
    return nome != null && data != null && email != null;
  }
}
