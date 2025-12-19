import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/task_list_screen_body.dart';
import 'package:kareem_tarek/injection_container.dart' as di;

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<TaskCubit>()..loadTasks(),
      child: TaskListScreenBody(),
    );
  }
}
