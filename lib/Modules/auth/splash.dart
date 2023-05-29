import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbib_splash_screen/splash_screen.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';
import 'package:tinti_app/Modules/OnBoarding/on_boarding_screen.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';

import '../../Util/constants/constants.dart';
import '../../Util/constants/keys.dart';
import '../../provider/account_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );
    Future.delayed(const Duration(seconds: 3))
        .then((value) => setState(() async {
              SharedPreferences? _prefs = await SharedPreferences.getInstance();

              isLoaded = true;
              if (_prefs.getString(Keys.hasSaveUserData) == null) {
                Constants.isQuest = true;
                Navigator.popAndPushNamed(context, '/poard_screen');
              } else {
                var AuthProvider = ref.read(accountProvider);
                Constants.isQuest = false;

                Constants.token = _prefs.getString(Keys.hasSaveUserData);
                await AuthProvider.getUserProfileRequset();
                Navigator.popAndPushNamed(context, '/navegaitor_screen');
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 160.w,
              height: 120.h,
              child: Image.asset(
                'assets/images/llogoo.png',
                fit: BoxFit.fill,
                width: 200.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
