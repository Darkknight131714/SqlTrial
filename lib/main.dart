import 'dart:convert';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sql/userr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Useri> kk = [];
  Future<void> trial() async {
    var url = Uri.parse('https://gautam131714.000webhostapp.com/get.php');
    var response = await http.get(url);
    var val = jsonDecode(response.body);
    setState(() {
      kk.clear();
    });
    for (int i = 0; i < val.length; i++) {
      Useri temp = Useri(
          marks: int.parse(val[i]['marks']),
          name: val[i]['name'],
          subject: val[i]['subject'],
          roll: val[i]['roll']);
      kk.add(temp);
    }
    setState(() {});
  }

  Future<void> insert(
      String name, String roll, String subject, String marks) async {
    Map<String, String> m = {
      'name': name,
      'roll': roll,
      'subject': subject,
      'marks': marks
    };
    final uri = Uri.parse('https://gautam131714.000webhostapp.com/insert.php');
    var r = await http.post(uri, body: m);
    print(r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQL Tutorial"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String name = "", subject = "", roll = "", marks = "";
          showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          name = value;
                        },
                        initialValue: "",
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          label: Text("Name"),
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          subject = value;
                        },
                        initialValue: "",
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          label: Text("Subject"),
                          hintText: "Subject",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          roll = value;
                        },
                        initialValue: "",
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          label: Text("Roll"),
                          hintText: "Roll",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          marks = value;
                        },
                        initialValue: "",
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text("Marks"),
                          hintText: "Marks",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (name == "" ||
                              subject == "" ||
                              marks == "" ||
                              roll == "") {
                            Navigator.pop(context);
                          } else {
                            await insert(name, roll, subject, marks);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Insert"),
                      ),
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        backgroundColor: Colors.orange,
        onRefresh: trial,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Users",
              style: TextStyle(fontSize: 30),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: kk.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text(kk[i].name),
                      leading: const Icon(Icons.person),
                      subtitle: Text(kk[i].subject),
                      trailing: Text(kk[i].marks.toString()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
