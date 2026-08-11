import 'package:test/test.dart';
import '../lib/models/task.dart';

void main() {
  group('Tests des Modèles Task, SimpleTask et UrgentTask', () {
    test('SimpleTask instanciation et méthode toggleCompleted', () {
      final task = SimpleTask(
        id: 1,
        title: 'Acheter du pain',
        priority: Priority.low,
      );

      expect(task.id, equals(1));
      expect(task.title, equals('Acheter du pain'));
      expect(task.priority, equals(Priority.low));
      expect(task.isCompleted, isFalse);

      task.toggleCompleted();
      expect(task.isCompleted, isTrue);
    });

    test('UrgentTask hérite de Task et possède une priorité High et une raison', () {
      final urgentTask = UrgentTask(
        id: 2,
        title: 'Payer la facture d\'électricité',
        reason: 'Coupure imminente',
      );

      expect(urgentTask.id, equals(2));
      expect(urgentTask.priority, equals(Priority.high));
      expect(urgentTask.reason, equals('Coupure imminente'));
    });

    test('Sérialisation et Désérialisation JSON de SimpleTask', () {
      final task = SimpleTask(
        id: 3,
        title: 'Réviser le cours Dart',
        priority: Priority.high,
        dueDate: DateTime(2026, 12, 31),
      );

      final json = task.toJson();
      expect(json['id'], equals(3));
      expect(json['priority'], equals('high'));

      final restoredTask = SimpleTask.fromJson(json);
      expect(restoredTask.title, equals('Réviser le cours Dart'));
      expect(restoredTask.dueDate, equals(DateTime(2026, 12, 31)));
    });

    test('Sérialisation et Désérialisation JSON de UrgentTask', () {
      final task = UrgentTask(
        id: 4,
        title: 'Urgence Serveur',
        reason: 'Panne réseau',
      );

      final json = task.toJson();
      expect(json['reason'], equals('Panne réseau'));

      final restored = UrgentTask.fromJson(json);
      expect(restored.reason, equals('Panne réseau'));
      expect(restored.priority, equals(Priority.high));
    });
  });
}