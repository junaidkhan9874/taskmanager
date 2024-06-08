// lib/data/repositories/task_repository_impl.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SharedPreferences sharedPreferences;

  TaskRepositoryImpl(this.sharedPreferences);

  @override
  Future<List<Task>> getTasks() async {
    final jsonString = sharedPreferences.getString('tasks') ?? '[]';
    final List decodedList = json.decode(jsonString) as List;
    final List<TaskModel> taskModels = decodedList.map((json) => TaskModel.fromJson(json)).toList();
    print('Fetched tasks: $taskModels');
    return taskModels.map((taskModel) => taskModel.toTask()).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    final taskModels = tasks.map((task) => TaskModel.fromTask(task)).toList();
    taskModels.add(TaskModel.fromTask(task));
    print('Adding task: $taskModels'); // Debugging print statement
    await sharedPreferences.setString('tasks', json.encode(taskModels.map((taskModel) => taskModel.toJson()).toList()));
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    final taskModels = tasks.map((task) => TaskModel.fromTask(task)).toList();
    if (index != -1) {
      taskModels[index] = TaskModel.fromTask(task);
    }
    await sharedPreferences.setString('tasks', json.encode(taskModels.map((taskModel) => taskModel.toJson()).toList()));
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    final taskModels = tasks.map((task) => TaskModel.fromTask(task)).toList();
    taskModels.removeWhere((taskModel) => taskModel.id == taskId);
    await sharedPreferences.setString('tasks', json.encode(taskModels.map((taskModel) => taskModel.toJson()).toList()));
  }
}
