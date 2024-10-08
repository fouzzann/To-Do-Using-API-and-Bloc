import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:todo_api_bloc/screen/addpage.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'my',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: 'Todo',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ]),
        ),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isloading,
        child: Center(
          child: CircularProgressIndicator(color: Colors.indigo,),
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
                    title: Text(item['title'],style: TextStyle(color: Colors.black),),
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(onSelected: (value) {
                      if (value == 'edit') {
                        // open edit page
                      } else if (value == 'delete') {
                        //delete remove the item
                        deleateById(id);
                      }
                    }, itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                            value: 'edit',
                            child: TextButton(
                                onPressed: () {
                                  navigatToEdit(item);
                                },
                                child: Text('Edit'))),
                        PopupMenuItem(
                            value: 'delete',
                            child: TextButton(
                                onPressed: () {
                                  deleateById(id);
                                },
                                child: Text('Delete'))),
                      ];
                    }),
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigatToAdd, label: const Icon(Icons.add)),
    );
  }

  Future<void> navigatToAdd() async {
    final route = MaterialPageRoute(builder: (context) => AddToDoPage());
    await Navigator.push(context, route);
  }

  void navigatToEdit(Map item) {
    final route = MaterialPageRoute(
        builder: (context) => AddToDoPage(
              todo: item,
            ));
    Navigator.push(context, route);
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final responce = await http.get(uri);
    if (responce.statusCode == 200) {
      final json = jsonDecode(responce.body) as Map;
      final result = json['items'];
      setState(() {
        items = result;
      });
    } else {
     
    }
    setState(() {
      isloading = false;
    });
  }

  Future<void> deleateById(String id) async {
    
    final url = 'https://api.nstack.in/v1/todos/$id';


    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {}
  }
}
