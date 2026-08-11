import 'dart:io';
import 'package:test/test.dart';
import '../lib/models/task.dart';
import '../lib/services/task_repository.dart';

void main() {
  late JsonTaskRepository repo;
  final testFilePath = 'test_repository_tasks.json';

  setUp(() {
    repo = JsonTaskRepository(testFilePath);
  });

  tearDown(() {
    final file = File(testFilePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Tests effectifs de la Persistance et du JsonTaskRepository', () {
    test('Ajout et écriture effective dans le fichier JSON local', () {
      final task = SimpleTask(id: 10, title: 'Persistance Test', priority: Priority.medium);
      repo.add(task);

      final file = File(testFilePath);
      expect(file.existsSync(), isTrue);
      
      final content = file.readAsStringSync();
      expect(content, contains('Persistance Test'));
    });

    test('Rechargement des données depuis le fichier JSON lors de la ré-instanciation', () {
      final task1 = SimpleTask(id: 1, title: 'Tâche 1', priority: Priority.low);
      final task2 = UrgentTask(id: 2, title: 'Tâche 2', reason: 'Panne');
      repo.add(task1);
      repo.add(task2);

      // Instanciation d'un nouveau dépôt lisant le même fichier JSON
      final newRepo = JsonTaskRepository(testFilePath);
      final loadedTasks = newRepo.getAll();

      expect(loadedTasks.length, equals(2));
      expect(loadedTasks[0].title, equals('Tâche 1'));
      expect(loadedTasks[1], isA<UrgentTask>());
    });

    test('Mise à jour d\'une tâche dans le dépôt', () {
      final task = SimpleTask(id: 5, title: 'Initiale', priority: Priority.low);
      repo.add(task);

      task.toggleCompleted();
      repo.update(task);

      final updated = repo.getAll().firstWhere((t) => t.id == 5);
      expect(updated.isCompleted, isTrue);
    });

    test('Suppression d\'une tâche du dépôt et mise à jour du fichier', () {
      final task = SimpleTask(id: 1, title: 'À supprimer', priority: Priority.medium);
      repo.add(task);
      expect(repo.getAll().length, equals(1));

      repo.delete(1);
      expect(repo.getAll().isEmpty, isTrue);
    });
  });
}