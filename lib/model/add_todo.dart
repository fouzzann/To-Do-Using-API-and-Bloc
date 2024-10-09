import 'dart:convert';

import 'package:http/http.dart' as http;

  class AddTodo {
  final String titile;
  final String description;

  AddTodo({required this.titile, required this.description});
  Future<int> submitData() async {
    final title = titile;
    final descriptions = description;

    final body = {
      "title": title,
      "desciption": descriptions,
      "is_completed": false,
    };

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode;
  }
}
