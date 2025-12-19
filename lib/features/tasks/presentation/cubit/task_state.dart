part of 'task_cubit.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final String searchQuery;
  final bool? isCompletedFilter;
  final String? typeFilter;
  final String sortBy;
  final bool hasReachedMax;

  const TaskLoaded({
    required this.tasks,
    this.searchQuery = '',
    this.isCompletedFilter,
    this.typeFilter,
    this.sortBy = 'date_desc',
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props =>
      [tasks, searchQuery, isCompletedFilter, typeFilter, sortBy, hasReachedMax];

  TaskLoaded copyWith({
    List<TaskEntity>? tasks,
    String? searchQuery,
    bool? isCompletedFilter,
    String? sortBy,
    bool? hasReachedMax,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      searchQuery: searchQuery ?? this.searchQuery,
      isCompletedFilter: isCompletedFilter ?? this.isCompletedFilter,
      sortBy: sortBy ?? this.sortBy,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
