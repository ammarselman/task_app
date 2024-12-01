import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<Task>> fetchTasks({int limit = 10, int skip = 0}) async {
    final response =
        await http.get(Uri.parse('$baseUrl/todos?limit=$limit&skip=$skip'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['todos'] as List;
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'todo': title, 'completed': false}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/todos/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
