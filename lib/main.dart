import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:tinti_app/Modules/Home/a.dart';
import 'package:tinti_app/Modules/auth/login_screen.dart';
import 'package:tinti_app/Modules/auth/signup_screen.dart';
import 'Modules/Home/companys/company_page.dart';
import 'Modules/OnBoarding/on_boarding_screen.dart';
import 'Modules/auth/first_forget_screen.dart';
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
enum AppState {
  foreground,
  background,
  terminated,
}

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

// flutter local notification
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _showForegroundNotificationInAndroid(RemoteMessage message) async {
    flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? "",
        message.notification?.body ?? "",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  void _handleNotification({
    Map<String, dynamic>? message,
    AppState? appState,
  }) async {
    print("message?['screen']${message}");
    print("message?['screen']${message?['screen']}");

    print(
        'PushNotificationsManager: _handleNotification ${message.toString()} ${appState.toString()}');
  }

  confg() async {
    /// handler when notification arrives. This handler is executed only when notification arrives in foreground state.
    /// For iOS, OS handles the displaying of notification
    /// For Android, we push local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("FirebaseMessaging.onMessage");
      log("FirebaseMessaging.onMessage ${message.data}");
      _showForegroundNotificationInAndroid(message);
    });

    var iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print("onDidReceiveLocalNotification");
        print("id $id");
        print("title $title");
        print("body $body");
        print("payload $payload");
      },
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@drawable/icon_menu_car_no');
    var initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosInitializationSettings,
    );
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) async {
      print("onDidReceiveNotificationResponse");
      print("details actionId ${details.actionId}");
      print("details payload ${details.payload}");
      print("details input ${details.input}");

      // show dilog
    });

    /// handler when user taps on the notification.
    /// For iOS, it gets executed when the app is in [foreground] / [background] state.
    /// For Android, it gets executed when the app is in [background] state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      _handleNotification(message: message.data, appState: AppState.foreground);
    });

    /// If the app is launched from terminated state by tapping on a notification, [getInitialMessage] function will return the
    /// [RemoteMessage] only once.
    var initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    /// if [RemoteMessage] is not null, this means that the app is launched from terminated state by tapping on the notification.
    if (initialMessage != null) {
      _handleNotification(
          message: initialMessage.data, appState: AppState.terminated);
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );
    confg();

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
