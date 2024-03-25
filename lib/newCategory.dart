import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCategory extends StatefulWidget {
  const NewCategory(
      {super.key,
      required this.index,
      required this.categories,
      required this.className});
  final int index;
  final List<Map<String, dynamic>> categories;
  final String className;

  @override
  State<NewCategory> createState() => _NewClassState();
}

class _NewClassState extends State<NewCategory> {
  final TextEditingController className = TextEditingController();
  final TextEditingController weight = TextEditingController();
  var clicked = false;
  var exists = false;

  @override
  Widget build(BuildContext context) {
    print(widget.categories);
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "Add Category",
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
                  "What is the category name?",
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
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "What is the weight of this category?",
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
                  controller: weight,
                  autofocus: false,
                  keyboardType: TextInputType.number,
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
                              if (widget.categories != []) {
                                for (final clas in widget.categories) {
                                  if (clas['name'] == className.text) {
                                    exists = true;
                                  }
                                }
                              }
                              if (!exists) {
                                if (widget.categories.isEmpty) {
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setStringList(
                                        widget.className + "-categories",
                                        [className.text]);
                                    prefs.setDouble(
                                        widget.className +
                                            "-categories" +
                                            className.text +
                                            '-grade',
                                        0.0);
                                    prefs.setInt(
                                        widget.className +
                                            "-categories" +
                                            className.text +
                                            '-weight',
                                        int.tryParse(weight.text) ?? 0);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  SharedPreferences.getInstance().then((prefs) {
                                    List<String>? temp = prefs.getStringList(
                                        widget.className + "-categories");
                                    temp!.add(className.text);
                                    prefs.setStringList(
                                        widget.className + "-categories", temp);
                                    prefs.setDouble(
                                        widget.className +
                                            "-categories" +
                                            className.text +
                                            '-grade',
                                        0.0);
                                    prefs.setInt(
                                        widget.className +
                                            "-categories" +
                                            className.text +
                                            '-weight',
                                        int.tryParse(weight.text) ?? 0);
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
                              Text("Add Category",
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
