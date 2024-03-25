// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class EmailPage extends StatefulWidget {
//   const EmailPage({super.key});

//   @override
//   State<EmailPage> createState() => _EmailPageState();
// }

// class _EmailPageState extends State<EmailPage> {
//   final TextEditingController _email = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(children: [
//         Padding(
//             padding: EdgeInsets.only(top: 30),
//             child: Text(
//               "What is your email?",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.primary,
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//               ),
//             )),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           child: TextField(
//             controller: _email,
//             autofocus: true,
//             onChanged: (value) {
//               if (_email.text.contains("@")) {
//                 setState(() {});
//               }
//             },
//           ),
//         ),
//         !_email.text.contains("@waukeeschools.org")
//             ? Padding(
//                 padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
//                 child: Text(
//                   "Must use your school email - contact me if u dont go to wcsd",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ))
//             : Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(top: 70),
//                       child: SizedBox(
//                         width: MediaQuery.sizeOf(context).width - 40,
//                         height: 80,
//                         child: CupertinoButton(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           child: Padding(
//                             padding: EdgeInsets.only(

//                                 // bottom: MediaQuery.viewPaddingOf(context).bottom
//                                 ),
//                             child: Text(
//                               'Next',
//                               style: TextStyle(
//                                   color:
//                                       Theme.of(context).colorScheme.onSecondary,
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           color: Theme.of(context).colorScheme.primary,
//                           onPressed: () async {
//                             if (_email.text.contains("@waukeeschools.org")) {
//                               await FirebaseAuth.instance
//                                   .fetchSignInMethodsForEmail(_email.text)
//                                   .then((s) {
//                                 print(s);
//                                 Navigator.push(
//                                     context,
//                                     CupertinoPageRoute(
//                                       builder: (context) => PasswordPage(
//                                         email: _email.text,
//                                         newAcc: s.isEmpty ? true : false,
//                                       ),
//                                     ));
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ]),
//     );
//   }
// }

// class PasswordPage extends StatefulWidget {
//   const PasswordPage({super.key, required this.email, required this.newAcc});
//   final email;
//   final newAcc;

//   @override
//   State<PasswordPage> createState() => _PasswordPageState();
// }

// class _PasswordPageState extends State<PasswordPage> {
//   final TextEditingController _password = TextEditingController();
//   var error = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(children: [
//         Padding(
//             padding: EdgeInsets.only(top: 30),
//             child: Text(
//               widget.newAcc
//                   ? "What do you want your password to be?"
//                   : "What is your password?",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.primary,
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//               ),
//             )),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           child: TextField(
//             controller: _password,
//             obscureText: true,
//             autofocus: true,
//             onChanged: (value) {
//               if (_password.text.length <= 8) {
//                 if (error != '') {
//                   error = '';
//                 }
//                 setState(() {});
//               }
//             },
//           ),
//         ),
//         error != ''
//             ? Padding(
//                 padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
//                 child: Text(
//                   error,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ))
//             : Container(),
//         _password.text.length >= 8
//             ? Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(top: 70),
//                       child: SizedBox(
//                         width: MediaQuery.sizeOf(context).width - 40,
//                         height: 80,
//                         child: CupertinoButton(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           child: Padding(
//                             padding: EdgeInsets.only(

//                                 // bottom: MediaQuery.viewPaddingOf(context).bottom
//                                 ),
//                             child: Text(
//                               widget.newAcc ? 'Next' : 'Login',
//                               style: TextStyle(
//                                   color:
//                                       Theme.of(context).colorScheme.onSecondary,
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           color: Theme.of(context).colorScheme.primary,
//                           onPressed: () async {
//                             if (widget.newAcc) {
//                               await FirebaseAuth.instance
//                                   .createUserWithEmailAndPassword(
//                                       email: widget.email,
//                                       password: _password.text)
//                                   .then((e) {
//                                 if (FirebaseAuth.instance.currentUser != null) {
//                                   Navigator.push(
//                                       context,
//                                       CupertinoPageRoute(
//                                         builder: (context) => NamePage(),
//                                       ));
//                                 }
//                               });
//                             } else {
//                               await FirebaseAuth.instance
//                                   .signInWithEmailAndPassword(
//                                       email: widget.email,
//                                       password: _password.text)
//                                   .then((o) {
//                                 Navigator.push(
//                                     context,
//                                     CupertinoPageRoute(
//                                         builder: (context) => WillPopScope(
//                                               child: HomePage(),
//                                               onWillPop: () async => false,
//                                             )));
//                               }).onError((err, stackTrace) {
//                                 print(err
//                                     .toString()
//                                     .contains("The password is invalid"));
//                                 setState(() {
//                                   error = "fix ur password bud";
//                                 });
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : Container(),
//       ]),
//     );
//   }
// }
