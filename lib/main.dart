import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tv_comparer/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loggedIn = false;
  var wideScreen = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width / MediaQuery.sizeOf(context).height >
        3 / 4) {
      if (!wideScreen) {
        setState(
          () {
            wideScreen = true;
          },
        );
      }
    } else {
      if (wideScreen) {
        setState(
          () {
            wideScreen = false;
          },
        );
      }
    }

    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return Container(
        color: Colors.black,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(wideScreen ? 20 : 0),
            child: SizedBox(
              height: wideScreen
                  ? MediaQuery.sizeOf(context).height * 0.95
                  : MediaQuery.sizeOf(context).height,
              width: wideScreen
                  ? MediaQuery.sizeOf(context).height * 0.95 * 9 / 16
                  : MediaQuery.sizeOf(context).width,
              child: MaterialApp(
                theme: ThemeData(
                  colorScheme: lightColorScheme ??
                      ColorScheme.fromSwatch(
                          primarySwatch: Colors.green,
                          brightness: Brightness.light,
                          backgroundColor: Color.fromARGB(255, 249, 255, 235)),
                  elevatedButtonTheme: lightColorScheme == null
                      ? ElevatedButtonThemeData(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 239, 247, 223))))
                      : null,
                  useMaterial3: true,
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
                  }),
                ),
                darkTheme: ThemeData(
                  colorScheme: darkColorScheme ??
                      ColorScheme.fromSwatch(
                          primarySwatch: Colors.green,
                          brightness: Brightness.dark,
                          backgroundColor: Color.fromARGB(255, 20, 28, 20)),
                  elevatedButtonTheme: darkColorScheme == null
                      ? ElevatedButtonThemeData(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 28, 39, 20))))
                      : null,
                  useMaterial3: true,
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
                  }),
                ),
                routes: {
                  '/start': (context) => FirstPage(),
                  "/home": (context) => Home(),
                },
                initialRoute:
                    // FirebaseAuth.instance.currentUser == null ? '/start' : '/home',
                    '/start',
              ),
            ),
          ),
        ),
      );
    });
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).brightness == Brightness.light
      //     ? Colors.white
      //     : Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  bottom: 160 + MediaQuery.viewPaddingOf(context).bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Grade Manipulator',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Discover your highest grade',
                    style: TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 80 + MediaQuery.viewPaddingOf(context).bottom,
                    child: CupertinoButton(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.viewPaddingOf(context).bottom),
                          child: Text(
                            "Let's Go",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (context) => Home()));
                      },
                    )),
                // SizedBox(
                //   width: MediaQuery.sizeOf(context).width,
                //   height: 80 + MediaQuery.viewPaddingOf(context).bottom,
                //   child: CupertinoButton(
                //     borderRadius: BorderRadius.zero,
                //     child: Padding(
                //       padding: EdgeInsets.only(
                //           bottom: MediaQuery.viewPaddingOf(context).bottom),
                //       child: Text(
                //         'How does it work?',
                //         style: TextStyle(
                //             color: Theme.of(context).colorScheme.onSecondary,
                //             fontSize: 30,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     color: Theme.of(context).colorScheme.primary,
                //     onPressed: () {
                //       // Navigator.push(
                //       //     context,
                //       //     CupertinoPageRoute(
                //       //       builder: (context) => GetStarted(),
                //       //     ));
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
