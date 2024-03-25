import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_comparer/class.dart';
import 'package:tv_comparer/newClass.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> classes = [
    {'name': 'addClass'},
    // {'name': 'AP Chem', 'overallGrade': 96.85},
    // {'name': 'German', 'overallGrade': 97.46},
    // {'name': 'AP Calc 2', 'overallGrade': 98.77},
    // {'name': 'AP CS P', 'overallGrade': 95.00},
    // {'name': 'deleteAll'},
  ];
  late var prefs;

  @override
  void initState() {
    super.initState();
    storageStuff();
  }

  void storageStuff() async {
    classes = [
      {'name': 'addClass'},
    ];
    final prefs = await SharedPreferences.getInstance();
    var classNames = await prefs.getStringList("classes");
    if (classNames != null) {
      for (var i = 0; i < classNames!.length; i++) {
        var grade = await prefs.getDouble(classNames![i] + '-overallGrade');
        classes.add({
          'name': classNames[i],
          'overallGrade': grade,
        });
      }
      // classes.add({'name': 'deleteAll'});
    }

    print(classNames);
    print(classes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "Grade Manipulator",
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          border: Border.all(width: 0, color: Colors.transparent),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        extendBodyBehindAppBar: true,
        body: ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            if (classes[index]['name'] == 'addClass') {
              return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => NewClass(
                              index: classes.length - 2,
                              classes: classes.length == 1 ? [] : classes,
                            ),
                          )).then(
                        (value) => storageStuff(),
                      );
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
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ));
            } else if (classes[index]['name'] == 'deleteAll') {
              return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //       builder: (context) => AddPractice(),
                      //     ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.trash_fill, size: 45),
                        Padding(
                            padding: EdgeInsets.only(
                                right: 10, top: 40, bottom: 40)),
                        Text("Delete All Classes",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ));
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              ClassPage(name: classes[index]['name']),
                        )).then(
                      (value) => storageStuff(),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 90, //maybe change to 124
                      width: MediaQuery.sizeOf(context).width,
                      child: Container(
                        // color: Theme.of(context).focusColor,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(classes[index]['name'],
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 50, left: 10),
                                  child: Text(
                                      'Overall Grade: ' +
                                          ((classes[index]['overallGrade'] *
                                                          100)
                                                      .round() /
                                                  100)
                                              .toString() +
                                          '%',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal)),
                                )),
                            // Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Padding(
                            //       padding:
                            //           const EdgeInsets.only(top: 80, left: 10),
                            //       child: Text('line 3',
                            //           style: TextStyle(
                            //               fontSize: 20,
                            //               fontWeight: FontWeight.normal)),
                            //     )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
