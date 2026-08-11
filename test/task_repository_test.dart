import 'dart:io';
import 'package:test/test.dart';
import '../lib/models/task.dart';
import '../lib/services/task_repository.dart';

void main() {
  late JsonTaskRepository repo;
  final testFilePath = 'test_tasks.json';

  setUp(() {
    repo = JsonTaskRepository(testFilePath);
  });

  tearDown(() {
    final file = File(testFilePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Tests du JsonTaskRepository', () {
    test('Ajout et récupération de tâches', () {
      final task = SimpleTask(id: 1, title: 'Test Task', priority: Priority.low);
      repo.add(task);

      final tasks = repo.getAll();
      expect(tasks.length, equals(1));
      expect(tasks.first.title, equals('Test Task'));
    });

    test('Suppression d\'une tâche', () {
      final task = SimpleTask(id: 1, title: 'A supprimer', priority: Priority.low);
      repo.add(task);
      repo.delete(1);

      expect(repo.getAll().isEmpty, isTrue);
    });
  });
}