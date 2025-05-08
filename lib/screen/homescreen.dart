import 'package:flutter/material.dart';
import '../models/todo.dart';
import './aboutscreen.dart';

enum Filter { all, done, notDone }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> todos = [];
  Filter _filter = Filter.all;
  final TextEditingController _controller = TextEditingController();

  List<Todo> get _filteredTodos {
    switch (_filter) {
      case Filter.done:
        return todos.where((t) => t.isDone).toList();
      case Filter.notDone:
        return todos.where((t) => !t.isDone).toList();
      default:
        return todos;
    }
  }

  void _addTodo() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      todos.add(Todo(title: _controller.text.trim()));
      _controller.clear();
    });
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _filteredTodos[index].isDone = !_filteredTodos[index].isDone;
    });
  }

  void _changeFilter(Filter newFilter) {
    setState(() {
      _filter = newFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredTodos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List App'),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          PopupMenuButton<Filter>(
            onSelected: _changeFilter,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Filter.all,
                child: Text('Semua'),
              ),
              const PopupMenuItem(
                value: Filter.done,
                child: Text('Selesai'),
              ),
              const PopupMenuItem(
                value: Filter.notDone,
                child: Text('Belum Selesai'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tambah tugas...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addTodo,
                )
              ],
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('Tidak ada tugas.'))
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final todo = filteredList[index];
                      return CheckboxListTile(
                        title: Text(todo.title),
                        value: todo.isDone,
                        onChanged: (_) => _toggleTodoStatus(index),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
