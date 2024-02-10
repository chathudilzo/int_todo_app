import 'package:get/get.dart';
import 'package:int_todo_app/classes/task.dart';
import 'package:int_todo_app/services/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final AuthController _authController = Get.find();

  RxList<Task> tasks = <Task>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() async{
    super.onInit();
    await _authController.checkAuth();
    print(_authController.user);
    fetchTasks();
  }

 Future<void> fetchTasks() async {
  try {
    isLoading.value = true; 

    String userId = _authController.user.value?.uid ?? '';
    print(userId);
    if (userId.isNotEmpty) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        var taskList = snapshot.data()?['tasks'] as List<dynamic>;
        
        if (taskList.isNotEmpty) {
          tasks.clear();
          taskList.forEach((taskData) {
            tasks.add(Task.fromMap(taskData));
          });
        } else {
          
          tasks.clear();
        }
      } else {
        // If the document does not exist, create one
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'tasks': [],
        });
      }
    }
    isLoading.value=false;
  } catch (e) {
    print('Error fetching tasks: $e');
  } finally {
    isLoading.value = false; 
  }
}


void addTask(Task task) async {
    try {
      
      String userId = _authController.user.value?.uid ?? '';
      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'tasks': FieldValue.arrayUnion([task.toMap()]),
        });
        fetchTasks();
      }
    } catch (e) {
      print('Error adding task: $e');
    }
  }


  void updateTaskCompletion(Task task, bool isCompleted) async {
  try {
    String userId = _authController.user.value?.uid ?? '';
    if (userId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'tasks': FieldValue.arrayRemove([task.toMap()]),
      });

      // Update the task completion status
      task.isCompleted = isCompleted;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'tasks': FieldValue.arrayUnion([task.toMap()]),
      });
      fetchTasks();
    }
  } catch (e) {
    print('Error updating task completion: $e');
  }
}





}
