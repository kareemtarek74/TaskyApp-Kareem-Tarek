import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kareem_tarek/core/utils/text_styles.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/active_filter_chip.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/filter_bottom_sheet.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/sort_dropdown_button.dart';

class TaskFilterSection extends StatelessWidget {
  final VoidCallback? onScrollToTop;

  const TaskFilterSection({super.key, this.onScrollToTop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      buildWhen:
          (previous, current) =>
              previous is TaskLoaded &&
              current is TaskLoaded &&
              (previous.isCompletedFilter != current.isCompletedFilter ||
                  previous.typeFilter != current.typeFilter ||
                  previous.sortBy != current.sortBy),
      builder: (context, state) {
        String sortBy = 'date_desc';
        bool? isCompleted;
        String? type;
        int activeFiltersCount = 0;

        if (state is TaskLoaded) {
          sortBy = state.sortBy;
          isCompleted = state.isCompletedFilter;
          type = state.typeFilter;
          if (isCompleted != null) activeFiltersCount++;
          if (type != null) activeFiltersCount++;
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final taskCubit = context.read<TaskCubit>();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder:
                                (context) => SafeArea(
                                  top: false,
                                  bottom: Platform.isAndroid ? true : false,
                                  child: BlocProvider.value(
                                    value: taskCubit,
                                    child: FilterBottomSheet(
                                      currentIsCompleted: isCompleted,
                                      currentType: type,
                                    ),
                                  ),
                                ),
                          );
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Badge(
                            isLabelVisible: activeFiltersCount > 0,
                            label: Text('$activeFiltersCount'),
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.tune,
                              size: 20,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        label: Text(
                          'Filters',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.centerLeft,
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SortDropdownButton(
                    sortBy: sortBy,
                    onScrollToTop: onScrollToTop,
                  ),
                ],
              ),

              if (activeFiltersCount > 0) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (isCompleted != null)
                      ActiveFilterChip(
                        label: isCompleted ? 'Completed' : 'Incomplete',
                        onDeleted: () {
                          context.read<TaskCubit>().updateFilters(
                            isCompleted: null,
                            updateCompleter: true,
                          );
                        },
                      ),
                    if (type != null)
                      ActiveFilterChip(
                        label: type == 'work' ? 'Work' : 'Personal',
                        onDeleted: () {
                          context.read<TaskCubit>().updateFilters(
                            type: null,
                            updateType: true,
                          );
                        },
                      ),
                    if (activeFiltersCount > 1)
                      InkWell(
                        onTap: () {
                          context.read<TaskCubit>().updateFilters(
                            isCompleted: null,
                            updateCompleter: true,
                            type: null,
                            updateType: true,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 16,
                          ),
                          child: Text(
                            'Clear All',
                            style: Styles.styleBold16(
                              context,
                            ).copyWith(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
