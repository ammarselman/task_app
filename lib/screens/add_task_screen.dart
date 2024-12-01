import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatelessWidget {
  final Task? task;
  final TextEditingController _titleController = TextEditingController();

  AddTaskScreen({super.key, this.task}) {
    if (task != null) {
      _titleController.text = task!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty) {
                  if (task == null) {
                    await Provider.of<TaskProvider>(context, listen: false)
                        .addTask(_titleController.text);
                  } else {
                    await Provider.of<TaskProvider>(context, listen: false)
                        .deleteTask(task!.id);
                    await Provider.of<TaskProvider>(context, listen: false)
                        .addTask(_titleController.text);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(task == null ? 'Add Task' : 'Update Task'),
            )
          ],
        ),
      ),
    );
  }
}
