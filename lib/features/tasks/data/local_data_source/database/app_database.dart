import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kareem_tarek/features/tasks/data/local_data_source/database/tables/tasks.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Task>> watchTasks({
    String? searchQuery,
    String? status,
    String? type,
    bool sortByDateDesc = false,
    int? limit,
  }) {
    final query = select(tasks);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query.where(
        (t) =>
            t.title.contains(searchQuery) | t.description.contains(searchQuery),
      );
    }

    if (status != null) {
      query.where((t) => t.status.equals(status));
    }

    if (type != null) {
      query.where((t) => t.type.equals(type));
    }

    query.orderBy([
      (t) => OrderingTerm(
        expression: t.createdAt,
        mode: sortByDateDesc ? OrderingMode.desc : OrderingMode.asc,
      ),
    ]);

    if (limit != null) {
      query.limit(limit);
    }

    return query.watch();
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON tasks(created_at);',
        );

        if (details.wasCreated) {}
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
