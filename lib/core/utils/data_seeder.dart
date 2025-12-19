import 'dart:math';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:kareem_tarek/core/utils/value_listenable_stream.dart';
import 'package:kareem_tarek/features/tasks/data/local_data_source/database/app_database.dart';
import 'package:kareem_tarek/features/tasks/domain/entities/task_entity.dart';

class DataSeeder {
  static final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(true);

  static Stream<bool> get isLoadingStream =>
      ValueListenableStream(isLoadingNotifier);

  static Future<void> seedData(AppDatabase db) async {
    isLoadingNotifier.value = true;
    try {
      final countExp = db.tasks.id.count();
      final count =
          await (db.selectOnly(db.tasks)..addColumns([
            countExp,
          ])).map((row) => row.read(countExp)).getSingle();

      if (count != null && count > 0) {
        isLoadingNotifier.value = false;
        return;
      }

      final initialBatch = await compute(generateRecentBatch, 50);

      await db.batch((batchOp) {
        batchOp.insertAll(db.tasks, initialBatch);
      });

      isLoadingNotifier.value = false;

      generateAndInsertRemainingInBackground(db);
    } catch (e) {
      isLoadingNotifier.value = false;
      rethrow;
    }
  }

  static Future<void> generateAndInsertRemainingInBackground(
    AppDatabase db,
  ) async {
    const int totalRemaining = 9950;
    const int chunkSize = 500;
    int insertedCount = 0;

    while (insertedCount < totalRemaining) {
      final startOffset = 51 + insertedCount;
      final chunk = await compute(generateOldBatch, [chunkSize, startOffset]);

      await db.batch((batchOp) {
        batchOp.insertAll(db.tasks, chunk);
      });

      insertedCount += calculateRealChunkSize(chunk.length);

      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  static int calculateRealChunkSize(int size) => size;

  static List<TasksCompanion> generateRecentBatch(int count) {
    final random = Random();
    final types = TaskType.values;
    final statuses = TaskStatus.values;
    List<TasksCompanion> batch = [];

    for (int i = 0; i < count; i++) {
      batch.add(
        TasksCompanion(
          title: drift.Value('Task ${i + 1} - Random Task'),
          description: drift.Value('Random task generated.'),
          type: drift.Value(types[random.nextInt(types.length)].name),
          status: drift.Value(statuses[random.nextInt(statuses.length)].name),
          createdAt: drift.Value(
            DateTime.now().subtract(Duration(minutes: random.nextInt(1440))),
          ),
        ),
      );
    }
    return batch;
  }

  static List<TasksCompanion> generateOldBatch(List<int> args) {
    final count = args[0];
    final startIndex = args[1];

    final random = Random();
    final types = TaskType.values;
    final statuses = TaskStatus.values;
    List<TasksCompanion> batch = [];

    final cutoffDate = DateTime.now().subtract(const Duration(days: 2));

    for (int i = 0; i < count; i++) {
      final taskNumber = startIndex + i;
      batch.add(
        TasksCompanion(
          title: drift.Value('Task $taskNumber - Random Task'),
          description: drift.Value('Random task generated.'),
          type: drift.Value(types[random.nextInt(types.length)].name),
          status: drift.Value(statuses[random.nextInt(statuses.length)].name),
          createdAt: drift.Value(
            cutoffDate.subtract(
              Duration(
                days: random.nextInt(365),
                minutes: random.nextInt(1000),
              ),
            ),
          ),
        ),
      );
    }
    return batch;
  }
}
