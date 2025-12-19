import 'package:kareem_tarek/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Stream<List<TaskEntity>> watchTasks({
    String? searchQuery,
    bool? isCompleted,
    String? type,
    String? sortBy,
    int? limit,
  });

  Future<void> upsertTask(TaskEntity task);
  Future<void> deleteTask(TaskEntity task);
  Future<int> getTaskCount();
}
