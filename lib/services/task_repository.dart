import 'dart:convert';
import 'dart:io';
import '../models/task.dart';
import '../commands/exceptions.dart';

// Interface pure avec Générique <T> (aucune implémentation)
abstract class Repository<T> {
  void add(T item);
  List<T> getAll();
  void update(T item);
  void delete(int id);
}

// Implémentation explicite de l'interface via 'implements'
class JsonTaskRepository implements Repository<Task> {
  final String filePath;
  List<Task> _tasks = [];

  JsonTaskRepository(this.filePath) {
    _loadFromFile();
  }

  void _loadFromFile() {
    final file = File(filePath);
    if (!file.existsSync()) {
      _tasks = [];
      return;
    }

    try {
      final content = file.readAsStringSync();
      if (content.trim().isEmpty) {
        _tasks = [];
        return;
      }

      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      _tasks = jsonList.map((json) {
        final map = json as Map<String, dynamic>;
        if (map.containsKey('reason') && map['reason'] != null) {
          return UrgentTask.fromJson(map);
        } else {
          return SimpleTask.fromJson(map);
        }
      }).toList();
    } catch (e) {
      _tasks = [];
    }
  }

  void _saveToFile() {
    final file = File(filePath);
    final jsonList = _tasks.map((task) => task.toJson()).toList();
    file.writeAsStringSync(jsonEncode(jsonList));
  }

  @override
  void add(Task item) {
    _tasks.add(item);
    _saveToFile();
  }

  @override
  List<Task> getAll() {
    return List.unmodifiable(_tasks);
  }

  List<Task> getAllSortedByPriority() {
    final sorted = List<Task>.from(_tasks);
    sorted.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return sorted;
  }

  List<Task> getAllSortedByDate() {
    final sorted = List<Task>.from(_tasks);
    sorted.sort((a, b) {
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sorted;
  }

  @override
  void update(Task item) {
    final index = _tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) {
      throw TaskNotFoundException('Tâche ID ${item.id} introuvable.');
    }
    _tasks[index] = item;
    _saveToFile();
  }

  @override
  void delete(int id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw TaskNotFoundException('Tâche ID $id introuvable.');
    }
    _tasks.removeAt(index);
    _saveToFile();
  }
}