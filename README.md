# Task Manager CLI

Une application robuste et performante de gestion de tâches en ligne de commande développée en **Dart pur (sans Flutter)**. Ce projet met en œuvre les principes fondamentaux de la programmation orientée objet (POO), du découpage modulaire en couches, l'utilisation de classes abstraites, d'interfaces et de génériques, ainsi qu'une suite complète de tests unitaires automatisés.

---

## 📝 Description Globale du Projet

**Task Manager CLI** est un outil interactif conçu pour aider les utilisateurs à organiser, prioriser et suivre leurs tâches quotidiennes directement depuis leur terminal. L'application intègre une persistance synchrone des données en local au format JSON (`tasks.json`), garantissant la conservation de l'état de l'application entre chaque session d'utilisation.

L'application est structurée selon une architecture modulaire stricte (`models`, `services`, `commands`, `test`), garantissant la séparation des responsabilités, la maintenabilité du code et une facilité d'extension.

---

## 🚀 Description Détaillée des Fonctionnalités

### 1. Ajout de Tâches (`addTask`)
L'utilisateur peut ajouter deux types distincts de tâches dans le système :
- **Tâches Simples (`SimpleTask`)** :
  - **Titre** : Intitulé explicite de la tâche (champ obligatoire, non vide).
  - **Niveau de Priorité** : Sélection parmi trois niveaux (`1: low`, `2: medium`, `3: high`). Par défaut, le niveau est configuré sur `medium`.
  - **Date Limite (Optionnelle)** : Saisie d'une date d'échéance au format standard `AAAA-MM-JJ`.
- **Tâches Urgentes (`UrgentTask`)** :
  - La tâche urgente hérite directement de la classe de base, est automatiquement assignée au niveau de priorité le plus élevé (`high`), et requiert la saisie d'un **motif d'urgence** spécifique (`reason`).
  - Elle accepte également une date limite optionnelle.

### 2. Consultation et Tri des Tâches (`listTasks`)
L'application permet d'afficher l'ensemble des tâches enregistrées avec un indicateur visuel de leur état d'avancement (`[✔]` pour terminée, `[ ]` pour en cours). Trois modes d'affichage et de tri sont proposés à l'utilisateur :
- **Ordre par défaut** : Affichage selon l'ordre d'insertion ou d'enregistrement.
- **Tri par priorité** : Tri décroissant organisant les tâches de la plus urgente à la moins urgente (`High` ➔ `Medium` ➔ `Low`).
- **Tri par date limite** : Organisation chronologique basée sur la date d'échéance (`dueDate`). Les tâches sans date limite sont placées en fin de liste.

### 3. Marquer une Tâche comme Terminée (`toggleTaskCompletion`)
- L'utilisateur saisit l'identifiant numérique (`id`) de la tâche à modifier.
- L'application applique la méthode `toggleCompleted()` qui bascule l'état de la tâche (de `en cours` à `terminée` ou inversement).
- Le changement d'état est immédiatement répercuté et sauvegardé dans le fichier JSON local.

### 4. Suppression de Tâches (`deleteTask`)
- Permet de retirer définitivement une tâche du système via son identifiant numérique unique (`id`).
- Si l'ID saisi n'existe pas dans la base, une exception personnalisée `TaskNotFoundException` est automatiquement levée et interceptée sans faire planter l'application.

### 5. Persistance Automatique des Données Localement
- **Sauvegarde Synchrone** : Chaque modification (création, mise à jour, suppression) déclenche l'écriture automatique de l'état complet de la liste dans le fichier `tasks.json`.
- **Chargement au Démarrage** : À l'initialisation de l'application, le dépôt lit le fichier JSON local, analyse le contenu et reconstruit dynamiquement les instances de `SimpleTask` et `UrgentTask`.

---

## 🛠️ Description Détaillée des Exigences Techniques

### 1. Classes Abstraites et Héritage
- **Classe Abstraite `Task`** : Définit le contrat et les attributs communs à toutes les tâches (`id`, `title`, `priority`, `dueDate`, `isCompleted`), ainsi que les méthodes partagées (`toggleCompleted()`, `toJson()`).
- **Héritage Direct (`Task` ➔ `UrgentTask` / `SimpleTask`)** :
  - `SimpleTask` hérite de `Task` et implémente la méthode de fabrique `fromJson` pour la désérialisation.
  - `UrgentTask` hérite directement de `Task` avec l'extension d'un attribut dédié (`reason`) et une priorité fixée à `high`.

### 2. Implémentation d'une Interface
- **Interface `Repository<T>`** : Une classe abstraite pure ne contenant aucune implémentation de méthode. Elle définit les signatures obligatoires pour toute source de données (`add`, `getAll`, `update`, `delete`).
- **Contrat `implements`** : La classe `JsonTaskRepository` implémente explicitement cette interface (`class JsonTaskRepository implements Repository<Task>`).

### 3. Utilisation des Génériques (`<T>`)
- L'interface du dépôt utilise un paramètre de type générique `<T>` (`Repository<T>`), permettant de définir un contrat de persistance réutilisable pour n'importe quel modèle de données.

### 4. Gestion des Erreurs et Exceptions Personnalisées
L'application définit une hiérarchie d'exceptions dérivées de `TaskException` dans `lib/commands/exceptions.dart` :
- `TaskNotFoundException` : Levée lors de la recherche ou suppression d'un ID inexistant.
- `InvalidTaskException` : Levée lors de saisies utilisateur incorrectes (titre vide, format de date ou d'ID invalide).
- `StorageException` : Levée en cas d'erreur de lecture ou d'écriture du fichier JSON.

### 5. Suite de Tests Unitaires (Package `test`)
Le projet contient **5 fichiers de tests unitaires distincts** situés dans le dossier `test/` pour garantir une couverture complète :
1. `test/task_model_test.dart` : Vérifie l'instanciation, le changement d'état et la sérialisation des modèles.
2. `test/task_repository_test.dart` : Vérifie les opérations CRUD du dépôt JSON.
3. `test/task_service_test.dart` : Valide les algorithmes de tri par priorité et par date.
4. `test/task_exceptions_test.dart` : Valide la levée conforme des exceptions personnalisées.
5. `test/task_master_test.dart` : Vérifie le point d'entrée et l'exécutabilité de l'application CLI.

---

## 📂 Architecture du Projet

```text
.
├── .gitignore
├── CHANGELOG.md
├── README.md
├── analysis_options.yaml
├── pubspec.yaml
├── task.json
├── tasks.json
├── bin/
│   └── task_master.dart
├── lib/
│   ├── commands/
│   │   ├── exceptions.dart
│   │   └── task.dart
│   ├── models/
│   │   └── task.dart
│   └── services/
│       └── task_repository.dart
└── test/
    ├── task_exceptions_test.dart
    ├── task_master_test.dart
    ├── task_model_test.dart
    ├── task_repository_test.dart
    └── task_service_test.dart