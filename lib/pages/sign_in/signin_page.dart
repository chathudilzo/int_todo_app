import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:int_todo_app/common_widgets/common_wid.dart';
import 'package:int_todo_app/services/auth_controller.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthController _authController = Get.find();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        width: 375.w,
        height: 812.h,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
              
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h,),
                  SizedBox(
                    width: 375.w,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70.w,
                            height: 70.w,
                            child: Image(image: AssetImage('assets/images/logo.png'),fit: BoxFit.cover,),
                          ),
                          SizedBox(width: 10.w,),
                          Text('Easytask',style:GoogleFonts.aDLaMDisplay(fontSize: 20.sp,fontWeight: FontWeight.bold,))
                        ],
                      ),
                      Text('Plan your day',style: GoogleFonts.abel(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold
                      ),)
                    ],
                  ),
                  ),
                  SizedBox(height: 20.h,),
                  
                 customTextField('Your email address', 'user@gmail.com', emailController,false),
                  customTextField('Enter Your Password', 'Password', passwordController,true),
                  SizedBox(height: 20),


                  GestureDetector(
                    onTap: () async {
                      await _authController.registerWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );
                    },
                    child:customButton('Sign Up')

                  ),

                 
                  SizedBox(height: 20),

                  RichText(text:TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(color: Colors.black)
                      ),
                      TextSpan(
                        text: ' Login here',
                        style: TextStyle(color: Color.fromARGB(255, 31, 241, 231),fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap=(){
                            Get.toNamed('/register');
                        }

                      )
                    ]
                  ) ),

                  SizedBox(height: 35.h),
                  Text('or',style: TextStyle(color: Colors.grey),),

                  Container(
                    margin: EdgeInsets.only(left: 50.w,right: 50.w,top: 50.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       socialButton('assets/images/apple.png'),
                       socialButton('assets/images/facebook.png'),
                       socialButton('assets/images/google.png'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
