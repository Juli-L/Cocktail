import 'package:path_provider/path_provider.dart';
import 'dart:io';
Future<String?> get _localPath async {
  var directory = Platform.isAndroid
      ? await getExternalStorageDirectory() //FOR ANDROID
      : await getApplicationDocumentsDirectory(); //FOR iOS

  return directory?.path;
}
Future<File>  _localFile(String name) async {
  final path = await _localPath;
  return File('$path/$name');
}
Future<File> writeFile(String fileName,String content) async {
  final base = await _localFile(fileName);
  // Write the file
  return base.writeAsString(content);
}

Future<String> readFile(String fileName) async {
  try {
    File file = await _localFile(fileName);

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return "noData";
  }
}