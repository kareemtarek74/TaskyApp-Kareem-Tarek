import 'package:kareem_tarek/features/tasks/domain/entities/task_entity.dart';
import 'package:kareem_tarek/features/tasks/domain/repositories/task_repository.dart';

class WatchTasksUseCase {
  final TaskRepository repository;

  WatchTasksUseCase(this.repository);

  Stream<List<TaskEntity>> call({
    String? searchQuery,
    bool? isCompleted,
    String? type,
    String? sortBy,
    int? limit,
  }) {
    return repository.watchTasks(
      searchQuery: searchQuery,
      isCompleted: isCompleted,
      type: type,
      sortBy: sortBy,
      limit: limit,
    );
  }
}
