import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kareem_tarek/core/utils/text_styles.dart';
import 'package:kareem_tarek/core/utils/tooltip_shape.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';

class SortDropdownButton extends StatelessWidget {
  final String sortBy;
  final VoidCallback? onScrollToTop;

  const SortDropdownButton({
    super.key,
    required this.sortBy,
    this.onScrollToTop,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.sort, color: Colors.grey[700], size: 22),
        ),
        onSelected: (value) {
          if (value == sortBy) {
            onScrollToTop?.call();
          } else {
            context.read<TaskCubit>().updateFilters(sortBy: value);
          }
        },
        offset: const Offset(-10, 50),
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        color: Colors.grey[100],
        shape: const TooltipShape(),
        padding: EdgeInsets.zero,
        itemBuilder:
            (context) => [
              PopupMenuItem(
                value: 'date_asc',
                padding: EdgeInsets.zero,
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 20.5,
                    bottom: 12.5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 14,
                        color:
                            sortBy == 'date_asc'
                                ? Colors.orange
                                : const Color(0xff00060D),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Oldest First',
                        style: Styles.styleMedium14(context).copyWith(
                          color:
                              sortBy == 'date_asc'
                                  ? Colors.orange
                                  : const Color(0xff00060D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const PopupMenuItem(
                enabled: false,
                height: 0,
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(thickness: 0.4),
                ),
              ),
              PopupMenuItem(
                value: 'date_desc',
                padding: EdgeInsets.zero,
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12.5,
                    bottom: 20.5,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        size: 14,
                        color:
                            sortBy == 'date_desc'
                                ? Colors.orange
                                : const Color(0xff00060D),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Newest First',
                        style: Styles.styleMedium14(context).copyWith(
                          color:
                              sortBy == 'date_desc'
                                  ? Colors.orange
                                  : const Color(0xff00060D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
