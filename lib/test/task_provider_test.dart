import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/task.dart';
import 'package:untitled/providers/task_provider.dart';

void main() {
  test('Add Task Test', () {
    final taskProvider = TaskProvider();
    final task = Task(title: 'Test Task', description: 'Description');

    taskProvider.addTask(task);

    expect(taskProvider.tasks.length, 1);
    expect(taskProvider.tasks[0].title, 'Test Task');
  });
}
