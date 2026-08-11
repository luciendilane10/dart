import 'dart:io';
import 'package:test/test.dart';
import '../lib/commands/exceptions.dart';
import '../lib/services/task_repository.dart';

void main() {
  late JsonTaskRepository repo;
  final testFilePath = 'test_exceptions_tasks.json';

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
    test('Levée de TaskNotFoundException lors de la suppression d\'un ID inexistant', () {
      expect(
        () => repo.delete(999),
        throwsA(isA<TaskNotFoundException>()),
      );
    });
  });
}