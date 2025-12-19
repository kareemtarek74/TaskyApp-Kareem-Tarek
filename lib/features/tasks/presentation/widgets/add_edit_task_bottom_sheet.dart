import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kareem_tarek/core/utils/text_styles.dart';
import 'package:kareem_tarek/features/tasks/domain/entities/task_entity.dart';
import 'package:kareem_tarek/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:kareem_tarek/features/tasks/presentation/widgets/type_selection_card.dart';

class AddEditTaskBottomSheet extends StatefulWidget {
  final TaskEntity? task;

  const AddEditTaskBottomSheet({super.key, this.task});

  @override
  State<AddEditTaskBottomSheet> createState() => AddEditTaskBottomSheetState();
}

class AddEditTaskBottomSheetState extends State<AddEditTaskBottomSheet> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TaskType selectedType;
  late bool isCompleted;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    selectedType = widget.task?.type ?? TaskType.personal;
    isCompleted = widget.task?.status == TaskStatus.complete;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveTask() {
    if (formKey.currentState!.validate()) {
      final task = TaskEntity(
        id: widget.task?.id ?? 0,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        type: selectedType,
        status: isCompleted ? TaskStatus.complete : TaskStatus.incomplete,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
      );

      context.read<TaskCubit>().addTask(task);
      Navigator.pop(context);
    }
  }

  void deleteTask() {
    if (widget.task != null) {
      context.read<TaskCubit>().deleteTask(widget.task!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                widget.task == null ? 'New Task' : 'Edit Task',
                style: Styles.styleBold22(context),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: Styles.styleRegular16(context),
                  hintText: 'What needs to be done?',
                  hintStyle: Styles.styleRegular14(
                    context,
                  ).copyWith(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: Styles.styleRegular16(context),
                  hintText: 'Add details...',
                  hintStyle: Styles.styleRegular14(
                    context,
                  ).copyWith(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TypeSelectionCard(
                      title: 'Personal',
                      icon: Icons.person_outline,
                      isSelected: selectedType == TaskType.personal,
                      onTap:
                          () =>
                              setState(() => selectedType = TaskType.personal),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TypeSelectionCard(
                      title: 'Work',
                      icon: Icons.work_outline,
                      isSelected: selectedType == TaskType.work,
                      onTap: () => setState(() => selectedType = TaskType.work),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Mark as Completed',
                    style: Styles.styleMedium16(context),
                  ),
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      isCompleted = value;
                    });
                  },
                  activeColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (widget.task != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: deleteTask,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: saveTask,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.task == null ? 'Create Task' : 'Save Changes',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
