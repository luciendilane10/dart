import 'dart:io';
import 'package:test/test.dart';
import '../lib/models/task.dart';
import '../lib/services/task_repository.dart';

void main() {
  late JsonTaskRepository repo;
  final testFilePath = 'test_sort_tasks.json';

  setUp(() {
    repo = JsonTaskRepository(testFilePath);
  });

  tearDown(() {
    final file = File(testFilePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Tests des Services de Tri', () {
    test('Tri des tâches par priorité', () {
      final lowTask = SimpleTask(id: 1, title: 'Low', priority: Priority.low);
      final highTask = SimpleTask(id: 2, title: 'High', priority: Priority.high);

      repo.add(lowTask);
      repo.add(highTask);

      final sorted = repo.getAllSortedByPriority();
      expect(sorted.first.priority, equals(Priority.high));
      expect(sorted.last.priority, equals(Priority.low));
    });
  });
}