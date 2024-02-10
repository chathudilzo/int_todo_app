import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:int_todo_app/classes/task.dart';
import 'package:int_todo_app/pages/task/task_controller.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskController _taskController = Get.find();

  late Task task;

  @override
  void initState() {
    super.initState();
    task = Get.arguments as Task;
    _taskController.setTask(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            onPressed: () {
              _showEditDialog(context, task);
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _showDeleteConfirmationDialog(context, task);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Container(
  padding: EdgeInsets.all(16.0),
  child: Obx(
    () {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskDetail(
            'Title',
            _taskController.task.value?.title ?? task.title,
            Icons.title, // Icon for the title
            Colors.blue, // Color for the title
          ),
          _buildTaskDetail(
            'Description',
            _taskController.task.value?.description ?? task.description,
            Icons.description, // Icon for the description
            Colors.green, // Color for the description
          ),
          _buildTaskDetail(
            'Due Date',
            _taskController.task.value?.dueDate ?? task.dueDate,
            Icons.calendar_today, // Icon for the due date
            Colors.orange, // Color for the due date
          ),
          _buildTaskDetail(
            'Is Completed',
            _taskController.task.value?.isCompleted ?? task.isCompleted,
            Icons.check_circle, // Icon for the is completed
            Colors.teal, // Color for the is completed
          ),
        ],
      );
    },
  ),
)

    );
  }

  Widget _buildTaskDetail(String label, dynamic value, IconData icon, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 24.0,
        ),
        SizedBox(width: 8.0),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
            ),
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '$value',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  void _showEditDialog(BuildContext context, Task task) {
    TextEditingController titleController = TextEditingController(text: task.title);
    TextEditingController descriptionController =
        TextEditingController(text: task.description);

    DateTime selectedDate = task.dueDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
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
                _taskController.updateTaskDetails(
                  title: titleController.text,
                  description: descriptionController.text,
                  dueDate: selectedDate,
                  isCompleted: task.isCompleted,
                );
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _taskController.deleteTask();
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
