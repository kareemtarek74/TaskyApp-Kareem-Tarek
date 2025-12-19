import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
}
