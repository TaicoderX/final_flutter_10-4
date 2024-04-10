import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> registerAPI(
    {required email, required password}) async {
  var response = await http.post(
    Uri.parse(register),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  final Map<String, dynamic> data = json.decode(response.body);
  return data;
}

Future<Map<String, dynamic>> loginAPI(
    {required email, required password}) async {
  var response = await http.post(
    Uri.parse(login),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  final Map<String, dynamic> data = json.decode(response.body);
  return data;
}

Future<Map<String, dynamic>> recoverPassword({required email}) async {
  var response = await http.post(
    Uri.parse(recover_Password),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
    }),
  );

  final Map<String, dynamic> data = json.decode(response.body);
  return data;
}

Future<Map<String, dynamic>> getTopicByUserAPI(String token) async {
  var response = await http.get(
    Uri.parse(getTopicByUser),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getTopicByID(String id, String token) async {
  var response = await http.get(
    Uri.parse(getTopic + id),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getVocabularyByTopicId(
    String id, String token) async {
  var response = await http.get(
    Uri.parse(getVocabByTopicId + id),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

// change password
Future<Map<String, dynamic>> changePassword(
    String id, String token, String oldPassword, String newPassword) async {
  var response = await http.put(
    Uri.parse(changePasswordUrl + id),
    headers: {
      'Content-Type': 'application/json',
      'token': '$token',
    },
    body: jsonEncode({
      "password": oldPassword,
      "newPassword": newPassword,
    }),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

// update user
Future<Map<String, dynamic>> updateUser(
    String id, String token, String username) async {
  var response = await http.put(
    Uri.parse(updateUsername + id),
    headers: {
      'Content-Type': 'application/json',
      'token': '$token',
    },
    body: jsonEncode({
      "username": username,
    }),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

// upload avatar
Future<Map<String, dynamic>> uploadAvatar(
    String id, String token, File imageFile) async {
  var uri = Uri.parse(uploadAvatarUrl + id);

  var request = http.MultipartRequest('PUT', uri);
  request.headers['token'] = token;
  request.files.add(
    await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ),
  );

  final response = await request.send();

  if (response.statusCode == 200 || response.statusCode != 500) {
    final responseString = await response.stream.bytesToString();
    return json.decode(responseString);
  } else {
    throw Exception(
        'Failed to upload avatar: Server responded with ${response.statusCode}');
  }
}

// create achievement 
Future<Map<String, dynamic>> createAchievementAPI(String token, String achievementID) async {
  var uri = Uri.parse(createAchievementUrl + achievementID);

  var response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
      'token': '$token',
    },
    body: jsonEncode({
      "achieveId": achievementID,
    }),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}