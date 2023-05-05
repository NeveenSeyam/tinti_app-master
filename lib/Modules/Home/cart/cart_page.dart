import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/provider/order_provider.dart';

import '../../../Helpers/failure.dart';
import '../../../Util/theme/app_colors.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/order_list_card.dart';
import '../../../Widgets/text_widget.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  Future _getordersData() async {
    final prov = ref.read(ordersProvider);

    return await prov.getOrderDataRequset();
  }

  late Future _fetchedOrderRequest;

  @override
  void initState() {
    _fetchedOrderRequest = _getordersData();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          "طلباتي",
          isProfile: false,
          isNotification: false,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _fetchedOrderRequest = _getordersData();
            });
            return _fetchedOrderRequest;
          },
          child: Container(
            width: double.infinity,
            child: Consumer(
              builder: (context, ref, child) => FutureBuilder(
                future: _fetchedOrderRequest,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  '  حسابك غير فعال يمكنك التواصل مع الدعم لتفعيل حسابك',
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
                                text: 'تواصل معنا',
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
                  if (snapshot.hasData) {
                    if (snapshot.data is Failure) {
                      return Center(
                          child: TextWidget(snapshot.data.toString()));
                    }
                    //
                    //  print("snapshot data is ${snapshot.data}");

                    var ordersModel =
                        ref.watch(ordersProvider).getOrdersDataList;

                    return ordersModel?.orders?.length != 0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: ordersModel?.orders?.length,
                            itemBuilder: (BuildContext context, int index) =>
                                OrderListCard(
                              image: ordersModel?.orders?[index].image ??
                                  'assets/images/sa1.jpeg',
                              stats: ordersModel?.orders?[index].status ?? '',
                              title: ordersModel?.orders?[index].name ??
                                  'تنظيف بالبخار ',
                              compeny: ordersModel?.orders?[index].company ??
                                  'شركة ليومار',
                              details: ordersModel
                                      ?.orders?[index].description ??
                                  'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على السيارات وهذا هو السبب الذي يجعل بعض السيارات تستمر   ',
                              price: ordersModel?.orders?[index].price
                                      .toString() ??
                                  '460',
                              isFavorite: 0,
                              id: ordersModel?.orders?[index].productId ?? 0,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Container(
                                padding: EdgeInsets.all(20.w),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.w),
                                    color: AppColors.lightPrimaryColor
                                        .withOpacity(0.2)),
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
                                        'لم تقم بطلب اي خدمة حتى الان يمكنك اضافة واحده الان',
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
        ),
      ),
    );
  }
}
