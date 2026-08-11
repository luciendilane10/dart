import 'dart:io';
import 'package:test/test.dart';
import '../lib/commands/exceptions.dart';
import '../lib/services/task_repository.dart';
import '../lib/models/task.dart';

void main() {
  late JsonTaskRepository repo;
  final testFilePath = 'test_exceptions.json';

  setUp(() {
    repo = JsonTaskRepository(testFilePath);
  });

  tearDown(() {
    final file = File(testFilePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Tests des Exceptions Personnalisées', () {
    test('TaskNotFoundException est levée lors de la suppression d\'un ID inexistant', () {
      expect(
        () => repo.delete(999),
        throwsA(isA<TaskNotFoundException>()),
      );
    });

    test('TaskNotFoundException est levée lors de la mise à jour d\'un ID inexistant', () {
      final fakeTask = SimpleTask(id: 888, title: 'Inexistante', priority: Priority.low);
      expect(
        () => repo.update(fakeTask),
        throwsA(isA<TaskNotFoundException>()),
      );
    });

    test('Verification de la hiérarchie d\'héritage des exceptions', () {
      final exception = TaskNotFoundException('Tâche non trouvée');
      expect(exception, isA<TaskException>());
      expect(exception.toString(), equals('Tâche non trouvée'));
    });
  });
}