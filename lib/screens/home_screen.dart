import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _tasksPerPage = 10;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialTasks();

    // Set up listener for pagination when reaching the bottom of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isFetchingMore) {
        _fetchMoreTasks();
      }
    });
  }

  Future<void> _fetchInitialTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  Future<void> _fetchMoreTasks() async {
    setState(() {
      _isFetchingMore = true;
    });

    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks(
        limit: _tasksPerPage,
        skip: _tasksPerPage * _currentPage,
      );
      setState(() {
        _currentPage++;
      });
    } finally {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: taskProvider.isLoading && tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchInitialTasks,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: tasks.length + (_isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < tasks.length) {
                    return _buildTaskItem(tasks[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        title: Text(task.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(task: task),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await Provider.of<TaskProvider>(context, listen: false)
                    .deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
