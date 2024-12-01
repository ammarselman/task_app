import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/models/task.dart';
import 'package:untitled/providers/task_provider.dart';

void main() {
  group('TaskProvider Tests', () {
    test('Add Task Test', () async {
      // Arrange
      final taskProvider = TaskProvider();
      final task = Task(id: 1, title: 'Test Task', completed: false);

      // Act
      await taskProvider.addTask(task.title);

      // Assert
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks[0].title, 'Test Task');
    });

    test('Delete Task Test', () async {
      // Arrange
      final taskProvider = TaskProvider();
      final task = Task(id: 1, title: 'Test Task', completed: false);

      await taskProvider.addTask(task.title);

      // Act
      await taskProvider.deleteTask(task.id);

      // Assert
      expect(taskProvider.tasks.length, 0);
    });
  });
}
