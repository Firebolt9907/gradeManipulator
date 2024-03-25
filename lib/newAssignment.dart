import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewAssignment extends StatefulWidget {
  const NewAssignment(
      {super.key,
      required this.category,
      required this.className,
      required this.path,
      required this.assignments});
  final String path;
  final List<Map<String, dynamic>> assignments;
  final String category;
  final String className;

  @override
  State<NewAssignment> createState() => _NewClassState();
}

class _NewClassState extends State<NewAssignment> {
  final TextEditingController className = TextEditingController();
  final TextEditingController top = TextEditingController();
  final TextEditingController bottom = TextEditingController();
  var clicked = false;
  var exists = false;
  var error = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "Add Assignment",
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
                  "What is the assignment name?",
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
                  onChanged: (value) {
                    if (error == "Assignment already exists") {
                      setState(() {
                        error = "";
                      });
                    }
                  },
                )),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "What score did you get on it?\n(ex. 22/40 or 9.5/10)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width /
                                  MediaQuery.sizeOf(context).height >
                              3 / 4
                          ? MediaQuery.sizeOf(context).height *
                                  0.9 *
                                  9 /
                                  16 /
                                  2 -
                              20
                          : MediaQuery.sizeOf(context).width / 2 - 20,
                      child: TextField(
                        controller: top,
                        autofocus: false,
                        keyboardType: TextInputType.number,
                      ))),
              Text(
                "/",
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 5, right: 10),
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width /
                                  MediaQuery.sizeOf(context).height >
                              3 / 4
                          ? MediaQuery.sizeOf(context).height *
                                  0.9 *
                                  9 /
                                  16 /
                                  2 -
                              20
                          : MediaQuery.sizeOf(context).width / 2 - 20,
                      child: TextField(
                          controller: bottom,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (double.tryParse(top.text) != null &&
                                double.tryParse(value) != null) {
                              if (double.parse(top.text) >
                                      double.parse(bottom.text) &&
                                  error == "") {
                                setState(() {
                                  error =
                                      "Warning: your score appears to be larger than 100%";
                                });
                              } else {
                                if (error ==
                                    "Warning: your score appears to be larger than 100%") {
                                  setState(() {
                                    error = "";
                                  });
                                }
                              }
                            }
                          }))),
            ]),
            Text(error, style: TextStyle(color: Colors.red, fontSize: 20)),
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
                              if (widget.assignments != []) {
                                for (final clas in widget.assignments) {
                                  if (clas['name'] == className.text) {
                                    exists = true;
                                    setState(() {
                                      error = "Assignment already exists";
                                    });
                                  }
                                }
                              }
                              if (!exists) {
                                if (double.tryParse(top.text) != null &&
                                    double.tryParse(bottom.text) != null &&
                                    className.text != "") {
                                  if ((double.tryParse(bottom.text) == 0.0 &&
                                          double.tryParse(top.text) == 0.0) ||
                                      (double.tryParse(bottom.text) != 0.0)) {
                                    if (widget.assignments.isEmpty) {
                                      SharedPreferences.getInstance()
                                          .then((prefs) {
                                        prefs.setStringList(
                                            widget.path, [className.text]);
                                        prefs.setDouble(
                                            widget.path +
                                                className.text +
                                                '-top',
                                            double.tryParse(top.text) ?? 0);
                                        prefs.setDouble(
                                            widget.path +
                                                className.text +
                                                '-bottom',
                                            double.tryParse(bottom.text) ?? 0);
                                        if (double.tryParse(top.text) != null &&
                                            double.tryParse(bottom.text) !=
                                                null) {
                                          prefs.setDouble(
                                              widget.path +
                                                  className.text +
                                                  '-grade',
                                              double.parse(top.text) /
                                                  double.parse(bottom.text) *
                                                  100);
                                        } else {
                                          prefs.setDouble(
                                              widget.path +
                                                  className.text +
                                                  '-grade',
                                              0.0);
                                        }
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      SharedPreferences.getInstance()
                                          .then((prefs) {
                                        List<String>? temp =
                                            prefs.getStringList(widget.path);
                                        temp?.add(className.text);
                                        prefs.setStringList(widget.path, temp!);
                                        prefs.setDouble(
                                            widget.path +
                                                className.text +
                                                '-top',
                                            double.tryParse(top.text) ?? 0);
                                        prefs.setDouble(
                                            widget.path +
                                                className.text +
                                                '-bottom',
                                            double.tryParse(bottom.text) ?? 0);
                                        if (double.tryParse(top.text) != null &&
                                            double.tryParse(bottom.text) !=
                                                null) {
                                          prefs.setDouble(
                                              widget.path +
                                                  className.text +
                                                  '-grade',
                                              double.parse(top.text) /
                                                  double.parse(bottom.text) *
                                                  100);
                                        } else {
                                          prefs.setDouble(
                                              widget.path +
                                                  className.text +
                                                  '-grade',
                                              0.0);
                                        }
                                        Navigator.pop(context);
                                      });
                                    }
                                  } else {
                                    if (top.text == "" || bottom.text == "") {
                                      error = "One or more fields are empty";
                                      clicked = false;
                                    } else if (double.tryParse(top.text) ==
                                            null ||
                                        double.tryParse(bottom.text) == null) {
                                      error =
                                          "One or more fields are not numbers";
                                      clicked = false;
                                    } else {
                                      error = "One or more fields are empty";
                                      clicked = false;
                                    }
                                  }
                                } else {
                                  error = "You can't divide by zero";
                                  clicked = false;
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
                              Text("Add Assignment",
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
