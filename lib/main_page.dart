// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:http/http.dart' as http;
import 'package:make_task_app/login_page.dart';
import 'package:make_task_app/show_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading_loader_process.dart';

void main() => runApp(const MainPage());

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final topic = TextEditingController();
  final update = TextEditingController();
  List taskList = [];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 200,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Add Task",
                            ),
                            controller: topic),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            postApiData();
                            setState(() {});
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                              MaterialStatePropertyAll(Colors.green)),
                          child: const Text("Add"),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Make a Task"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text("are you sure you want to logout"),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text("yes"),
                          onPressed: () async {
                            final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                    (route) => false);
                            setState(() {});
                          },
                        ),
                        CupertinoDialogAction(
                          child: const Text("no"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                child: Text('All'),
              ),
              Tab(
                child: Text('Pending'),
              ),
              Tab(
                child: Text('Complete'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [allView(), panding(), complete()],
        ),
      ),
    );
  }

  Widget allView() {
    return Stack(
      children: [
        Image.network(
          "https://img.freepik.com/free-photo/luxury-plain-green-gradient-abstract-studio-background-empty-room-with-space-your-text-picture_1258-70664.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        ListView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: taskList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                return SwipeActionCell(
                  key: ObjectKey(taskList),

                  /// this key is necessary
                  trailingActions: <SwipeAction>[
                    SwipeAction(
                        title: "delete",
                        onTap: (CompletionHandler handler) async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text(
                                    "are you sure you want to delete"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("yes"),
                                    onPressed: () {
                                      deleteApiData(taskList[index]['id']);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text("no"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        color: Colors.red),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 100,
                      width: 350,
                      color: Colors.green.withOpacity(0.5),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              taskList[index]["status"] =
                              !taskList[index]["status"];
                              setState(() {});
                            },
                            icon: Icon(
                              taskList[index]["status"] == true
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${taskList[index]["description"]}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 150,
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        height: 200,
                                        color: Colors.green.withOpacity(0.5),
                                        width: 100,
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        30),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText: "Add Task",
                                                ),
                                                controller: topic),
                                            const SizedBox(
                                              height: 50,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                putApiData(
                                                  taskList[index]["id"],
                                                  taskList[index]["status"],
                                                );
                                                setState(() {});
                                              },
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.green)),
                                              child: const Text("Update"),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit))
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ],
    );
  }

  Widget panding() {
    return Stack(
      children: [
        Image.network(
          "https://img.freepik.com/free-photo/luxury-plain-green-gradient-abstract-studio-background-empty-room-with-space-your-text-picture_1258-70664.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            return (taskList[index]['status'] == false)
                ? Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                height: 100,
                width: 350,
                color: Colors.green.withOpacity(0.5),
                child: Row(
                  children: [
                    Checkbox(
                      value: taskList[index]['status'],
                      onChanged: (value) {},
                    ),
                    Expanded(
                      child: Text(
                        "${taskList[index]["description"]}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  Widget complete() {
    return Stack(children: [
      Image.network(
        "https://img.freepik.com/free-photo/luxury-plain-green-gradient-abstract-studio-background-empty-room-with-space-your-text-picture_1258-70664.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return (taskList[index]['status'] == true)
              ? Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 100,
              width: 350,
              color: Colors.green.withOpacity(0.5),
              child: Row(
                children: [
                  Checkbox(
                    value: taskList[index]['status'],
                    onChanged: (value) {},
                  ),
                  Expanded(
                    child: Text(
                      "${taskList[index]["description"]}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          )
              : const SizedBox();
        },
      )
    ]);
  }

  //functions
  void getApiData() async {
    // get == read method
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    http.Response response = await http.get(
        Uri.parse(
          'https://todo-list-app-kpdw.onrender.com/api/tasks',
        ),
        headers: {
          "x-access-token": "$token",
        });
    debugPrint('status-code ${response.statusCode}');
    debugPrint('body ${response.body}');
    if (response.statusCode == 200) {
      taskList = jsonDecode(response.body);
      setState(() {});
    } else {}
  }

  void postApiData() async {
    // post == create method
    showLoadingDialog(context);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    http.Response response = await http.post(
        Uri.parse(
          "https://todo-list-app-kpdw.onrender.com/api/tasks",
        ),
        body: {
          "description": topic.text,
          "status": "true"
        },
        headers: {
          "x-access-token": "$token",
        });
    debugPrint("response code -- ${response.statusCode}");
    debugPrint("response body -- ${jsonDecode(response.body)}");
    hideLoadingDialog(context);
    if (response.statusCode == 200) {
      //for success
      getApiData();
      Navigator.pop(context);

      showMessage(msg: "Task add Successfully");
    } else if (response.statusCode == 401) {
      showMessage(msg: "${jsonDecode(response.body)['message']}");
      prefs.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
              (route) => false);
    } else {
      //for error
      showMessage(msg: "${jsonDecode(response.body)['message']}");
    }
  }

  void putApiData(int id, status) async {
    //put == update, pending
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    debugPrint("$token");
    http.Response response = await http.put(
        Uri.parse(
          'https://todo-list-app-kpdw.onrender.com/api/tasks/$id',
        ),
        headers: {
          "x-access-token": "$token",
        },
        body: {
          "description": topic.text,
          "status": "$status",
        });
    debugPrint('status-code ${response.statusCode}');
    debugPrint('body ${response.body}');
    if (response.statusCode == 200) {
      getApiData();
      Navigator.pop(context);
      //sucsses
    } else {
      // error
    }
  }

  void deleteApiData(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("accessToken");
    debugPrint("$token");
    http.Response response = await http.delete(
      Uri.parse(
        'https://todo-list-app-kpdw.onrender.com/api/tasks/$id',
      ),
      headers: {
        "x-access-token": "$token",
      },
    );
    debugPrint('status-code ${response.statusCode}');
    debugPrint('body ${response.body}');
    if (response.statusCode == 200) {
      getApiData();
    } else {}
  }
}
