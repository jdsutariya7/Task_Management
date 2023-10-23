// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:make_task_app/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:make_task_app/show_message.dart';

import 'loading_loader_process.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool signUpAPIProcess = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              Image.network(
                "https://cdn.vectorstock.com/i/preview-1x/23/65/green-gradient-abstract-polygon-background-vector-7712365.jpg",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Creat Task",
                        style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: "title"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter username";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "user name",
                    ),
                    controller: userName,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Email",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter email";
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "enter valid email";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "password",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter password";
                      } else if (RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(value)) {
                        return "enter valid password";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: confirmPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "confirm password",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter confirm password";
                      } else if (RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(value)) {
                        return "enter valid confirm password";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signUpData();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        fixedSize: const Size(100, 40)),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //functions
    void signUpData() async {
      showLoadingDialog(context);
      http.Response response = await http.post(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/auth/signup",),
        body: {
          "username": userName.text,
          "email": email.text,
          "password": password.text,
        }
      );
      debugPrint("response code -- ${response.statusCode}");
      debugPrint("response body -- ${response.body}");
      setState(() {});
      hideLoadingDialog(context);
      if (response.statusCode == 200) {
        //for success
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
                (route) => false);
      //  showMessage(msg: "${jsonDecode(response.body)['signup sucssesfull']}");
        showMessage(msg: "signup sucssesfull");
      } else {
        //for error
        showMessage(msg: "${jsonDecode(response.body)['message']}");
      }
    }
}
