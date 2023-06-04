import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Modules/auth/login_screen.dart';
import 'package:tinti_app/Util/constants/constants.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_text.dart';
import 'package:tinti_app/Widgets/wish_list_card.dart';
import 'package:tinti_app/provider/favorites_provider.dart';

import '../../../Helpers/failure.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/latest_offers_card.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/text_widget.dart';
import '../main/services/details/servies_details.dart';
import '../main/services/service_page.dart';
import '../more home screens/contact_us.dart';

class WishListPage extends ConsumerStatefulWidget {
  const WishListPage({super.key});

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends ConsumerState<WishListPage> {
  var isFav = 1;
  Future _getFavsData() async {
    final prov = ref.read(favsProvider);

    return await prov.getFavsDataRequset();
  }

  late Future _fetchedFvsRequest;

  @override
  void initState() {
    _fetchedFvsRequest = _getFavsData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        "favorite".tr(),
        isNotification: false,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _fetchedFvsRequest = _getFavsData();
          });
          return _fetchedFvsRequest;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Constants.isQuest == false
                    ? Consumer(
                        builder: (context, ref, child) => FutureBuilder(
                          future: _fetchedFvsRequest,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: 70.h,
                                child: const Center(
                                  child: LoaderWidget(),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Container(
                                    padding: EdgeInsets.all(20.w),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0, 7),
                                            blurRadius: 10,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20.w),
                                        color:
                                            AppColors.white.withOpacity(0.9)),
                                    width: 320.w,
                                    height: 500.h,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            'assets/images/nullstate.png'),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                          width: 300.w,
                                          child: CustomText(
                                            'contact support'.tr(),
                                            color: AppColors.orange,
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: 'DINNEXTLTARABIC',

                                            textAlign: TextAlign.center,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 60.h,
                                        ),
                                        RaisedGradientButton(
                                          text: 'contactus'.tr(),
                                          color: AppColors.scadryColor,
                                          height: 48.h,
                                          width: 320.w,
                                          circular: 10.w,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ContactUsScreen()),
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data is Failure) {
                                return Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Container(
                                      padding: EdgeInsets.all(20.w),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.w),
                                          color: AppColors.lightPrimaryColor
                                              .withOpacity(0.2)),
                                      width: 320.w,
                                      height: 500.h,
                                      child: Column(
                                        children: [
                                          Image.asset(
                                              'assets/images/nullstate.png'),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Container(
                                            width: 300.w,
                                            child: CustomText(
                                              'dont add any'.tr(),
                                              color: AppColors.orange,
                                              // fontWeight: FontWeight.bold,
                                              fontFamily: 'DINNEXTLTARABIC',

                                              textAlign: TextAlign.center,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 60.h,
                                          ),
                                          RaisedGradientButton(
                                            text: 'show product'.tr(),
                                            color: AppColors.scadryColor,
                                            height: 48.h,
                                            width: 320.w,
                                            circular: 10.w,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ServicesScreen()),
                                              );
                                            },
                                          ),
                                        ],
                                      )),
                                ));
                              }
                              //
                              //  print("snapshot data is ${snapshot.data}");

                              var favsModel =
                                  ref.watch(favsProvider).getFavsDataList;

                              return favsModel?.favoriteProducts?.length != 0
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          favsModel?.favoriteProducts?.length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          GestureDetector(
                                            onTap: () {
                                              // _fetchedFvsRequest = _getFavsData();

                                              // _fetchedFvsRequest;
                                            },
                                            child: WishListCard(
                                              image: favsModel
                                                      ?.favoriteProducts?[index]
                                                      .image ??
                                                  'assets/images/sa1.jpeg',
                                              title: favsModel
                                                      ?.favoriteProducts?[index]
                                                      .name ??
                                                  'تنظيف بالبخار ',
                                              compeny: favsModel
                                                      ?.favoriteProducts?[index]
                                                      .company ??
                                                  'شركة ليومار',
                                              details: favsModel
                                                      ?.favoriteProducts?[index]
                                                      .description ??
                                                  'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على السيارات وهذا هو السبب الذي يجعل بعض السيارات تستمر   ',
                                              price: favsModel
                                                      ?.favoriteProducts?[index]
                                                      .price
                                                      .toString() ??
                                                  '\$ 460 ',
                                              id: favsModel
                                                      ?.favoriteProducts?[index]
                                                      .productId ??
                                                  0,
                                              isFavorite: isFav,
                                            ),
                                          ))
                                  : // :
                                  Padding(
                                      padding: EdgeInsets.all(20.w),
                                      child: Container(
                                          padding: EdgeInsets.all(20.w),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.w),
                                              color: AppColors.lightPrimaryColor
                                                  .withOpacity(0.2)),
                                          width: 320.w,
                                          height: 500.h,
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                  'assets/images/nullstate.png'),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              Container(
                                                width: 300.w,
                                                child: CustomText(
                                                  'dont add any'.tr(),
                                                  color: AppColors.black,
                                                  fontWeight: FontWeight.bold,
                                                  textAlign: TextAlign.center,
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 60.h,
                                              ),
                                              RaisedGradientButton(
                                                text: 'show product'.tr(),
                                                color: AppColors.scadryColor,
                                                height: 48.h,
                                                width: 320.w,
                                                circular: 10.w,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ServicesScreen()),
                                                  );
                                                },
                                              ),
                                            ],
                                          )),
                                    );
                            }
                            return Container();
                          },
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(20.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 7),
                                blurRadius: 10,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.w),
                            color: AppColors.white.withOpacity(0.9)),
                        width: 320.w,
                        height: 500.h,
                        child: Column(
                          children: [
                            Image.asset('assets/images/nullstate.png'),
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              width: 300.w,
                              child: CustomText(
                                'need login'.tr(),
                                color: AppColors.orange,
                                // fontWeight: FontWeight.bold,
                                fontFamily: 'DINNEXTLTARABIC',

                                textAlign: TextAlign.center,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(
                              height: 60.h,
                            ),
                            RaisedGradientButton(
                              text: 'login'.tr(),
                              color: AppColors.scadryColor,
                              height: 48.h,
                              width: 320.w,
                              circular: 10.w,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                            ),
                          ],
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WishListCard extends ConsumerStatefulWidget {
  String image;
  String title;
  String compeny;
  String details;
  String price;
  int id;
  int isFavorite;

  WishListCard(
      {super.key,
      required this.image,
      required this.title,
      required this.compeny,
      required this.details,
      required this.price,
      required this.id,
      required this.isFavorite});

  @override
  _WishListCardState createState() => _WishListCardState();
}

class _WishListCardState extends ConsumerState<WishListCard> {
  int isFav = 1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServiceDetailsScreen(
                      id: widget.id,
                      row_id: widget.id,
                      isFavorite: widget.isFavorite,
                    )),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: AppColors.white),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 145.h,
                    width: 130.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w), //<-- SEE HERE
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.fill,
                        width: 148.w,
                        height: 150.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 200.w,
                        child: CustomText(
                          widget.title,
                          fontSize: 13.sp,
                        ),
                      ),
                      Container(
                        width: 200.w,
                        child: CustomText(
                          widget.compeny,
                          fontSize: 12.sp,
                          color: AppColors.orange,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: CustomText(widget.details,
                            fontSize: 12.sp,
                            color: AppColors.grey,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              widget.price,
                              fontSize: 13.sp,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.isFavorite == 1
                                          ? widget.isFavorite = 0
                                          : widget.isFavorite = 1;

                                      widget.isFavorite == 1
                                          ? isFav = 0
                                          : isFav = 1;
                                      var favModel = ref.watch(favsProvider);

                                      if (widget.isFavorite != 0) {
                                        favModel.addFavRequset(id: widget.id);
                                      } else {
                                        favModel.removeFavRequset(
                                            id: widget.id);
                                        //  _fetchedFvsRequest = _getFavsData();

                                        //   _fetchedFvsRequest;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 25.w,
                                    height: 24.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(3.w),
                                      // border: Border.all(color: Colors.grey),
                                    ),
                                    child: Icon(
                                      widget.isFavorite == 0
                                          ? Icons.favorite_border
                                          : Icons.favorite,
                                      color: widget.isFavorite == 0
                                          ? AppColors.grey
                                          : AppColors.orange,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5.w)),
                                  padding: EdgeInsets.all(4.w),
                                  child: Image.asset(
                                    'assets/images/aaddd.png',
                                    fit: BoxFit.fill,
                                    width: 20.w,
                                    color: AppColors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              // SizedBox(
              //   height: 10.h,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
