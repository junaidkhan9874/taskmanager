// lib/presentation/notifiers/task_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskNotifier({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    state = await getTasks();
  }

  Future<void> add(Task task) async {
    await addTask(task);
    state = [...state, task];
  }

  Future<void> update(Task task) async {
    await updateTask(task);
    state = [
      for (final t in state)
        if (t.id == task.id) task else t,
    ];
  }

  Future<void> delete(String taskId) async {
    await deleteTask(taskId);
    state = state.where((task) => task.id != taskId).toList();
  }
}
