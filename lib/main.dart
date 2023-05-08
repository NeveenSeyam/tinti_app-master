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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

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
