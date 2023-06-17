import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tinti_app/Modules/Home/a.dart';
import 'package:tinti_app/Modules/auth/forgetPassword/final_screen.dart';
import 'package:tinti_app/Modules/auth/login_screen.dart';
import 'package:tinti_app/Modules/auth/signup_screen.dart';
import 'Modules/Home/companys/company_page.dart';
import 'Modules/OnBoarding/on_boarding_screen.dart';
import 'Modules/auth/forgetPassword/first_forget_screen.dart';
import 'Modules/auth/splash.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(
      child: EasyLocalization(
    supportedLocales: [
      Locale('ar', 'DZ'),
      Locale('en', 'US'),
    ],
    path: 'assets/langs',
    child: MyApp(),
  )));
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(ProviderScope(child: const MyApp()));
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: ScreenUtilInit(
          designSize: Size(393, 852),
          builder: ((context, child) => MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                home: SplashScreen(),
                routes: {
                  '/login_screen': (context) => const LoginScreen(),
                  '/poard_screen': (context) => const OnBoardingScreens(),
                  '/signup_screen': (context) => const SignUpScreen(),
                  '/first_screen': (context) => const FirstForgetScreen(),
                  // '/secound_screen': (context) => const SecoundForgetScreen(),
                  // '/theard_screen': (context) => const TheardForgetScreen(),
                  '/navegaitor_screen': (context) => MyHomePage(),
                  '/final_screen': (context) => const FinalForgetScreen(),
                  '/campany_screen': (context) => CampanyPage(),
                  // '/company_profile': (context) => CompanyProfile(
                  //       id: 0,
                  //     ),
                  '/sp_profile': (context) => SplashScreen(),
                },
              ))),
    );
  }
}
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import 'Modules/dfgh.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Consumer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // home: MyHomePage(),
//       home: InfiniteScrollPackage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int currentPage = 1;
//   Future<Map> getPosts() async {
//     try {
//       var response = await http.get(
//         Uri.parse(
//           "http://10.0.2.2:8000/apis?page=${currentPage}",
//         ),
//       );
//       if (response.statusCode == 200) {
//         // return a decoded body
//         // print(response.body);
//         return jsonDecode(response.body);
//       } else {
//         // server error
//         return Future.error("Server Error !");
//       }
//     } catch (SocketException) {
//       // fetching error
//       // may be timeout, no internet or dns not resolved
//       return Future.error("Error Fetching Data !");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Pagination",
//           ),
//         ),
//         //
//         body: SingleChildScrollView(
//           child: FutureBuilder<Map>(
//             future: getPosts(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 print(snapshot.data);
//                 return Column(
//                   children: [
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: snapshot.data!['ideas'].length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: EdgeInsets.all(
//                             15.0,
//                           ),
//                           padding: EdgeInsets.all(
//                             15.0,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(
//                               5.0,
//                             ),
//                             border: Border.all(
//                               color: Colors.black,
//                               width: 2.0,
//                             ),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 "${snapshot.data!['ideas'][index]['title']}",
//                                 style: TextStyle(
//                                   fontSize: 24.0,
//                                 ),
//                               ),
//                               //
//                               Text(
//                                 "${snapshot.data!['ideas'][index]['description']}",
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                 ),
//                               ),
//                               //
//                               Text(
//                                 DateTime.parse(snapshot.data!['ideas'][index]
//                                         ['created'])
//                                     .toString(),
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     //
//                     //
//                     //
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         if (snapshot.data!['currenPage'] <
//                             snapshot.data!['totalPages'])
//                           OutlinedButton(
//                             onPressed: () {
//                               setState(() {
//                                 currentPage++;
//                               });
//                             },
//                             child: Text(
//                               "Next",
//                             ),
//                           ),
//                         if (snapshot.data!['currenPage'] > 1)
//                           OutlinedButton(
//                             onPressed: () {
//                               setState(() {
//                                 currentPage--;
//                               });
//                             },
//                             child: Text(
//                               "Previous",
//                             ),
//                           ),
//                       ],
//                     )
//                   ],
//                 );
//               } else if (snapshot.hasError) {
//                 return Text(snapshot.error.toString());
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           ),
//         ));
//   }
// }
