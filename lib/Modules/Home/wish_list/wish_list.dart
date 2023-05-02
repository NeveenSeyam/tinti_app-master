import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class WishListPage extends ConsumerStatefulWidget {
  const WishListPage({super.key});

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends ConsumerState<WishListPage> {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          "المفضلة",
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
                  child: Consumer(
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
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data is Failure) {
                            return Center(
                                child: TextWidget(snapshot.data.toString()));
                          }
                          //
                          //  print("snapshot data is ${snapshot.data}");

                          var favsModel =
                              ref.watch(favsProvider).getFavsDataList;

                          return favsModel?.favoriteProducts?.length != 0
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      favsModel?.favoriteProducts?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          WishListCard(
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
                                              'لم تقم باضافة اي خدمة للمفضله  يمكنك اضافة واحده الان',
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
                                            text: 'تصفح المنتجات',
                                            color: AppColors.scadryColor,
                                            height: 48.h,
                                            width: 320.w,
                                            circular: 10.w,
                                            onPressed: () {},
                                          ),
                                        ],
                                      )),
                                );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
