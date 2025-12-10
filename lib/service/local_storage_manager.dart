import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APICacheManager {
  final FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  APICacheManager();

  Future<String> read(String key) async {
    return await storage.read(key: key) ?? '';
  }

  void write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  void deleteAll() async {
    await storage.deleteAll();
  }

  void delete(String key) async {
    await storage.delete(key: key);
  }
}
