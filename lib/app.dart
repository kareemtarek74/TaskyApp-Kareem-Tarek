import 'package:flutter/material.dart';
import 'package:kareem_tarek/core/utils/app_constants.dart';
import 'package:kareem_tarek/features/tasks/presentation/pages/task_list_screen.dart';

class Tasky extends StatelessWidget {
  const Tasky({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: AppConstants.font,
      ),
      home: const TaskListScreen(),
    );
  }
}
