import 'dart:convert';

import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> getStatisticByTopicId(String topicId, String token) async {
  var response = await http.get(
    Uri.parse(getStatisticByTopicIdUrl + topicId),
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

Future<Map<String, dynamic>> updateLearningStatistic(String topicId, String token, int learningTime) async {
  var response = await http.put(
    Uri.parse(updateLearningStatisticUrl.replaceFirst(':topicId', topicId)),
    headers: {
      'token': '$token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'learningTime': learningTime,
    }),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}