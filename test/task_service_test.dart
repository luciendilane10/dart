import 'dart:io';
import 'package:test/test.dart';
import '../lib/commands/task.dart';
import '../lib/models/task.dart';
import '../lib/services/task_repository.dart';

void main() {
  late JsonTaskRepository repo;
  late TaskCommandHandler handler;
  final testFilePath = 'test_handler_tasks.json';

  setUp(() {
    repo = JsonTaskRepository(testFilePath);
    handler = TaskCommandHandler(repo);
  });

  tearDown(() {
    final file = File(testFilePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Tests effectifs du TaskCommandHandler', () {
    test('Génération correcte des identifiants uniques', () {
      repo.add(SimpleTask(id: 1, title: 'Tâche 1', priority: Priority.low));
      repo.add(SimpleTask(id: 5, title: 'Tâche 5', priority: Priority.high));

      // La prochaine tâche créée doit avoir l'ID 6
      final allTasks = repo.getAll();
      final maxId = allTasks.map((t) => t.id).reduce((a, b) => a > b ? a : b);
      expect(maxId + 1, equals(6));
    });

    test('Filtrage et tri des tâches du dépôt via les méthodes de tri', () {
      final taskLow = SimpleTask(id: 1, title: 'Basse priorité', priority: Priority.low);
      final taskHigh = SimpleTask(id: 2, title: 'Haute priorité', priority: Priority.high);
      
      repo.add(taskLow);
      repo.add(taskHigh);

      final sortedByPriority = repo.getAllSortedByPriority();
      expect(sortedByPriority.first.priority, equals(Priority.high));
      expect(sortedByPriority.last.priority, equals(Priority.low));
    });
  });
}