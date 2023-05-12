import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class APICacheManager {
  String cachename = "";

  APICacheManager(this.cachename);

  Future<String?> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory?.path;
  }

  Future<File?> _getLocalFile() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
    ].request();
    if(statuses[Permission.manageExternalStorage] != PermissionStatus.granted) {
      return null;
    }

    final path = await _localPath;
    return File('$path/$cachename.json').create();
  }

  Future<File?> updateOrWriteToFile(dynamic content) async {
    final file = await _getLocalFile();

    // Write the file
    return file?.writeAsString(jsonEncode(content));
  }

  Future<Map<String, dynamic>?> readFromFile() async {
  try {
    final file = await _getLocalFile();

    // Read the file
    String? content = await file?.readAsString();
    DateTime? lastModified = await file?.lastModified();
    DateTime now = DateTime.now();

    //if file contrent is older then one day fetch another one
    if(content!.isEmpty || DateTime.now().day != lastModified!.day) {
      return null;
    }
    dynamic jsonContent = jsonDecode(content!);
    print(jsonContent);

    return jsonContent;
  } catch (e) {
    // If encountering an error, return 0
    print(e);
    return null;
  }
}
}