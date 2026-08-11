// Exception de base abstraite pour l'application
abstract class TaskException implements Exception {
  final String message;
  TaskException(this.message);

  @override
  String toString() => message;
}

// Exception levée lorsqu'une tâche est introuvable
class TaskNotFoundException extends TaskException {
  TaskNotFoundException(super.message);
}

// Exception levée lorsqu'une saisie ou donnée de tâche est invalide
class InvalidTaskException extends TaskException {
  InvalidTaskException(super.message);
}

// Exception levée lors d'un problème d'accès ou de formatage du fichier JSON
class StorageException extends TaskException {
  StorageException(super.message);
}