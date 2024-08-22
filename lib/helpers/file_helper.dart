import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static String authFile = "auth.json";


  static Future<File> categoryImagePath(int id)async {
   return await FileHelper.staticPath("images/invoices/$id.png");
  }

  static Future<File> staticPath(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    String staticFolderPath='${directory.path}/static/';
    String fullDirectoryPath=staticFolderPath;
    List filePathList=filePath.split("/");
    filePathList.removeLast();
    if(filePathList.isNotEmpty){
      fullDirectoryPath+=filePathList.join("/");
    }
    final folder = Directory(fullDirectoryPath);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }
    return File(staticFolderPath+filePath);
  }
  static Future<void> write( String fileName,var data) async {
    final file = await staticPath(fileName);
    final jsonString = jsonEncode(data);
    await file.writeAsString(jsonString);
  }

  static read(String fileName) async {
    try {
      final file = await staticPath(fileName);
      if (!file.existsSync()) {
        return null;
      }
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString);
      return jsonData;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> delete(String fileName) async {
    final file = await staticPath(fileName);
    if (!file.existsSync()) {
      return true;
    }
    await file.delete();
    if (!file.existsSync()) {
      return true;
    }
    return false;
  }

  static Future<void> download(String fromPath ,String toPath) async{
    try {
      Dio dio = Dio();
      await dio.download(fromPath, toPath);

    } catch (e) {

    }
  }

}