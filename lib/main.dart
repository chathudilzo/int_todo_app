import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:int_todo_app/firebase_options.dart';
import 'package:int_todo_app/pages/home/home_controller.dart';
import 'package:int_todo_app/pages/home/home_page.dart';
import 'package:int_todo_app/pages/login/login_page.dart';
import 'package:int_todo_app/pages/sign_in/signin_page.dart';
import 'package:int_todo_app/pages/task/task_controller.dart';
import 'package:int_todo_app/pages/task/task_page.dart';
import 'package:int_todo_app/services/auth_controller.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
  Get.put(HomeController());
  Get.put(TaskController());
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Management App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<User?>(
        // Check if the user is authenticated
        future: _authController.checkAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return snapshot.data != null
                ? HomePage() // Navigate to home page if authenticated
                : LoginPage(); // Show login page if not authenticated
          }
        },
      ),
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => SignUpPage()),
        GetPage(name: '/task', page: () => TaskPage())

      ],
    );
  }
}
