import 'package:flutter/material.dart';
import 'package:todo_api_bloc/api/repository.dart';
import 'package:todo_api_bloc/screen/todo_list.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final TodoRepository todoRepository = TodoRepository();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
          style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(style: TextStyle(color: Colors.black),
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo, width: 2),
              ),
            ),
            maxLength: 50,
          ),
          TextField(style: TextStyle(color: Colors.black),
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo, width: 2),
              ),
            ),
            maxLength: 500,
            minLines: 5,
            maxLines: 10,
          ),
          SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
            ),
            onPressed: () => isEdit ? updateTodo() : submitTodo(),
            child: Text(isEdit ? 'Update' : 'Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> submitTodo() async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      showErrorMessage("Title and Description cannot be empty");
      return;
    }

    try {
      final statusCode = await todoRepository.createTodo(title, description);
      if (statusCode == 201) {
        showSuccessMessage('Todo Created Successfully');
        Navigator.pop(context, true); // Pop and refresh the todo list page
      } else {
        showErrorMessage('Failed to Create Todo');
      }
    } catch (e) {
      showErrorMessage('Error occurred: $e');
    }
  }

  Future<void> updateTodo() async {
    final todo = widget.todo;
    if (todo == null) return;

    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      showErrorMessage("Title and Description cannot be empty");
      return;
    }

    try {
      final statusCode = await todoRepository.updateTodo(id, title, description);
      if (statusCode == 200) {
        showSuccessMessage('Todo Updated Successfully');
        Navigator.pop(context, true); // Pop and refresh the todo list page
      } else {
        showErrorMessage('Failed to Update Todo');
      }
    } catch (e) {
      showErrorMessage('Error occurred: $e');
    }
  }

  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.green)),
      ),
    );
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
