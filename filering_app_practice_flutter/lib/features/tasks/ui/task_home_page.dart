import 'package:flutter/material.dart';
import 'package:taskmate_app_flutter/core/storage/settings_store.dart';

enum TaskFilter { today, upcoming, completed, all }

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  TaskFilter _selectedFilter = TaskFilter.today;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMate'),
        actions: [
          PopupMenuButton<TaskFilter>(
            initialValue: _selectedFilter,
            onSelected: (value) {
              setState(() => _selectedFilter = value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: TaskFilter.today,
                child: Text('Today'),
              ),
              PopupMenuItem(
                value: TaskFilter.upcoming,
                child: Text('Upcoming'),
              ),
              PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completed'),
              ),
              PopupMenuItem(
                value: TaskFilter.all,
                child: Text('All'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New Task (coming soon)')),
          );
        },
        child: const Icon(Icons.add),
      ),
      // Logic to switch between onboarding and the main task list
      body: SettingsStore.isFirstOpen
          ? _FirstOpenState(onContinue: () async {
              await SettingsStore.setFirstOpenFalse();
              if (context.mounted) setState(() {});
            })
          : _EmptyState(filter: _selectedFilter),
    );
  }
}

// --- Displayed when there are no tasks for the selected filter ---
class _EmptyState extends StatelessWidget {
  final TaskFilter filter;
  const _EmptyState({required this.filter});

  String get title {
    switch (filter) {
      case TaskFilter.today:
        return 'No tasks for today';
      case TaskFilter.upcoming:
        return 'No upcoming tasks';
      case TaskFilter.completed:
        return 'No completed tasks yet';
      case TaskFilter.all:
        return 'No tasks yet';
    }
  }

  String get subtitle {
    switch (filter) {
      case TaskFilter.today:
        return 'Add a task you want to finish today.';
      case TaskFilter.upcoming:
        return 'Plan ahead by adding a due date.';
      case TaskFilter.completed:
        return 'Complete tasks to see them here.';
      case TaskFilter.all:
        return 'Tap + to create your first task.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Displayed only the very first time the app is opened ---
class _FirstOpenState extends StatelessWidget {
  final Future<void> Function() onContinue;
  const _FirstOpenState({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.waving_hand,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Welcome to TaskMate!',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'This message shows only the first time.\nTap continue to get started!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => onContinue(),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}