import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoRepository {
  final String baseUrl = 'https://api.nstack.in/v1/todos';

  Future<List<dynamic>> fetchTodos(int page, int limit) async {
    final url = '$baseUrl?page=$page&limit=$limit';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'];
      return result;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<int> deleteTodoById(String id) async {
    final url = '$baseUrl/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response.statusCode;
  }

  Future<int> createTodo(String title, String description) async {
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = baseUrl;
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode;
  }

  Future<int> updateTodo(String id, String title, String description) async {
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = '$baseUrl/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode;
  }
}
