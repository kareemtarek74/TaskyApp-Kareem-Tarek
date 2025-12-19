import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kareem_tarek/core/utils/text_styles.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';

class FilterBottomSheet extends StatefulWidget {
  final bool? currentIsCompleted;
  final String? currentType;

  const FilterBottomSheet({
    super.key,
    required this.currentIsCompleted,
    required this.currentType,
  });

  @override
  State<FilterBottomSheet> createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {
  bool? selectedIsCompleted;
  String? selectedType;

  @override
  void initState() {
    super.initState();
    selectedIsCompleted = widget.currentIsCompleted;
    selectedType = widget.currentType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter Tasks', style: Styles.styleBold22(context)),

              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text('Status', style: Styles.styleBold18(context)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              buildChoiceChip(
                label: 'All',
                selected: selectedIsCompleted == null,
                onSelected: (_) => setState(() => selectedIsCompleted = null),
              ),
              buildChoiceChip(
                label: 'Completed',
                selected: selectedIsCompleted == true,
                onSelected: (_) => setState(() => selectedIsCompleted = true),
              ),
              buildChoiceChip(
                label: 'Incomplete',
                selected: selectedIsCompleted == false,
                onSelected: (_) => setState(() => selectedIsCompleted = false),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text('Type', style: Styles.styleBold18(context)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              buildChoiceChip(
                label: 'All Types',
                selected: selectedType == null,
                onSelected: (_) => setState(() => selectedType = null),
              ),
              buildChoiceChip(
                label: 'Work',
                selected: selectedType == 'work',
                onSelected: (_) => setState(() => selectedType = 'work'),
              ),
              buildChoiceChip(
                label: 'Personal',
                selected: selectedType == 'personal',
                onSelected: (_) => setState(() => selectedType = 'personal'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedIsCompleted = null;
                      selectedType = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Reset', style: Styles.styleRegular16(context)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TaskCubit>().updateFilters(
                      isCompleted: selectedIsCompleted,
                      updateCompleter: true,
                      type: selectedType,
                      updateType: true,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: Styles.styleBold16(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChoiceChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.white,
      selectedColor: Colors.black,
      labelStyle:
          selected
              ? Styles.styleBold16(context).copyWith(color: Colors.white)
              : Styles.styleRegular16(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? Colors.transparent : Colors.grey[300]!,
        ),
      ),
      showCheckmark: false,
    );
  }
}
