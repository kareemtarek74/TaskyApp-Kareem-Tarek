import 'package:get_it/get_it.dart';
import 'package:kareem_tarek/features/tasks/data/local_data_source/database/app_database.dart';
import 'package:kareem_tarek/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:kareem_tarek/features/tasks/domain/repositories/task_repository.dart';
import 'package:kareem_tarek/features/tasks/domain/usecases/manage_tasks_usecase.dart';
import 'package:kareem_tarek/features/tasks/domain/usecases/watch_tasks_usecase.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final db = AppDatabase();
  sl.registerSingleton<AppDatabase>(db);
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));
  sl.registerLazySingleton(() => WatchTasksUseCase(sl()));
  sl.registerLazySingleton(() => ManageTasksUseCase(sl()));
  sl.registerFactory(
    () => TaskCubit(watchTasksUseCase: sl(), manageTasksUseCase: sl()),
  );
}
