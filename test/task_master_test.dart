import 'dart:io';
import 'package:test/test.dart';
import '../bin/task_master.dart' as app;
import '../lib/commands/task.dart';
import '../lib/models/task.dart';
import '../lib/services/task_repository.dart';

void main() {
  group('Tests d\'intégration CLI et du point d\'entrée task_master', () {
    test('La fonction main existe et est de type Function', () {
      expect(app.main, isA<Function>());
    });

    test('Intégration globale entre TaskCommandHandler et JsonTaskRepository', () {
      final testPath = 'test_integration.json';
      final repo = JsonTaskRepository(testPath);
      final handler = TaskCommandHandler(repo);

      expect(handler.repository, equals(repo));

      final task = SimpleTask(id: 100, title: 'Test Intégration', priority: Priority.medium);
      repo.add(task);

      expect(repo.getAll().length, equals(1));
      expect(repo.getAll().first.title, equals('Test Intégration'));

      // Nettoyage
      final file = File(testPath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  });
}