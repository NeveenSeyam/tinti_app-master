import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      SharedPreferences? _prefs = await SharedPreferences.getInstance();
      var AuthProvider = ref.read(accountProvider);

      setState(() {
        isLoaded = true;
        if (_prefs.getString(Keys.hasSaveUserData) == null) {
          Constants.isQuest = true;
          Constants.logo = "assets/images/logol2.png";
          Constants.blackLogo = "assets/images/bllo.png";
          Navigator.popAndPushNamed(context, '/poard_screen');
        } else {
          Constants.isQuest = false;

          Constants.token = _prefs.getString(Keys.hasSaveUserData);
          Constants.lang = _prefs.getString('lang');

          AuthProvider.getUserProfileRequset();
          if (Constants.lang == 'ar') {
            Constants.logo = "assets/images/logol2.png";
            Constants.blackLogo = "assets/images/blacklogo.png";
          } else {
            Constants.logo = "assets/images/logol.png";
            Constants.blackLogo = "assets/images/bllo.png";
          }

          Navigator.popAndPushNamed(context, '/navegaitor_screen');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/ssplash.svg', width: 100.w, height: 90.h,
              // fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
