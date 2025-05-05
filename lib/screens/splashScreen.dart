// import 'package:flutter/material.dart';

// class SplashWedgit extends StatefulWidget {
//   @override
//   _SplashWedgitState createState() => _SplashWedgitState();
// }

// class _SplashWedgitState extends State<SplashWedgit> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 1), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Mai()), // Navigate to login
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF086C74),
//       body: Container(
//         margin: EdgeInsets.only(left: 10, top: 150),
//         width: double.infinity,
//         child: Column(
//           children: [
//             Image.asset("assets/images/splash.png", height: 281, width: 271),
//             const Text(
//               "Trash Squad",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 48,
//                 fontFamily: "Jomolhari",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
