import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_comparer/category.dart';
import 'package:tv_comparer/newCategory.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key, required this.name});
  final String name;

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  var am = true;
  List<Map<String, dynamic>> categories = [
    {'name': 'addCat'},
    {'name': 'Overall', 'grade': 0.0, 'edited': false},
    // {'name': 'Mastering Chemistry', 'weight': 15, 'grade': 97.97},
    // {'name': 'Lab Reports', 'weight': 15, 'grade': 100.0},
    // {'name': 'Tests', 'weight': 70, 'grade': 97.5},
    // {'name': 'deleteAll'},
  ];

  void storageStuff() async {
    categories = [
      {'name': 'addCat'},
      {'name': 'Overall', 'grade': 0.0, 'edited': false},
    ];
    var totalWeight = 0;
    final prefs = await SharedPreferences.getInstance();
    var classNames = await prefs.getStringList(widget.name + "-categories");
    if (classNames != null) {
      for (var i = 0; i < classNames!.length; i++) {
        var grade = prefs
            .getDouble(widget.name + '-categories' + classNames[i] + '-grade');
        var weight = prefs
            .getInt(widget.name + '-categories' + classNames[i] + '-weight');
        totalWeight += weight!;
        categories
            .add({'name': classNames[i], 'grade': grade, 'weight': weight});
        categories[1]['grade'] += grade! * weight! / 100;
      }
      // categories.add({'name': 'deleteAll'});
    }

    if (categories[1]['grade'] !=
        prefs.getDouble(widget.name + '-overallGrade')) {
      prefs.setDouble(widget.name + '-overallGrade', categories[1]['grade']);
    }

    if (totalWeight != 100) {
      categories.insert(2, {"name": "warning"});
    }

    print(classNames);
    print(categories);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storageStuff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(width: 0, color: Colors.transparent),
          middle: Text(
            widget.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          trailing: IconButton(
              icon: Icon(
                CupertinoIcons.trash_fill,
                color: Colors.red,
              ),
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) {
                  for (var index = 0; index < categories.length; index++) {
                    if (categories[index]["weight"] != null) {
                      var assignments = [];
                      var classNames = prefs.getStringList(widget.name +
                          "-categories" +
                          categories[index]["name"] +
                          "-assignments");
                      if (classNames != null) {
                        for (var i = 0; i < classNames!.length; i++) {
                          var top = prefs.getDouble(widget.name +
                              "-categories" +
                              categories[index]["name"] +
                              '-assignments' +
                              classNames[i] +
                              '-top');
                          var bottom = prefs.getDouble(widget.name +
                              "-categories" +
                              categories[index]["name"] +
                              '-assignments' +
                              classNames[i] +
                              '-bottom');
                          var grade = prefs.getDouble(widget.name +
                              "-categories" +
                              categories[index]["name"] +
                              '-assignments' +
                              classNames[i] +
                              '-grade');
                          print(grade);
                          assignments.add({
                            'name': classNames[i],
                            'grade': grade,
                            'top': top,
                            'bottom': bottom
                          });
                        }

                        for (var u = 0; u < assignments.length; u++) {
                          if (categories[index]["top"] != null) {
                            prefs.remove(
                              widget.name +
                                  "-categories" +
                                  categories[index]["name"] +
                                  '-assignments' +
                                  assignments[u]['name'] +
                                  '-grade',
                            );
                            prefs.remove(
                              widget.name +
                                  "-categories" +
                                  categories[index]["name"] +
                                  '-assignments' +
                                  assignments[u]['name'] +
                                  '-top',
                            );
                            prefs.remove(
                              widget.name +
                                  "-categories" +
                                  categories[index]["name"] +
                                  '-assignments' +
                                  assignments[u]['name'] +
                                  '-bottom',
                            );
                          }
                        }

                        prefs.remove(
                          widget.name +
                              '-categories' +
                              categories[index]['name'] +
                              '-grade',
                        );
                        prefs.remove(
                          widget.name +
                              "-categories" +
                              categories[index]["name"] +
                              '-assignments' +
                              categories[index]['name'] +
                              '-top',
                        );
                        prefs.remove(
                          widget.name +
                              "-categories" +
                              categories[index]["name"] +
                              '-assignments' +
                              categories[index]['name'] +
                              '-bottom',
                        );
                      }
                    }
                    prefs.remove(widget.name +
                        "-categories" +
                        categories[index]["name"] +
                        '-assignments');
                    prefs.remove(widget.name + "-categories");
                    List<String>? temp = prefs.getStringList("classes");
                    print(temp);
                    temp?.remove(widget.name);
                    print(temp);
                    prefs.setStringList("classes", temp!);
                  }
                  Navigator.pop(context);
                });
              }),
          previousPageTitle: 'Home',
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                if (categories[index]['name'] == 'addCat') {
                  return Opacity(
                    opacity: 0,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => NewCategory(
                                      index: index,
                                      categories: categories.length == 3 &&
                                              categories[2]["name"] == "warning"
                                          ? []
                                          : categories,
                                      className: widget.name),
                                )).then((value) => storageStuff());
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
                  );
                } else if (categories[index]['name'] == 'warning') {
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
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.exclamationmark_triangle_fill,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text("Weights don't add up to 100%",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                } else if (categories[index]['name'] == 'deleteAll') {
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
                            Text("Delete All Items",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ));
                } else if (categories[index]['name'] == 'Overall') {
                  return Opacity(
                    opacity: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: IntrinsicHeight(
                            // height: 65, //maybe change to 124
                            // width: MediaQuery.sizeOf(context).width,
                            // child: Container(
                            // color: Theme.of(context).focusColor,
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${categories[index]['edited'] ? 'Edited' : 'Overall'} Grade: ' +
                                              (((categories[index]['grade'] *
                                                                  100) ??
                                                              0)
                                                          .round() /
                                                      100)
                                                  .toString() +
                                              '%',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
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
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CategoryPage(
                                    name: categories[index]['name'],
                                    className: widget.name,
                                    path: widget.name +
                                        '-categories' +
                                        categories[index]['name'],
                                    otherGrades: categories[1]['grade'] -
                                        (categories[index]['grade'] *
                                            categories[index]['weight'] /
                                            100),
                                    weight: categories[index]['weight']),
                              )).then((vau) => storageStuff());
                        },
                        child: SizedBox(
                          height: 124, //maybe change to 124
                          width: MediaQuery.sizeOf(context).width,
                          child: Container(
                            // color: Theme.of(context).focusColor,
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(categories[index]['name'],
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 50, left: 10),
                                      child: Text(
                                          'Grade: ' +
                                              ((categories[index]['grade'] *
                                                              100)
                                                          .round() /
                                                      100)
                                                  .toString() +
                                              '%, Weight: ' +
                                              categories[index]['weight']
                                                  .toString() +
                                              "%",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal)),
                                    )),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 80, left: 10, right: 10),
                                        child: SizedBox.expand(
                                            child: CupertinoSlider(
                                                value: categories[index]
                                                        ['grade'] *
                                                    100,
                                                divisions: 10000,
                                                min: 0,
                                                max: 10000,
                                                onChanged: ((value) {
                                                  setState(() {
                                                    categories[index]['grade'] =
                                                        value / 100;
                                                    var overall = 0.0;
                                                    for (var category
                                                        in categories) {
                                                      if (!(category['name'] ==
                                                              'addCat' ||
                                                          category['name'] ==
                                                              'Overall' ||
                                                          category['name'] ==
                                                              'deleteAll' ||
                                                          category['name'] ==
                                                              'warning')) {
                                                        overall += category[
                                                                'grade'] *
                                                            category['weight'] /
                                                            100;
                                                      }
                                                    }
                                                    categories[1]['grade'] =
                                                        overall;
                                                    categories[1]['edited'] =
                                                        true;
                                                  });
                                                }))))),
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
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => NewCategory(
                                      index: 0,
                                      categories: categories.length == 3 &&
                                              categories[2]["name"] == "warning"
                                          ? []
                                          : categories,
                                      className: widget.name),
                                )).then((value) => storageStuff());
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: IntrinsicHeight(
                            // height: 65, //maybe change to 124
                            // width: MediaQuery.sizeOf(context).width,
                            // child: Container(
                            // color: Theme.of(context).focusColor,
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${categories[1]['edited'] ? 'Edited' : 'Overall'} Grade: ' +
                                              (((categories[1]['grade'] *
                                                                  100) ??
                                                              0)
                                                          .round() /
                                                      100)
                                                  .toString() +
                                              '%',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
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
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
