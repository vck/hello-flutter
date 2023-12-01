import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/todo_list.dart';



class AddTodoPage extends StatefulWidget {
    const AddTodoPage({Key? key}) : super(key: key);

    @override
    State<AddTodoPage> createState() => _AddTodoPageState();   
}


class _AddTodoPageState extends State<AddTodoPage> {

    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Add Todo'),
            ),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                            hintText: 'Enter Todo Title',
                        ),
                    ),
                    TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: 'Enter Todo Description',
                        ),
                        minLines: 5,
                        maxLines: 8,
                        keyboardType: TextInputType.multiline,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {
                            submit();
                        },
                        child: const Text('Submit'),
                    ),
                ]
            )
        );
    }

    Future<void> submit() async {
        final title = _titleController.text;
        final description = _descriptionController.text;

        final body = {
            'text': title,
            'desc': description,
            'status': false
        };
        print('Title: $title');
        print('Description: $description');

        final response = await http.post(
            Uri.parse('http://localhost:5000/items'),
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'}   
        );

        print(response.statusCode);
        print(response.body);

        if(response.statusCode == 201){
            _titleController.text = '';
            _descriptionController.text = '';
            showSuccessMessage();
        }else{
            showFailedMessage();
            print("Failed to add todo");
        }
    }

    void showSuccessMessage(){
        final snackBar = SnackBar(
            content: const Text('Todo Added Successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void showFailedMessage(){
        final snackBar = SnackBar(
            content: const Text('Failed to Add Todo'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void navigateToMainPage() {
        final route = MaterialPageRoute(builder: (context) => TodoListPage());
        Navigator.push(context, route);
  }
    
}