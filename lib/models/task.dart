enum Priority { low, medium, high }

// Classe abstraite de base
abstract class Task {
  final int id;
  final String title;
  final Priority priority;
  final DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  });

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.name,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}

// Sous-classe SimpleTask
class SimpleTask extends Task {
  SimpleTask({
    required super.id,
    required super.title,
    required super.priority,
    super.dueDate,
    super.isCompleted,
  });

  factory SimpleTask.fromJson(Map<String, dynamic> json) {
    return SimpleTask(
      id: json['id'] as int,
      title: json['title'] as String,
      priority: Priority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => Priority.medium,
      ),
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate'] as String) : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

// Sous-classe UrgentTask qui hérite directement de Task (demande explicite des consignes)
class UrgentTask extends Task {
  final String reason;

  UrgentTask({
    required super.id,
    required super.title,
    required this.reason,
    super.dueDate,
    super.isCompleted,
  }) : super(priority: Priority.high);

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as int,
      title: json['title'] as String,
      reason: json['reason'] as String? ?? 'Urgent',
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate'] as String) : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['reason'] = reason;
    return map;
  }
}