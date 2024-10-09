import 'package:flutter/material.dart';
import 'package:todo_api_bloc/api/repository.dart';
import 'package:todo_api_bloc/screen/addpage.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoRepository todoRepository = TodoRepository();
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'my',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'Todo',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        ),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(color: Colors.indigo),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'];
              return Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ListTile(
                  title: Text(item['title'], style: TextStyle(color: Colors.black)),
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        navigatToEdit(item);
                      } else if (value == 'delete') {
                        deleteById(id);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigatToAdd,
        label: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchTodo() async {
    try {
      final todos = await todoRepository.fetchTodos(1, 10);
      setState(() {
        items = todos;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteById(String id) async {
    try {
      final statusCode = await todoRepository.deleteTodoById(id);
      if (statusCode == 200) {
        final filtered = items.where((element) => element['_id'] != id).toList();
        setState(() {
          items = filtered;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> navigatToAdd() async {
    final route = MaterialPageRoute(builder: (context) => AddToDoPage());
    await Navigator.push(context, route);
  }

  void navigatToEdit(Map item) {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(todo: item),
    );
    Navigator.push(context, route);
  }
}
