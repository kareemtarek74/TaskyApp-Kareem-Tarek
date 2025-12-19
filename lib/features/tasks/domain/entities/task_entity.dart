import 'package:equatable/equatable.dart';

enum TaskType { personal, work }
enum TaskStatus { incomplete, complete }

class TaskEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final TaskType type;
  final TaskStatus status;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, type, status, createdAt];
}
