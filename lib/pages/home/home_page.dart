import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
    expandedHeight: 200.h,
    floating: false,
    pinned: true,

    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.greenAccent,
    flexibleSpace: FlexibleSpaceBar(
      title: Text('Task Management app',style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.bold),),
      background: Container(
        decoration: BoxDecoration(
          //image: DecorationImage(image: AssetImage('assets/images/nav1.png'),fit: BoxFit.cover),
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 7, 9, 107),
            Color.fromARGB(255, 28, 48, 78)
          ])
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 150.w,
                height: 150.w,
                child: Image(image: AssetImage('assets/images/logo2.png'),fit: BoxFit.cover,)
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(subText??'',style: TextStyle(color: Color.fromARGB(255, 39, 43, 44),fontSize: 10.sp,fontWeight: FontWeight.bold),),
              // ),
            ],
          ),
        ),
      ),
    ),

    //title:Text(title??''),
    actions: [
      IconButton(onPressed: (){

      }, icon:Icon(Icons.menu))
    ],
  ),
          SliverToBoxAdapter(
            child: Container(
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
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _homeController.tasks.length,
                    itemBuilder: (context, index) {
                      var task = _homeController.tasks[index];
                      return Container(
  margin: EdgeInsets.symmetric(vertical: 8.0),
  padding: EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 3,
        offset: Offset(0, 2), // changes position of shadow
      ),
    ],
  ),
  child: InkWell(
    onTap: () {
      print(task.title);
      Get.toNamed('/task', arguments: task);
    },
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            _homeController.updateTaskCompletion(task, value ?? false);
          },
        ),
      ],
    ),
  ),
);

                    },
                  );
                }
              }),
            ),
          ),
        ],
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
