import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}
const toDo = "https://dummyjson.com/todos";
Future<String> nextToDo() async {
  final http.Response response = await http.get(Uri.parse(toDo));
  if (response.statusCode == 200) {
    final String data = response.body;
    final Map<String, dynamic> decodedJson = jsonDecode(data);
    final String toDo =
        decodedJson["todos"][9]["todo"];

    return toDo;
  } else {
    return Future.error("Error");
  }
}
class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}
class _MainAppState extends State<MainApp> {
  Future<String>? _tuDoFuture;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 161, 89, 174),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            "ToDo´s",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            children: [const SizedBox(
              height: 250),
              SizedBox(
                height: 50,
                child: FutureBuilder<String>(
                  future: _tuDoFuture,
                  builder: (context, snapshot) {
                    String newToDo = "";
                    if (snapshot.hasError) {
                      newToDo =
                          "Es ist ein Fehler aufgetreten : ${snapshot.error}";
                      return Text(newToDo, style: const TextStyle( fontSize: 33),);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      newToDo = snapshot.data!;
                      return Text(newToDo, style: const TextStyle( fontSize: 33),);
                    }
                    return const Text("Noch keine Daten vorhanden");
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tuDoFuture = nextToDo();
                  });
                },
                child: const Text("Next"),
              )
            ],
          ),
        ),
      ),
    );
  }
}















