import 'dart:convert';

import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> createBMVocab(String token, List<Map<String, String>> vocabularyList) async {
  var response = await http.post(
    Uri.parse(createBookmarkVocabUrl),
    headers: {
      'Content-Type': 'application/json',
      'token': '$token',
    },
    body: {
      'vocabularies' : jsonEncode(vocabularyList),
    }
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> deleteBMVocab(String token, String idVocab) async {
  var response = await http.delete(
    Uri.parse(deleteBookmarkVocabUrl + idVocab),
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

Future<Map<String, dynamic>> getAllBMVocab(String token) async {
  var response = await http.get(
    Uri.parse(getAllBookmarkVocabByUser),
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