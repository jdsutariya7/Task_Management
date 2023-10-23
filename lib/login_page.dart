// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:make_task_app/main_page.dart';
import 'package:make_task_app/show_message.dart';
import 'package:make_task_app/sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'loading_loader_process.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

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
                fit: BoxFit.cover,
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
                          fontFamily: "title"
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 270,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Log in",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "username",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter username";
                      } else if (!RegExp(
                              "[a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?")
                          .hasMatch(value)) {
                        return "enter valid username";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
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
                  ElevatedButton(
                    onPressed: () {
                      loginData();
                      if (formKey.currentState!.validate()) {
                        debugPrint('required');
                      } else {
                        debugPrint('not required');
                      }

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade300,
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        fixedSize: const Size(100, 40)),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 23, color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Don't have Account? ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // ignore: non_constant_identifier_names
                                  builder: (Context) => const SignUp(),
                                ),
                              );
                            },
                          text: "Create Account",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
  //Functions

  void loginData() async {
    showLoadingDialog(context);
    http.Response response = await http.post(
        Uri.parse("https://todo-list-app-kpdw.onrender.com/api/auth/signin",),
        body: {
          "username": username.text,
          "password": password.text,
        }
    );
    debugPrint("response code -- ${response.statusCode}");
    debugPrint("response body -- ${jsonDecode(response.body)['data']}");
    // ignore: use_build_context_synchronously
    hideLoadingDialog(context);
    if (response.statusCode == 200) {
      //for success
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString(
          "accessToken", "${json.decode(response.body)['accessToken']}");
      showMessage(msg: "Login sucssesfull");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
              (route) => false);
    } else {
      //for error
      showMessage(msg: "${jsonDecode(response.body)['message']}");
    }
  }

}
