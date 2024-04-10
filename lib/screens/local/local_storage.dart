import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  bool isFirstTime = true;
  Future<void> saveData(String name, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData;
    if (data is String) {
      encodedData = data;
    } else {
      encodedData = json.encode(data);
    }

    await prefs.setString(name, encodedData);
  }

  Future<dynamic> getData(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(name);

    if (data != null) {
      try {
        return json.decode(data);
      } catch (e) {
        return data;
      }
    }
    return null;
  }

  // Future<dynamic> updateById(
  //     List<dynamic> data, String id, dynamic updatedData) async {
  //   int index = data.indexWhere((element) => element['_id'] == id);
  //   if (index != -1) {
  //     data[index] = updatedData;
  //     return data;
  //   }
  //   return null;
  // }

  dynamic updateById(List<dynamic> data, String id, dynamic updatedData) {
    int index = data.indexWhere((element) => element['_id'] == id);
    if (index != -1) {
      data[index] = updatedData;
      return data;
    }
    return null;
  }

  // Future<dynamic> deleteById(List<dynamic> data, String id) async {
  //   int index = data.indexWhere((element) => element['_id'] == id);
  //   if (index != -1) {
  //     data.removeAt(index);
  //     return data;
  //   }
  //   return null;
  // }
  dynamic deleteById(List<dynamic> data, String id) {
    int index = data.indexWhere((element) => element['_id'] == id);
    if (index != -1) {
      data.removeAt(index);
      return data;
    }
    return null;
  }
}
