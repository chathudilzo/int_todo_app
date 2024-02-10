import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:int_todo_app/classes/task.dart';
import 'package:int_todo_app/pages/home/home_controller.dart';
import 'package:int_todo_app/services/auth_controller.dart';

class TaskController extends GetxController {
  Rx<Task?> task = Rx<Task?>(null);
  AuthController _authController=Get.find();
  HomeController _homeController=Get.find();
  

  void setTask(Task task) {
    this.task.value = task;
  }

  Future<void> updateTaskDetails({
  String? title,
  String? description,
  DateTime? dueDate,
  bool? isCompleted,
}) async {
  try {
    if (task.value != null) {

      Task updatedTask = Task(
        title: title ?? task.value!.title,
        description: description ?? task.value!.description,
        dueDate: dueDate ?? task.value!.dueDate,
        isCompleted: isCompleted ?? task.value!.isCompleted,
      );

      
      String userId = _authController.user.value?.uid ?? '';
      if (userId.isNotEmpty) {
        // Remove the current task 
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'tasks': FieldValue.arrayRemove([task.value!.toMap()]),
        });

        
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'tasks': FieldValue.arrayUnion([updatedTask.toMap()]),
        });

        // Update the local task 
        task.value = updatedTask;
        _homeController.fetchTasks();
      }
    }
  } catch (e) {
    print('Error updating task details: $e');
  }
}



  Future<void> deleteTask() async {
  try {
    if (task.value != null) {
      String userId = _authController.user.value?.uid ?? '';
      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'tasks': FieldValue.arrayRemove([task.value!.toMap()]),
        });

        // Navigate to the home page after deleting the task
        Get.offAllNamed('/home');
        _homeController.fetchTasks();
      }
    }
  } catch (e) {
    print('Error deleting task: $e');
  }
}

}
