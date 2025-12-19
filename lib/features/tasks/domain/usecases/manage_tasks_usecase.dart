import 'package:kareem_tarek/features/tasks/domain/entities/task_entity.dart';
import 'package:kareem_tarek/features/tasks/domain/repositories/task_repository.dart';

class ManageTasksUseCase {
  final TaskRepository repository;

  ManageTasksUseCase(this.repository);

  Future<void> addTask(TaskEntity task) {
    return repository.upsertTask(task);
  }

  Future<void> deleteTask(TaskEntity task) {
    return repository.deleteTask(task);
  }
}
