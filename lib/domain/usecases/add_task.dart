import 'package:taskmanager/domain/entities/task.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> call(Task task) async {
    await repository.addTask(task);
  }
}