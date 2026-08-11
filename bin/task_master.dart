import 'dart:io';
import '../lib/commands/exceptions.dart';
import '../lib/commands/task.dart';
import '../lib/services/task_repository.dart';

void main() {
  final repository = JsonTaskRepository('tasks.json');
  final handler = TaskCommandHandler(repository);

  print('========================================');
  print('     GESTIONNAIRE DE TÂCHES CLI');
  print('========================================');

  bool running = true;

  while (running) {
    print('\n--- MENU PRINCIPAL ---');
    print('1. Ajouter une tâche');
    print('2. Lister les tâches');
    print('3. Marquer une tâche comme terminée/en cours');
    print('4. Supprimer une tâche');
    print('5. Quitter');
    stdout.write('Choisissez une option [1-5] : ');

    final input = stdin.readLineSync()?.trim() ?? '';

    try {
      switch (input) {
        case '1':
          handler.addTask();
          break;
        case '2':
          handler.listTasks();
          break;
        case '3':
          handler.toggleTaskCompletion();
          break;
        case '4':
          handler.deleteTask();
          break;
        case '5':
          print('\nAu revoir !');
          running = false;
          break;
        default:
          print('⚠️ Option invalide. Veuillez choisir un chiffre entre 1 et 5.');
          break;
      }
    } on TaskException catch (e) {
      print('❌ Erreur : ${e.message}');
    } catch (e) {
      print('❌ Une erreur inattendue est survenue : $e');
    }
  }
}