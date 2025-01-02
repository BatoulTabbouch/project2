import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _load = false;
  List list =[];

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });}

    void updateStudent(Function(bool success) update) async {
      try {
        var url = "http://192.168.56.1//getData.php";
        var res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          var row = json.decode(res.body);

          setState(() {
            list.addAll(row);
          });
          update(true);
          print(list);
        }
      }
      catch(e){
        update(false);
      }

  }
    @override
    void initState() {
      updateStudent(update);
      super.initState();
    }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            setState(() {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchStudent())
              );
            });
          }, icon: const Icon(Icons.search))
        ],
          title: const Text("Students Grades")),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (cts,i){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.amberAccent,
              child: ListTile(
                 title: Text("${list[i]["name"]}"),
                subtitle: Text("ID: ${list[i]["id"]},  Maths: ${list[i]["maths"]}, History: ${list[i]["history"]}, Science: ${list[i]["science"]} "),

                leading: CircleAvatar(
                  radius: 20,
                  child: Text("${list[i]["name"].toString().substring(0,2)}"),
                ),
              ),
            ),
          );
        },

      )


    );
  }
}
