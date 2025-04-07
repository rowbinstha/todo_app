import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/todo_provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todos"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => todoProvider.resetTodo(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress: ${todoProvider.completedTodo}/${todoProvider.totalTodo} completed',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: todoProvider.completedPercentage / 100,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 8),
                Text(
                  'Completion: ${todoProvider.completedPercentage.toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child:
                todoProvider.todo.isEmpty
                    ? Center(
                      child: Lottie.asset(
                        'assets/lottie/empty.json',
                        width: 250,
                        repeat: true,
                      ),
                    )
                    : ListView.builder(
                      itemCount: todoProvider.todo.length,
                      itemBuilder: (ctx, index) {
                        final todo = todoProvider.todo[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: ListTile(
                            onLongPress: () => todoProvider.removeTodo(todo.id),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration:
                                    todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                              ),
                            ),
                            trailing: Checkbox.adaptive(
                              value: todo.isCompleted,
                              onChanged:
                                  (_) => todoProvider.toggleTodo(todo.id),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTodoDialog(context, todoProvider),
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, TodoProvider todoProvider) {
    String newTodoTitle = '';
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Add New Todo'),
            content: TextField(
              onChanged: (value) => newTodoTitle = value,
              decoration: const InputDecoration(
                labelText: 'Todo Title',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (newTodoTitle.trim().isNotEmpty) {
                    todoProvider.addTodo(newTodoTitle.trim());
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
