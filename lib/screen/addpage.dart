import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo_api_bloc/screen/todo_list.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController tittlecontroller = TextEditingController();
  TextEditingController discreptioncontroller = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final descirption = todo['description'];
      tittlecontroller.text = title;
      discreptioncontroller.text = descirption;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      leading: IconButton(onPressed: (){Get.back();
      }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Text(isEdit ? 'edit todo ' : 'add todo',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ), 


      body: ListView(
        children: [
          TextField(style: TextStyle(color: Colors.white),
            maxLength: 50,
            controller: tittlecontroller,
            decoration: InputDecoration(hintText: 'Title',
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.indigo,
            width: 2))
            ),
          ),
          TextField(style: TextStyle(color: Colors.black),
            maxLength: 500,
            controller: discreptioncontroller,
            decoration: InputDecoration(hintText: 'Discreption',
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.indigo,
            width: 2))
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
            
          ),
          SizedBox(
            height: 18,
          ),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
  onPressed: () {
 
    if (isEdit) {
      updatedData();
    } else {
      submitData();
    }
 Get.to(TodoListPage());
  },
  child: Text(isEdit ? 'Update' : 'Submit',style: TextStyle(color: Colors.white),),
)
        ],
      ),
    );
  }

  Future<void> updatedData() async {
    final todo = widget.todo;
    if (widget.todo == null) {
      return;
    }
    final id = todo!['_id'];
   
    final title = tittlecontroller.text;
    final description = discreptioncontroller.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final responce = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (responce.statusCode == 200) {
      tittlecontroller.text = '';
      discreptioncontroller.text = '';
      showSuceesMessage('updated succes');
    }
  }

  void submitData() async {
    //get the data from form
    final title = tittlecontroller.text;
    final description = discreptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    //submit data to the server

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      tittlecontroller.text = '';
      discreptioncontroller.text = '';
      showSuceesMessage('creation succes');
      print(response.body);
    } else {
      showSuceesMessage('creation field');
    }
    // show success of fail message based on status
  }

  void showSuceesMessage(String messege) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        messege,
        style: TextStyle(color: Colors.green),
      ),
    ));
  }
}
