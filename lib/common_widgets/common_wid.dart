import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customButton(String text){
  return Container(
  width: 300.w,
  height: 50.h,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 62, 128, 255),  // Lighter Blue
        Color.fromARGB(255, 41, 66, 255),   // Darker Blue
      ],
    ),
    borderRadius: BorderRadius.circular(30.w),
    boxShadow: [
      BoxShadow(
        blurRadius: 5,
        spreadRadius: 2,
        offset: Offset(0, 4),
        color: Colors.blue.withOpacity(0.5),
      ),
    ],
  ),
  child: Center(
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    ),
  ),
);
}



  Widget customTextField(String label,String hint,TextEditingController controller,bool obs){
    return Container(
      margin: EdgeInsets.only(bottom: 30.h),
                    width: 300.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,style: GoogleFonts.ubuntu(
                          fontSize: 15.sp,fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 10.h,),
                        TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hint,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          
                        ),
                        borderRadius: BorderRadius.circular(30.w)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.w)
                      )),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: obs,
                      style: GoogleFonts.ubuntu(color: Colors.grey,fontSize: 14.sp),
                    ),
                      ],
                    )
                  );
  }


  Widget socialButton(String path){
    return Container(
      margin: EdgeInsets.only(
        left: 10,right: 10,
      ),
                          width: 50.w,
                          height: 50.w,
                          child: Image(image: AssetImage(path)),
                        );
  }