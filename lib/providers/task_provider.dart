import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks({int? limit, int? skip}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _tasks = await _apiService.fetchTasks();
    } catch (error) {
      _tasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    await _apiService.addTask(title);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _apiService.deleteTask(id);
    await fetchTasks();
  }
}
