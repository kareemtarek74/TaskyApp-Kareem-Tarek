import 'package:flutter/material.dart';
import 'package:kareem_tarek/app.dart';
import 'package:kareem_tarek/core/utils/data_seeder.dart';
import 'package:kareem_tarek/features/tasks/data/local_data_source/database/app_database.dart';
import 'package:kareem_tarek/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final db = di.sl<AppDatabase>();
  DataSeeder.seedData(db);
  runApp(const Tasky());
}
