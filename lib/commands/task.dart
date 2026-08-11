import 'dart:io';
import '../models/task.dart';
import '../services/task_repository.dart';
import 'exceptions.dart';

class TaskCommandHandler {
  final JsonTaskRepository repository;

  TaskCommandHandler(this.repository);

  int _generateNextId() {
    final tasks = repository.getAll();
    if (tasks.isEmpty) return 1;
    return tasks.map((t) => t.id).reduce((max, id) => id > max ? id : max) + 1;
  }

  // Fonctionnalité 1 : Ajouter une tâche
  void addTask() {
    print('\n--- AJOUTER UNE TÂCHE ---');
    
    stdout.write('Titre de la tâche : ');
    final title = stdin.readLineSync()?.trim() ?? '';
    if (title.isEmpty) {
      throw InvalidTaskException('Le titre de la tâche ne peut pas être vide.');
    }

    stdout.write('Est-ce une tâche urgente ? (o/n) : ');
    final isUrgentInput = stdin.readLineSync()?.trim().toLowerCase() ?? 'n';
    final isUrgent = isUrgentInput == 'o' || isUrgentInput == 'oui';

    stdout.write('Date limite (AAAA-MM-JJ) [Optionnelle, Entrée pour passer] : ');
    final dateInput = stdin.readLineSync()?.trim() ?? '';
    DateTime? dueDate;
    if (dateInput.isNotEmpty) {
      dueDate = DateTime.tryParse(dateInput);
      if (dueDate == null) {
        throw InvalidTaskException('Format de date invalide. Utilisez AAAA-MM-JJ.');
      }
    }

    final id = _generateNextId();

    if (isUrgent) {
      stdout.write('Motif de l\'urgence : ');
      final reason = stdin.readLineSync()?.trim() ?? 'Urgent';
      final task = UrgentTask(
        id: id,
        title: title,
        reason: reason.isEmpty ? 'Urgent' : reason,
        dueDate: dueDate,
      );
      repository.add(task);
      print('✅ Tâche urgente ajoutée avec succès ! (ID: $id)');
    } else {
      stdout.write('Priorité (1: low, 2: medium, 3: high) [Défaut: medium] : ');
      final priorityInput = stdin.readLineSync()?.trim() ?? '2';
      Priority priority;
      switch (priorityInput) {
        case '1':
          priority = Priority.low;
          break;
        case '3':
          priority = Priority.high;
          break;
        case '2':
        default:
          priority = Priority.medium;
          break;
      }

      final task = SimpleTask(
        id: id,
        title: title,
        priority: priority,
        dueDate: dueDate,
      );
      repository.add(task);
      print('✅ Tâche simple ajoutée avec succès ! (ID: $id)');
    }
  }

  // Fonctionnalité 2 : Lister toutes les tâches (avec tri)
  void listTasks() {
    print('\n--- LISTE DES TÂCHES ---');
    print('1. Ordre par défaut');
    print('2. Trier par priorité (High -> Low)');
    print('3. Trier par date limite');
    stdout.write('Choix du tri [1-3] : ');
    final choice = stdin.readLineSync()?.trim() ?? '1';

    List<Task> tasks;
    switch (choice) {
      case '2':
        tasks = repository.getAllSortedByPriority();
        break;
      case '3':
        tasks = repository.getAllSortedByDate();
        break;
      case '1':
      default:
        tasks = repository.getAll();
        break;
    }

    if (tasks.isEmpty) {
      print('Aucune tâche enregistrée.');
      return;
    }

    for (final task in tasks) {
      final status = task.isCompleted ? '[✔]' : '[ ]';
      final dateStr = task.dueDate != null 
          ? ' (Échéance: ${task.dueDate.toString().split(' ')[0]})' 
          : '';
      
      if (task is UrgentTask) {
        print('$status ID: ${task.id} | [URGENT: ${task.reason}] ${task.title}$dateStr');
      } else {
        print('$status ID: ${task.id} | [${task.priority.name.toUpperCase()}] ${task.title}$dateStr');
      }
    }
  }

  // Fonctionnalité 3 : Marquer une tâche comme terminée
  void toggleTaskCompletion() {
    print('\n--- MARQUER UNE TÂCHE COMME TERMINÉE ---');
    stdout.write('ID de la tâche à basculer : ');
    final idInput = stdin.readLineSync()?.trim() ?? '';
    final id = int.tryParse(idInput);
    
    if (id == null) {
      throw InvalidTaskException('L\'ID doit être un nombre valide.');
    }

    final tasks = repository.getAll();
    final task = tasks.firstWhere(
      (t) => t.id == id,
      orElse: () => throw TaskNotFoundException('Tâche ID $id introuvable.'),
    );

    task.toggleCompleted();
    repository.update(task);
    
    final state = task.isCompleted ? 'terminée' : 'en cours';
    print('✅ La tâche ID $id est maintenant marquée comme $state.');
  }

  // Fonctionnalité 4 : Supprimer une tâche
  void deleteTask() {
    print('\n--- SUPPRIMER UNE TÂCHE ---');
    stdout.write('ID de la tâche à supprimer : ');
    final idInput = stdin.readLineSync()?.trim() ?? '';
    final id = int.tryParse(idInput);

    if (id == null) {
      throw InvalidTaskException('L\'ID doit être un nombre valide.');
    }

    repository.delete(id);
    print('✅ Tâche ID $id supprimée avec succès.');
  }
}