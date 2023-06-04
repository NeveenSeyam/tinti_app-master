import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:tinti_app/Modules/Home/companys/company-profile.dart';
import 'package:tinti_app/Modules/Home/more%20home%20screens/contact_us.dart';
import 'package:tinti_app/Modules/Home/more%20home%20screens/how_we_are.dart';
import 'package:tinti_app/Modules/Home/wish_list/wish_list.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
import 'cart/cart_page.dart';
import 'companys/company_page.dart';
import 'main/main_page.dart';
import 'more home screens/my cars/my_cars.dart';
import 'profile/profile_page.dart';

final pages = [MainPage(), WishListPage(), CartPage(), ProfilePage()];

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with TickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  @override
  GlobalKey<CircularMenuState> key = GlobalKey<CircularMenuState>();

  int pageIndex = 0;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );
    // overlays: [SystemUiOverlay.]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // appBar: CustomAppBar(''),
      body: pages[pageIndex],

      bottomNavigationBar: SpinCircleBottomBarHolder(
        bottomNavigationBar: SCBottomBarDetails(
            circleColors: [Colors.white, AppColors.orange, Colors.redAccent],
            iconTheme: IconThemeData(color: Colors.white, size: 30),
            activeIconTheme: IconThemeData(color: AppColors.orange, size: 35),
            backgroundColor: AppColors.scadryColor,
            titleStyle: TextStyle(color: Colors.white, fontSize: 12),
            activeTitleStyle: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            actionButtonDetails: SCActionButtonDetails(
                color: AppColors.orange,
                icon: Icon(
                  Icons.expand_less,
                  color: Colors.white,
                ),
                elevation: 2),
            elevation: 2.0,
            items: [
              SCBottomBarItem(
                  icon: Icons.home_rounded,
                  onPressed: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.favorite_border,
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.shopping_bag_outlined,
                  onPressed: () {
                    setState(() {
                      pageIndex = 2;
                    });
                  }),
              SCBottomBarItem(
                  icon: Icons.person,
                  onPressed: () {
                    setState(() {
                      pageIndex = 3;
                    });
                  }),

              // Suggested count : 4
            ],
            circleItems: [
              //Suggested Count: 3
              SCItem(
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.orange,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HowWeAreScreen()));
                  }),
              SCItem(
                  icon: const Icon(
                    Icons.business_outlined,
                    color: AppColors.orange,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CampanyPage()));
                  }),
              SCItem(
                  icon: const Icon(
                    Icons.car_repair,
                    color: AppColors.orange,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyCarsScreen()));
                  }),
              SCItem(
                  icon: const Icon(
                    Icons.call,
                    color: AppColors.orange,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ContactUsScreen()));
                  }),
            ],
            bnbHeight: 80 // Suggested Height 80
            ),
        child: Container(),
      ),
    );
  }
}
