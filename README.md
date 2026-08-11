# Task Manager CLI

Une application robuste et performante de gestion de tâches en ligne de commande développée en **Dart**. Ce projet met en œuvre les principes de la programmation orientée objet, du découpage modulaire en couches et des tests unitaires automatisés.

---

## Description Globale

**Task Manager CLI** est un outil interactif conçu pour aider les utilisateurs à organiser, prioriser et suivre leurs tâches quotidiennes directement depuis le terminal. L'application propose une persistance des données en local via un format JSON structuré, garantissant la conservation de vos activités entre deux sessions d'utilisation. Son architecture en couches (`models`, `services`, `commands`) assure une séparation nette des responsabilités, facilitant la maintenabilité et l'évolution du code.

---

##  Fonctionnalités Principales

### 1. Ajout et Priorisation des Tâches
- **Tâches Simples et Urgentes** : Prise en charge de plusieurs types de tâches avec attributs spécifiques (description, date d'échéance, motif d'urgence).
- **Niveaux de Priorité** : Classification des tâches selon trois niveaux d'importance (*Faible*, *Moyenne*, *Haute*) pour un meilleur suivi visuel et logistique.

### 2. Consultation et Filtrage Avancé
- **Affichage Complet** : Listing clair et structuré de l'ensemble des tâches enregistrées avec leur identifiant unique et leur statut actuel.
- **Filtres Dynamiques** : Filtrage rapide par niveau de priorité ou par état d'avancement (en cours / terminée).
- **Tri Intelligent** : Organisation automatique des tâches selon leur date d'échéance ou leur niveau d'urgence.

### 3. Cycle de Vie des Tâches
- **Mise à Jour du Statut** : Marquer facilement une tâche comme terminée ou basculer son état.
- **Suppression Sécurisée** : Retrait définitif d'une tâche via son identifiant avec gestion d'erreurs en cas d'ID inexistant.

### 4. Persistance des Données Localement
- **Sauvegarde Automatique** : Enregistrement synchrone de toutes les modifications dans un fichier JSON local (`tasks.json`).
- **Restauration au Démarrage** : Chargement automatique des données au lancement de l'application avec vérification de l'intégrité du fichier.

### 5. Robustesse et Gestion des Exceptions
- **Exceptions Personnalisées** : Capture explicite des erreurs (ID introuvable, données corrompues, saisie utilisateur invalide) pour éviter les plantages inattendus du programme.

---

##  Prérequis et Installation

- **Dart SDK** >= 3.x
```bash
# Vérifier la version de Dart
dart --version

# Exécuter l'application
dart run bin/task_master.dart

# Lancer la suite complets de tests unitaires
dart test