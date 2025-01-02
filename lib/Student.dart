import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
class SearchStudent extends StatefulWidget {
  const SearchStudent({super.key});

  @override
  State<SearchStudent> createState() => _SearchStudentState();
}

class _SearchStudentState extends State<SearchStudent> {
  List _students = [];
  final TextEditingController _controllerID = TextEditingController();
  String _text = '';

  @override
  void dispose() {
    _controllerID.dispose();
    super.dispose();
  }


  void update(String text) {
    setState(() {
      _text = text;
    });
  }


  void getGrades() {
    try {
      int sid = int.parse(_controllerID.text);
      searchStudent(update, sid);
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('wrong arguments')));
    }
  }



  void searchStudent(Function(String text) update, int sid) async {
    try {
      var url = "http://192.168.56.1//search.php?sid=$sid";
      var res =await http.get(Uri.parse(url));
      _students.clear();
      if (res.statusCode == 200) {
        var rev = json.decode(res.body);
        var row = rev[0];

        setState(() {
          _students.add(row);
        });
        update(_students[0].toString());
        print(rev);
        update( "ID: ${_students[0]["id"]}, Name:${_students[0]["name"]}, Maths: ${_students[0]["maths"]}, History: ${_students[0]["history"]}, Science: ${_students[0]["science"]} ");
      }
    }

    catch(e) {
      update("can't load data");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Grades', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent), ),
        centerTitle: true,
      ),
      body: Center(child: Column(children: [
        const SizedBox(height: 10),
        SizedBox(width: 200, child: TextField(controller: _controllerID, keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter ID'))),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: getGrades,
            child: const Text('Find', style: TextStyle(fontSize: 18))),
        const SizedBox(height: 10),
         SizedBox(width: 400, child: Flexible(child: Text(_text,

            style: const TextStyle(fontSize: 18, color: Colors.brown, backgroundColor: Colors.orangeAccent, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic ),
           textAlign: TextAlign.left ,
        ))),
      ],

      ),

      ),
    );
  }
}


