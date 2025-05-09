import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> todos = [];
  final TextEditingController todoController = TextEditingController();
  String quote = "Loading quote...";
  String backgroundUrl =
      'https://source.unsplash.com/600x800/?colorful,abstract,nature';

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    try {
      final response =
          await http.get(Uri.parse('https://zenquotes.io/api/today'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          quote = data[0]['q'] + ' — ' + data[0]['a'];
        });
      } else {
        setState(() {
          quote = "Failed to load quote.";
        });
      }
    } catch (e) {
      setState(() {
        quote = "Error: Unable to fetch quote.";
      });
    }
  }

  void addTodo(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        todos.add(text.trim());
      });
      todoController.clear();
    }
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            backgroundUrl,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'TodoListApp',
                    style: GoogleFonts.pacifico(
                      fontSize: 36,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black54)
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quote,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: todoController,
                          decoration: InputDecoration(
                            hintText: 'Tambahkan tugas...',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => addTodo(todoController.text),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: todos.isEmpty
                        ? Center(
                            child: Text(
                              "Belum ada tugas 😄",
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white.withOpacity(0.9),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  title: Text(
                                    todos[index],
                                    style: GoogleFonts.quicksand(),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => removeTodo(index),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Tema: ",
                          style: TextStyle(color: Colors.white)),
                      DropdownButton<ThemeMode>(
                        value: themeProvider.themeMode,
                        dropdownColor: Colors.grey[850],
                        items: ThemeMode.values.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(
                              mode.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (mode) {
                          if (mode != null) {
                            themeProvider.toggleTheme(
                              mode,
                              seedColor: Colors.pinkAccent,
                              brightness: mode == ThemeMode.dark
                                  ? Brightness.dark
                                  : Brightness.light,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
