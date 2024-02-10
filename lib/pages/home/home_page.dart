import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:int_todo_app/pages/home/home_controller.dart';
import 'package:int_todo_app/services/auth_controller.dart';

import '../../classes/task.dart';

class HomePage extends StatelessWidget {
  final HomeController _homeController = Get.find();
  final AuthController _authController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management App'),
        actions: [
          IconButton(
            onPressed: () {
              _authController.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Obx(() {
          if (_homeController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (_homeController.tasks.isEmpty) {
            return Center(
              child: Text('No tasks yet.'),
            );
          } else {
            return ListView.builder(
              itemCount: _homeController.tasks.length,
              itemBuilder: (context, index) {
                var task = _homeController.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      _homeController.updateTaskCompletion(task, value ?? false);
                    },
                  ),
                  onTap: () {
                    print(task.title);
                    Get.toNamed('/task', arguments: task);
                  },
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              ListTile(
                title: Text('Due Date'),
                subtitle: Text(
                  '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    selectedDate = pickedDate;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _homeController.addTask(
                  Task(
                    title: titleController.text,
                    description: descriptionController.text,
                    isCompleted: false,
                    dueDate: selectedDate,
                   
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
