import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_comparer/newAssignment.dart';
import 'package:tv_comparer/newCategory.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage(
      {super.key,
      required this.className,
      required this.name,
      required this.path,
      required this.otherGrades,
      required this.weight});
  final String className;
  final String name;
  final String path;
  final double otherGrades;
  final int weight;

  @override
  State<CategoryPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<CategoryPage> {
  var am = true;
  List<Map<String, dynamic>> categories = [
    {'name': 'addCat'},
    {'name': 'classOverall', 'grade': 0.0, 'edited': false},
    {'name': 'Overall', 'grade': 0.0, 'edited': false},
    // {'name': 'Mastering Chemistry', 'weight': 15, 'grade': 97.97},
    // {'name': 'Lab Reports', 'weight': 15, 'grade': 100.0},
    // {'name': 'Tests', 'weight': 70, 'grade': 97.5},
    // {'name': 'deleteAll'},
  ];

  void storageStuff() async {
    categories = [
      {'name': 'addCat'},
      {'name': 'classOverall', 'grade': 0.0, 'edited': false},
      {'name': 'Overall', 'grade': 0.0, 'edited': false},
    ];
    final prefs = await SharedPreferences.getInstance();
    var classNames = await prefs.getStringList(widget.path + "-assignments");
    if (classNames != null) {
      for (var i = 0; i < classNames!.length; i++) {
        var top = await prefs
            .getDouble(widget.path + '-assignments' + classNames[i] + '-top');
        var bottom = await prefs.getDouble(
            widget.path + '-assignments' + classNames[i] + '-bottom');
        var grade = await prefs
            .getDouble(widget.path + '-assignments' + classNames[i] + '-grade');
        print(grade);
        categories.add({
          'name': classNames[i],
          'grade': grade,
          'top': top,
          'bottom': bottom
        });
      }
      // categories.add({'name': 'deleteAll'});
    }

    print(classNames);
    print(categories);
    calculateGrade(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storageStuff();
  }

  void calculateGrade(actual) {
    var top = 0.0;
    var bottom = 1.0;
    for (final assignment in categories) {
      if (assignment['grade'] != null && assignment['edited'] == null) {
        if (bottom == 1.0) {
          bottom = 0.0;
        }
        top += assignment['bottom'] * assignment["grade"];
        bottom += assignment['bottom'];
      }
    }
    if (actual && categories[1]['grade'] != top / bottom) {
      final prefs = SharedPreferences.getInstance().then((prefs) {
        prefs.setDouble(widget.path + '-grade', top / bottom);
      });
    }
    categories[2]['grade'] = top / bottom;
    categories[1]['grade'] =
        widget.otherGrades + categories[2]['grade'] * widget.weight / 100;
    setState(
      () {},
    );
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
                    if (categories[index]["top"] != null) {
                      prefs.remove(
                        widget.path +
                            '-assignments' +
                            categories[index]['name'] +
                            '-grade',
                      );
                      prefs.remove(
                        widget.path +
                            '-assignments' +
                            categories[index]['name'] +
                            '-top',
                      );
                      prefs.remove(
                        widget.path +
                            '-assignments' +
                            categories[index]['name'] +
                            '-bottom',
                      );
                    }
                  }
                  prefs.remove(widget.path + '-assignments');
                  print(widget.path);
                  List<String>? temp =
                      prefs.getStringList(widget.className + "-categories");
                  print(temp);
                  temp?.remove(widget.name);
                  print(temp);
                  prefs.setStringList(widget.className + "-categories", temp!);
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
                  return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => NewAssignment(
                                    category: widget.name,
                                    assignments: categories.length == 3
                                        ? []
                                        : categories,
                                    className: widget.name,
                                    path: widget.path + '-assignments'),
                              )).then((value) => storageStuff());
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
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
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
                } else if (categories[index]['name'] == 'classOverall') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     CupertinoPageRoute(
                        //       builder: (context) =>
                        //           CategoryPage(name: categories[index]['name']),
                        //     ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: IntrinsicHeight(
                          // height: 65, //maybe change to 124
                          // width: MediaQuery.sizeOf(context).width,
                          // child: Container(
                          // color: Theme.of(context).focusColor,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${categories[index]['edited'] ? 'Edited' : 'Overall'} Grade: ' +
                                        (((categories[index]['grade'] * 100) ??
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
                        ),
                      ),
                    ),
                  );
                } else if (categories[index]['name'] == 'Overall') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     CupertinoPageRoute(
                        //       builder: (context) =>
                        //           CategoryPage(name: categories[index]['name']),
                        //     ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: IntrinsicHeight(
                          // height: 65, //maybe change to 124
                          // width: MediaQuery.sizeOf(context).width,
                          // child: Container(
                          // color: Theme.of(context).focusColor,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${categories[index]['edited'] ? 'Edited' : 'Category'} Grade: ' +
                                        ((categories[index]['grade'] * 100)
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
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //       builder: (context) =>
                          //           CategoryPage(name: categories[index]['name']),
                          //     ));

                          final TextEditingController top =
                              TextEditingController(
                                  text: categories[index]['top'].toString());
                          final TextEditingController bottom =
                              TextEditingController(
                                  text: categories[index]['bottom'].toString());
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.viewInsetsOf(context)
                                        .bottom),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: Container(
                                    height: 600,
                                    child: Scaffold(
                                      resizeToAvoidBottomInset: false,
                                      body: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Text(
                                                "Adjust Score",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 5),
                                                    child: SizedBox(
                                                        width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width /
                                                                    MediaQuery.sizeOf(
                                                                            context)
                                                                        .height >
                                                                3 / 4
                                                            ? MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.9 *
                                                                    9 /
                                                                    16 /
                                                                    2 -
                                                                20
                                                            : MediaQuery.sizeOf(
                                                                            context)
                                                                        .width /
                                                                    2 -
                                                                20,
                                                        child: TextField(
                                                          controller: top,
                                                          autofocus: false,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                        ))),
                                                Text(
                                                  "/",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5, right: 10),
                                                    child: SizedBox(
                                                        width: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width /
                                                                    MediaQuery.sizeOf(
                                                                            context)
                                                                        .height >
                                                                3 / 4
                                                            ? MediaQuery.sizeOf(
                                                                            context)
                                                                        .height *
                                                                    0.9 *
                                                                    9 /
                                                                    16 /
                                                                    2 -
                                                                20
                                                            : MediaQuery.sizeOf(
                                                                            context)
                                                                        .width /
                                                                    2 -
                                                                20,
                                                        child: TextField(
                                                          controller: bottom,
                                                          autofocus: false,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                        ))),
                                              ]),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  SharedPreferences
                                                          .getInstance()
                                                      .then(
                                                    (prefs) {
                                                      SharedPreferences
                                                              .getInstance()
                                                          .then((prefs) {
                                                        prefs.setDouble(
                                                            widget.path +
                                                                '-assignments' +
                                                                categories[
                                                                        index]
                                                                    ['name'] +
                                                                '-grade',
                                                            100 *
                                                                double.parse(
                                                                    top.text) /
                                                                double.parse(
                                                                    bottom
                                                                        .text));
                                                        prefs.setDouble(
                                                            widget.path +
                                                                '-assignments' +
                                                                categories[
                                                                        index]
                                                                    ['name'] +
                                                                '-top',
                                                            double.parse(
                                                                top.text));
                                                        prefs.setDouble(
                                                            widget.path +
                                                                '-assignments' +
                                                                categories[
                                                                        index]
                                                                    ['name'] +
                                                                '-bottom',
                                                            double.parse(
                                                                bottom.text));
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  );
                                                },
                                                child: Text("Adjust Score")),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  SharedPreferences
                                                          .getInstance()
                                                      .then((prefs) {
                                                    prefs.remove(
                                                      widget.path +
                                                          '-assignments' +
                                                          categories[index]
                                                              ['name'] +
                                                          '-grade',
                                                    );
                                                    prefs.remove(
                                                      widget.path +
                                                          '-assignments' +
                                                          categories[index]
                                                              ['name'] +
                                                          '-top',
                                                    );
                                                    prefs.remove(
                                                      widget.path +
                                                          '-assignments' +
                                                          categories[index]
                                                              ['name'] +
                                                          '-bottom',
                                                    );
                                                    List<String>? temp =
                                                        prefs.getStringList(
                                                            widget.path +
                                                                '-assignments');
                                                    print(temp);
                                                    temp?.remove(
                                                        categories[index]
                                                            ['name']);
                                                    print(temp);
                                                    prefs.setStringList(
                                                        widget.path +
                                                            '-assignments',
                                                        temp!);
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text("Delete Score")),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).then((u) => storageStuff());
                        },
                        child: IntrinsicHeight(
                          // height: 124, //maybe change to 124
                          // width: MediaQuery.sizeOf(context).width,
                          child: Container(
                            // color: Theme.of(context).focusColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 5),
                                  child: Text(
                                    categories[index]['name'],
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 0, left: 10),
                                  child: Text(
                                    'Grade: ' +
                                        ((categories[index]['bottom'] *
                                                        categories[index]
                                                            ['grade'])
                                                    .round() /
                                                100)
                                            .toStringAsFixed(2) +
                                        // '%, Weight: ' +
                                        // categories[index]['weight']
                                        //     .toString() +
                                        "/" +
                                        categories[index]['bottom'].toString() +
                                        ', ' +
                                        ((categories[index]['grade'] * 100)
                                                    .round() /
                                                100)
                                            .toStringAsFixed(1) +
                                        '%',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10, bottom: 5),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.sizeOf(context).width - 20,
                                      child: CupertinoSlider(
                                          value: categories[index]['grade'] * 2,
                                          divisions: 200,
                                          min: 0,
                                          max: 200,
                                          onChanged: ((value) {
                                            categories[index]['grade'] =
                                                value / 2;
                                            var overall = 0.0;
                                            for (var category in categories) {
                                              if (!(category['name'] ==
                                                      'addCat' ||
                                                  category['name'] ==
                                                      'Overall' ||
                                                  category['name'] ==
                                                      'classOverall' ||
                                                  category['name'] ==
                                                      'deleteAll')) {
                                                overall += category['grade'];
                                              }
                                            }
                                            print(overall);
                                            categories[1]['grade'] = overall;
                                            categories[2]['edited'] = true;
                                            calculateGrade(false);
                                          })),
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
                                  builder: (context) => NewAssignment(
                                      category: widget.name,
                                      assignments: categories.length == 3
                                          ? []
                                          : categories,
                                      className: widget.name,
                                      path: widget.path + '-assignments'),
                                )).then((value) => storageStuff());
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //       builder: (context) =>
                          //           CategoryPage(name: categories[index]['name']),
                          //     ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: IntrinsicHeight(
                            // height: 65, //maybe change to 124
                            // width: MediaQuery.sizeOf(context).width,
                            // child: Container(
                            // color: Theme.of(context).focusColor,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${categories[1]['edited'] ? 'Edited' : 'Overall'} Grade: ' +
                                          (((categories[1]['grade'] * 100) ?? 0)
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
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //       builder: (context) =>
                          //           CategoryPage(name: categories[index]['name']),
                          //     ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: IntrinsicHeight(
                            // height: 65, //maybe change to 124
                            // width: MediaQuery.sizeOf(context).width,
                            // child: Container(
                            // color: Theme.of(context).focusColor,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      '${categories[2]['edited'] ? 'Edited' : 'Category'} Grade: ' +
                                          ((categories[2]['grade'] * 100)
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
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
