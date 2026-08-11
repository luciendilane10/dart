import 'package:test/test.dart';
import '../lib/models/task.dart';

void main() {
  group('Tests des Modèles Task', () {
    test('Création d\'une SimpleTask et passage à l\'état terminé', () {
      final task = SimpleTask(
        id: 1,
        title: 'Faire les courses',
        priority: Priority.medium,
      );

      expect(task.id, equals(1));
      expect(task.title, equals('Faire les courses'));
      expect(task.isCompleted, isFalse);

      task.toggleCompleted();
      expect(task.isCompleted, isTrue);
    });

    test('Création d\'une UrgentTask et conversion JSON', () {
      final urgentTask = UrgentTask(
        id: 2,
        title: 'Rendre le rapport',
        reason: 'Date limite dépassée',
      );

      expect(urgentTask.priority, equals(Priority.high));
      expect(urgentTask.reason, equals('Date limite dépassée'));

      final json = urgentTask.toJson();
      expect(json['reason'], equals('Date limite dépassée'));
      expect(json['priority'], equals('high'));
    });
  });
}