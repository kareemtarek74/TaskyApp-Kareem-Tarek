import 'package:drift/drift.dart';
import 'package:kareem_tarek/features/tasks/data/local_data_source/database/app_database.dart';
import 'package:kareem_tarek/features/tasks/domain/entities/task_entity.dart';
import 'package:kareem_tarek/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase db;

  TaskRepositoryImpl(this.db);

  @override
  Stream<List<TaskEntity>> watchTasks({
    String? searchQuery,
    bool? isCompleted,
    String? type,
    String? sortBy,
    int? limit,
  }) {
    return db
        .watchTasks(
          limit: limit,
          searchQuery: searchQuery,
          status:
              isCompleted == null
                  ? null
                  : (isCompleted
                      ? TaskStatus.complete.name
                      : TaskStatus.incomplete.name),
          type: type,
          sortByDateDesc: sortBy != 'date_asc',
        )
        .map((tasks) {
          return tasks.map(mapToEntity).toList();
        });
  }

  @override
  Future<void> upsertTask(TaskEntity task) async {
    final isNewNode = task.id <= 0;

    await db
        .into(db.tasks)
        .insertOnConflictUpdate(
          TasksCompanion(
            id: isNewNode ? const Value.absent() : Value(task.id),
            title: Value(task.title),
            description: Value(task.description),
            type: Value(task.type.name),
            status: Value(task.status.name),
            createdAt: Value(task.createdAt),
          ),
        );
  }

  @override
  Future<void> deleteTask(TaskEntity task) async {
    await (db.delete(db.tasks)..where((t) => t.id.equals(task.id))).go();
  }

  @override
  Future<int> getTaskCount() async {
    final count = await db.tasks.count().getSingle();
    return count;
  }

  TaskEntity mapToEntity(Task task) {
    return TaskEntity(
      id: task.id,
      title: task.title,
      description: task.description,
      type: TaskType.values.byName(task.type),
      status: TaskStatus.values.byName(task.status),
      createdAt: task.createdAt,
    );
  }
}
