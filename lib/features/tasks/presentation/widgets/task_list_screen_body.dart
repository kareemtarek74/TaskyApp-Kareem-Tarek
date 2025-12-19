import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kareem_tarek/core/utils/text_styles.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/add_edit_task_bottom_sheet.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/task_card.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/task_card_shimmer.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/task_filter_section.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/task_search_bar.dart';

class TaskListScreenBody extends StatefulWidget {
  const TaskListScreenBody({super.key});

  @override
  State<TaskListScreenBody> createState() => TaskListScreenBodyState();
}

class TaskListScreenBodyState extends State<TaskListScreenBody> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onScroll() {
    if (isBottom) {
      final state = context.read<TaskCubit>().state;
      if (state is TaskLoaded && !state.hasReachedMax) {
        context.read<TaskCubit>().loadMoreTasks();
      }
    }
  }

  bool get isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Tasky', style: Styles.styleBold24(context)),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder:
                    (ctx) => SafeArea(
                      top: false,
                      bottom: Platform.isAndroid ? true : false,
                      child: BlocProvider.value(
                        value: context.read<TaskCubit>(),
                        child: const AddEditTaskBottomSheet(),
                      ),
                    ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const TaskSearchBar(),
          TaskFilterSection(
            onScrollToTop: () {
              if (scrollController.hasClients) {
                scrollController.jumpTo(0);
              }
            },
          ),
          Expanded(
            child: BlocConsumer<TaskCubit, TaskState>(
              listenWhen: (previous, current) {
                return previous is TaskLoaded &&
                    current is TaskLoaded &&
                    (previous.isCompletedFilter != current.isCompletedFilter ||
                        previous.searchQuery != current.searchQuery ||
                        previous.sortBy != current.sortBy);
              },
              listener: (context, state) {
                if (scrollController.hasClients) {
                  scrollController.jumpTo(0);
                }
              },
              builder: (context, state) {
                if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return Center(
                      child: Text(
                        'No tasks found',
                        style: Styles.styleMedium16(context),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollController,
                    cacheExtent: 200,
                    padding: const EdgeInsets.all(16),
                    itemCount:
                        state.hasReachedMax
                            ? state.tasks.length
                            : state.tasks.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.tasks.length) {
                        return Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          ),
                        );
                      }
                      final task = state.tasks[index];
                      return TaskCard(task: task);
                    },
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return const TaskCardShimmer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
