import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';

import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../notifiers/task_notifier.dart';

// Define the provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Define the provider for TaskRepository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final sharedPreferences = ref.read(sharedPreferencesProvider);
  return TaskRepositoryImpl(sharedPreferences);
});

// Define the providers for use cases
final getTasksProvider = Provider<GetTasks>((ref) {
  final repository = ref.read(taskRepositoryProvider);
  return GetTasks(repository);
});

final addTaskProvider = Provider<AddTask>((ref) {
  final repository = ref.read(taskRepositoryProvider);
  return AddTask(repository);
});


final deleteTaskProvider = Provider<DeleteTask>((ref) {
  final repository = ref.read(taskRepositoryProvider);
  return DeleteTask(repository);
});

// Define the TaskNotifier provider
final taskNotifierProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final getTasks = ref.read(getTasksProvider);
  final addTask = ref.read(addTaskProvider);
  final deleteTask = ref.read(deleteTaskProvider);
  return TaskNotifier(
    getTasks: getTasks,
    addTask: addTask,
    deleteTask: deleteTask,
  );
});
