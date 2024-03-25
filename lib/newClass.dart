import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewClass extends StatefulWidget {
  const NewClass({super.key, required this.index, required this.classes});
  final int index;
  final List<Map<String, dynamic>> classes;

  @override
  State<NewClass> createState() => _NewClassState();
}

class _NewClassState extends State<NewClass> {
  final TextEditingController className = TextEditingController();
  var clicked = false;
  var exists = false;

  @override
  Widget build(BuildContext context) {
    print(widget.classes);
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "Add Class",
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          border: Border.all(width: 0, color: Colors.transparent),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: ListView(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "What is the class name?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: className,
                  autofocus: true,
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!clicked) {
                              clicked = true;
                              if (widget.classes != []) {
                                print("checking classes");
                                for (final clas in widget.classes) {
                                  if (clas['name'] == className.text) {
                                    exists = true;
                                  }
                                }
                              }
                              if (!exists) {
                                if (widget.classes.isEmpty) {
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setStringList(
                                        "classes", [className.text]);
                                    prefs.setDouble(
                                        className.text + "-overallGrade", 0.0);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  SharedPreferences.getInstance().then((prefs) {
                                    List<String>? temp =
                                        prefs.getStringList("classes");
                                    temp!.add(className.text);
                                    prefs.setStringList("classes", temp);
                                    prefs.setDouble(
                                        className.text + "-overallGrade", 0.0);
                                    Navigator.pop(context);
                                  });
                                }
                              } else {
                                clicked = false;
                              }
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.add_circled_solid, size: 45),
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: 10, top: 40, bottom: 40)),
                              Text("Add Class",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
