import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kareem_tarek/core/utils/data_seeder.dart';
import 'package:kareem_tarek/features/tasks/domain/entities/task_entity.dart';
import 'package:kareem_tarek/features/tasks/domain/usecases/manage_tasks_usecase.dart';
import 'package:kareem_tarek/features/tasks/domain/usecases/watch_tasks_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final WatchTasksUseCase watchTasksUseCase;
  final ManageTasksUseCase manageTasksUseCase;
  StreamSubscription? tasksSubscription;
  final searchSubject = BehaviorSubject<String>();

  static const int pageSize = 20;
  int limit = pageSize;

  TaskCubit({required this.watchTasksUseCase, required this.manageTasksUseCase})
    : super(TaskInitial()) {
    searchSubject.debounceTime(const Duration(milliseconds: 300)).listen((
      query,
    ) {
      bool? currentIsCompleted;
      String? currentType;
      String currentSortBy = 'date_desc';

      if (state is TaskLoaded) {
        final loaded = state as TaskLoaded;
        currentIsCompleted = loaded.isCompletedFilter;
        currentType = loaded.typeFilter;
        currentSortBy = loaded.sortBy;
      }

      limit = pageSize;

      subscribeToTasks(
        searchQuery: query,
        isCompleted: currentIsCompleted,
        type: currentType,
        sortBy: currentSortBy,
      );
    });
  }

  void loadTasks() {
    limit = pageSize;
    subscribeToTasks();
  }

  void loadMoreTasks() {
    limit += pageSize;

    String currentQuery = '';
    bool? currentIsCompleted;
    String? currentType;
    String currentSortBy = 'date_desc';

    if (state is TaskLoaded) {
      final loaded = state as TaskLoaded;
      currentQuery = loaded.searchQuery;
      currentIsCompleted = loaded.isCompletedFilter;
      currentType = loaded.typeFilter;
      currentSortBy = loaded.sortBy;
    }

    subscribeToTasks(
      searchQuery: currentQuery,
      isCompleted: currentIsCompleted,
      type: currentType,
      sortBy: currentSortBy,
    );
  }

  void searchTasks(String query) {
    searchSubject.add(query);
  }

  void updateFilters({
    bool? isCompleted,
    bool updateCompleter = false,
    String? type,
    bool updateType = false,
    String? sortBy,
  }) {
    limit = pageSize;

    bool? finalIsCompleted;
    String? finalType;
    String finalSortBy = sortBy ?? 'date_desc';
    String finalQuery = '';

    if (state is TaskLoaded) {
      final loaded = state as TaskLoaded;
      finalIsCompleted =
          updateCompleter ? isCompleted : loaded.isCompletedFilter;
      finalType = updateType ? type : loaded.typeFilter;
      finalSortBy = sortBy ?? loaded.sortBy;
      finalQuery = loaded.searchQuery;
    } else {
      finalIsCompleted = isCompleted;
      finalType = type;
      if (updateCompleter && isCompleted == null) finalIsCompleted = null;
    }

    subscribeToTasks(
      searchQuery: finalQuery,
      isCompleted: finalIsCompleted,
      type: finalType,
      sortBy: finalSortBy,
    );
  }

  void filterTasks({bool? isCompleted, String? sortBy, String? type}) {
    updateFilters(
      isCompleted: isCompleted,
      updateCompleter: isCompleted != null,
      type: type,
      updateType: type != null,
      sortBy: sortBy,
    );
  }

  Future<void> addTask(TaskEntity task) async {
    await manageTasksUseCase.addTask(task);
  }

  Future<void> deleteTask(TaskEntity task) async {
    await manageTasksUseCase.deleteTask(task);
  }

  void setFilterType(String? type) {
    updateFilters(type: type, updateType: true);
  }

  void setFilterCompleted(bool? isCompleted) {
    updateFilters(isCompleted: isCompleted, updateCompleter: true);
  }

  void setSortBy(String sortBy) {
    updateFilters(sortBy: sortBy);
  }

  @override
  Future<void> toggleTaskStatus(TaskEntity task) async {
    final newStatus =
        task.status == TaskStatus.complete
            ? TaskStatus.incomplete
            : TaskStatus.complete;

    final updatedTask = TaskEntity(
      id: task.id,
      title: task.title,
      description: task.description,
      type: task.type,
      status: newStatus,
      createdAt: task.createdAt,
    );

    await manageTasksUseCase.addTask(updatedTask);
  }

  void subscribeToTasks({
    String searchQuery = '',
    bool? isCompleted,
    String? type,
    String sortBy = 'date_desc',
  }) {
    tasksSubscription?.cancel();

    final tasksStream = watchTasksUseCase(
      searchQuery: searchQuery,
      isCompleted: isCompleted,
      type: type,
      sortBy: sortBy,
      limit: limit,
    );

    Stream<bool> loadingStream;
    if (DataSeeder.isLoadingNotifier.value) {
      loadingStream = DataSeeder.isLoadingStream.distinct().switchMap((
        isLoading,
      ) {
        if (isLoading) return Stream.value(true);
        return Stream.value(false).delay(const Duration(milliseconds: 1000));
      });
    } else {
      loadingStream = Stream.value(false);
    }

    tasksSubscription = Rx.combineLatest2(tasksStream, loadingStream, (
      List<TaskEntity> tasks,
      bool isSeeding,
    ) {
      return (tasks, isSeeding);
    }).listen((data) {
      final tasks = data.$1;
      final isSeeding = data.$2;

      if (isSeeding && tasks.isEmpty) {
        emit(TaskLoading());
        return;
      }

      final hasReachedMax = tasks.length < limit;
      emit(
        TaskLoaded(
          tasks: tasks,
          searchQuery: searchQuery,
          isCompletedFilter: isCompleted,
          typeFilter: type,
          sortBy: sortBy,
          hasReachedMax: hasReachedMax,
        ),
      );
    }, onError: (error) {});
  }

  @override
  Future<void> close() {
    tasksSubscription?.cancel();
    searchSubject.close();
    return super.close();
  }
}
