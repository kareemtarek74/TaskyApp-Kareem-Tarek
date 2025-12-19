import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kareem_tarek/core/utils/text_styles.dart';
import 'package:kareem_tarek/features/tasks/domain/entities/task_entity.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/add_edit_task_bottom_sheet.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;

  static final dateFormat = DateFormat('MMM d, y • h:mm a');

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.complete;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isCompleted ? 0.02 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder:
                  (ctx) => BlocProvider.value(
                    value: context.read<TaskCubit>(),
                    child: AddEditTaskBottomSheet(task: task),
                  ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        isCompleted
                            ? Colors.green.withValues(alpha: 0.1)
                            : (task.type == TaskType.work
                                ? Colors.blue[50]
                                : Colors.orange[50]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        context.read<TaskCubit>().toggleTaskStatus(task);
                      },
                      child: Center(
                        child: Icon(
                          isCompleted
                              ? Icons.check
                              : (task.type == TaskType.work
                                  ? Icons.work_outline
                                  : Icons.person_outline),
                          color:
                              isCompleted
                                  ? Colors.green
                                  : (task.type == TaskType.work
                                      ? Colors.blue
                                      : Colors.orange),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: Styles.styleBold18(context).copyWith(
                                color:
                                    isCompleted
                                        ? Colors.grey[500]
                                        : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: Styles.styleRegular14(
                          context,
                        ).copyWith(color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(task.createdAt),
                            style: Styles.styleRegular12(
                              context,
                            ).copyWith(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
