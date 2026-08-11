import 'package:test/test.dart';
import '../bin/task_master.dart' as app;

void main() {
  group('Tests du point d\'entrée CLI', () {
    test('Vérification de l\'existence de la fonction main', () {
      expect(app.main, isA<Function>());
    });
  });
}
