import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kareem_tarek/core/utils/text_styles.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';

class TaskSearchBar extends StatefulWidget {
  const TaskSearchBar({super.key});

  @override
  State<TaskSearchBar> createState() => TaskSearchBarState();
}

class TaskSearchBarState extends State<TaskSearchBar> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<TaskCubit>().state;
    if (state is TaskLoaded) {
      controller.text = state.searchQuery;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: Styles.styleRegular16(
            context,
          ).copyWith(color: Colors.grey, fontSize: 16),
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              controller.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      controller.clear();
                      context.read<TaskCubit>().searchTasks('');
                      setState(() {});
                    },
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 0,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          context.read<TaskCubit>().searchTasks(value);
        },
      ),
    );
  }
}
