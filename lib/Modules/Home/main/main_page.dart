import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Models/companies/comany_model.dart';
import 'package:tinti_app/Models/product/sales_products_model.dart';
import 'package:tinti_app/Models/product/service_products_model.dart';
import 'package:tinti_app/Modules/Home/main/services/details/servies_details.dart';
import 'package:tinti_app/Modules/Home/main/services/saels_page.dart';
import 'package:tinti_app/Modules/Home/main/services/service_page.dart';
import 'package:tinti_app/Util/constants/constants.dart';
import 'package:tinti_app/provider/products_provider.dart';
import '../../../Helpers/failure.dart';
import '../../../Util/theme/app_colors.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/latest_offers_card.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/on_boarding_content_home.dart';
import '../../../Widgets/page_view_indicator_Home.dart';
import '../../../Widgets/servieses_card.dart';
import '../../../Widgets/text_widget.dart';
import '../../../provider/company_provider.dart';
import '../../../provider/services_provider.dart';
import '../more home screens/contact_us.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int pageIndex = 0;
  int serviceId = 1;
  int updateServiceId(int service) {
    setState(() {
      serviceId = service;
    });
    return serviceId;
  }

  Future _getServicesContentData() async {
    final servicesprov = ref.read(servicesProvider);

    return await servicesprov.getServiecesDataRequset();
  }

  late Future _fetchedServiceRequest;

  Future _getServicesProductData(page) async {
    final prov = ref.read(productsProvider);

    return await prov.getProductDataByServisesRequset(
        id: serviceId, page: page);
  }

  late Future _fetchedServiceProductsRequest;

  late PageController _pageController;
  int _currentPage = 0;
  Future _getContentData() async {
    final prov = ref.read(companyProvider);

    return await prov.getCompanyDataRequset();
  }

  Future _getSalesProductContentData(page) async {
    final prov = ref.read(productsProvider);

    return await prov.getSalesProductDataRequset(page: page);
  }

  late Future _fetchedMyRequest;
  late Future _fetchedSalesProductsRequest;

  @override
  void initState() {
    _fetchedServiceRequest = _getServicesContentData();
    _fetchedServiceProductsRequest = _getServicesProductData(0);
    _fetchedMyRequest = _getContentData();
    _fetchedSalesProductsRequest = _getSalesProductContentData(0);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        "home".tr(),
        isNotification: false,
        isProfile: false,
      ),
      body: Container(
        width: double.infinity,
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _fetchedMyRequest = _getContentData();
              _fetchedServiceProductsRequest = _getServicesProductData(0);
              _fetchedSalesProductsRequest = _getSalesProductContentData(0);
            });
            return _fetchedMyRequest;
          },
          child: Consumer(
            builder: (context, ref, child) => FutureBuilder(
              future: _fetchedMyRequest,
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return SizedBox(
                //     height: 70.h,
                //     child: const Center(
                //       child: LoaderWidget(),
                //     ),
                //   );
                // }
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
                        // width: 320.w,
                        height: 500.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/nullstate.png'),
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              width: 300.w,
                              child: CustomText(
                                '${snapshot.error}' == 'No Internet connection'
                                    ? Constants.lang == 'ar'
                                        ? 'انت غير متصل بالانترنت حاول مرة اخرى'
                                        : 'You don\'t connect with internet try again'
                                    : 'contact support'.tr(),
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
                              text: Constants.lang == 'ar'
                                  ? ' حاول مرة اخرى'
                                  : ' try again',
                              color: AppColors.scadryColor,
                              height: 48.h,
                              width: 320.w,
                              circular: 10.w,
                              onPressed: () {
                                setState(() {
                                  _fetchedMyRequest = _getContentData();
                                  _fetchedServiceProductsRequest =
                                      _getServicesProductData(0);
                                  _fetchedSalesProductsRequest =
                                      _getSalesProductContentData(0);
                                  _fetchedServiceRequest =
                                      _getServicesContentData();
                                });
                              },
                            ),
                          ],
                        )),
                  );

                  // Center(
                  //   // child: Text('Error: ${snapshot.error}'),

                  // );
                }
                if (snapshot.hasData) {
                  if (snapshot.data is Failure) {
                    return Center(child: TextWidget(snapshot.data.toString()));
                  }
                  //
                  //  print("snapshot data is ${snapshot.data}");

                  var companyModel =
                      ref.watch(companyProvider).getCompanyDataList ??
                          CompanyModel();

                  print('linght ${companyModel.companies?.length}');
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 5.w),
                            color: Color.fromRGBO(255, 255, 255, 1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  // width: 350.w,
                                  height: 170.h,
                                  child: Consumer(
                                    builder: (context, ref, child) =>
                                        FutureBuilder(
                                      future: _fetchedMyRequest,
                                      builder: (context, snapshot) {
                                        // if (snapshot.connectionState ==
                                        //     ConnectionState.waiting) {
                                        //   return SizedBox(
                                        //     height: 70.h,
                                        //     child: const Center(
                                        //       child: LoaderWidget(),
                                        //     ),
                                        //   );
                                        // }
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'),
                                          );
                                        }
                                        if (snapshot.hasData) {
                                          if (snapshot.data is Failure) {
                                            return Center(
                                                child: TextWidget(
                                                    snapshot.data.toString()));
                                          }
                                          //
                                          //  print("snapshot data is ${snapshot.data}");

                                          var companyModel = ref
                                                  .watch(companyProvider)
                                                  .getCompanyDataList ??
                                              CompanyModel();

                                          print(
                                              'linght ${companyModel.companies?.length}');
                                          return CarouselSlider.builder(
                                            itemCount: companyModel
                                                    .companies?.length ??
                                                0,
                                            itemBuilder: (BuildContext context,
                                                    int itemIndex,
                                                    int pageViewIndex) =>
                                                OnBoardingContentHome(
                                              image: companyModel
                                                      .companies?[itemIndex]
                                                      .image ??
                                                  'assets/images/sa1.jpeg',
                                              text: companyModel
                                                      .companies?[itemIndex]
                                                      .name ??
                                                  'جونسون اند جونسون',
                                              about: companyModel
                                                      .companies?[itemIndex]
                                                      .about ??
                                                  '',
                                              id: companyModel
                                                      .companies?[itemIndex]
                                                      .id ??
                                                  0,
                                            ),
                                            options: CarouselOptions(
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                              viewportFraction: 01,
                                              aspectRatio: 2.0,
                                              initialPage: 1,
                                            ),
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
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 15.w, top: 12.h),
                          child: Text('sales'.tr(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontFamily: 'DINNextLTArabic',
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                  start: 15.w, top: 5.h),
                              child: Text("sales-description".tr(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                    fontFamily: 'DINNextLTArabic',
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SaelsScreen()),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    end: 15.w, top: 5.h),
                                child: Text('more'.tr(),
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 11.sp,
                                      fontFamily: 'DINNextLTArabic',
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 235.h,
                          child: Consumer(
                            builder: (context, ref, child) => FutureBuilder(
                              future: _fetchedSalesProductsRequest,
                              builder: (context, snapshot) {
                                // if (snapshot.connectionState ==
                                //     ConnectionState.waiting) {
                                //   return SizedBox(
                                //     height: 70.h,
                                //     child: const Center(
                                //       child: LoaderWidget(),
                                //     ),
                                //   );
                                // }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                }
                                if (snapshot.hasData) {
                                  if (snapshot.data is Failure) {
                                    return Center(
                                        child: TextWidget(
                                            snapshot.data.toString()));
                                  }

                                  var productModel = ref
                                      .watch(productsProvider)
                                      .getProductsSellsDataList;
                                  print(
                                      'aaaa ${productModel?.success?.items?.length}');

                                  return Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 15.w, top: 5.h),
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          productModel?.success?.items?.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              GestureDetector(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) => SaelsScreen()),
                                          // );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ServiceDetailsScreen(
                                                      id: productModel
                                                              ?.success
                                                              ?.items?[index]
                                                              .id ??
                                                          0,
                                                      row_id: productModel
                                                              ?.success
                                                              ?.items?[index]
                                                              .id ??
                                                          0,
                                                      isFavorite: productModel
                                                              ?.success
                                                              ?.items?[index]
                                                              .is_favorite ??
                                                          0,
                                                    )),
                                          );
                                        },
                                        child: latestOffersCard(
                                            // productModel?.image ??
                                            productModel?.success?.items?[index]
                                                    .image ??
                                                'assets/images/sa1.jpeg',
                                            productModel?.success?.items?[index]
                                                    .name ??
                                                'تنظيف بالبخار ',
                                            productModel?.success?.items?[index]
                                                    .service ??
                                                'شركة ليومار',
                                            productModel?.success?.items?[index]
                                                    .salePrice ??
                                                '355',
                                            'assets/images/cardtile.png',
                                            productModel?.success?.items?[index]
                                                    .price ??
                                                '460 ر.س',
                                            productModel?.success?.items?[index]
                                                    .is_favorite ??
                                                0,
                                            productModel
                                                    ?.success?.items?[index].id
                                                    .toString() ??
                                                '0'),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: 15.w, top: 12.h),
                          child: Text('services'.tr(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontFamily: 'DINNextLTArabic',
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.w, horizontal: 15.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('services-description'.tr(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                    fontFamily: 'DINNextLTArabic',
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ServicesScreen()),
                                  );
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ServicesScreen()),
                                    );
                                  },
                                  child: Text('more'.tr(),
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 11.sp,
                                        fontFamily: 'DINNextLTArabic',
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const Center(child: typeWidget()),
                        Consumer(
                          builder: (context, ref, child) => FutureBuilder(
                            future: _fetchedMyRequest,
                            builder: (context, snapshot) {
                              // if (snapshot.connectionState ==
                              //     ConnectionState.waiting) {
                              //   return SizedBox(
                              //     height: 70.h,
                              //     child: const Center(
                              //       child: LoaderWidget(),
                              //     ),
                              //   );
                              // }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }
                              if (snapshot.hasData) {
                                if (snapshot.data is Failure) {
                                  return Center(
                                      child:
                                          TextWidget(snapshot.data.toString()));
                                }
                                //
                                //  print("snapshot data is ${snapshot.data}");

                                var serviecesModel =
                                    ref.watch(servicesProvider).getDataList;

                                return Center(
                                  child: SizedBox(
                                    width: 370.w,
                                    height: 45.h,
                                    child: ListView.builder(
                                        physics: null,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            serviecesModel?.services?.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                textButtonModel(
                                                    serviecesModel
                                                        ?.services?[index].name,
                                                    serviecesModel
                                                        ?.services?[index].id,
                                                    serviecesModel
                                                        ?.services?[index].id)),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),

                        Consumer(
                          builder: (context, ref, child) => FutureBuilder(
                            future: _fetchedServiceProductsRequest,
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
                                      child:
                                          TextWidget(snapshot.data.toString()));
                                }
                                //
                                //  print("snapshot data is ${snapshot.data}");

                                var productByServiceModel = ref
                                        .watch(productsProvider)
                                        .getProductsSirvesDataList ??
                                    ServiceProductModel();
                                print(
                                    ' sssssssss ${productByServiceModel.success?.items?.length}');
                                print('serviceId $serviceId');
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: 15.w, end: 15.w, top: 5.h),
                                      child: SizedBox(
                                        height: 680.h,
                                        child: GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 300,
                                                    childAspectRatio: 2 / 2.5,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10),
                                            itemCount: productByServiceModel
                                                .success?.items?.length,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ServiceDetailsScreen(
                                                              id: productByServiceModel
                                                                      .success
                                                                      ?.items?[
                                                                          index]
                                                                      .id ??
                                                                  0,
                                                              row_id: 0,
                                                              isFavorite: productByServiceModel
                                                                      .success
                                                                      ?.items?[
                                                                          index]
                                                                      .is_favorite ??
                                                                  1,
                                                            )),
                                                  );
                                                },
                                                child: ServicesCard(
                                                    // productByServiceModel.Products.length ??
                                                    productByServiceModel
                                                            .success
                                                            ?.items?[index]
                                                            .image ??
                                                        'assets/images/sa1.jpeg',
                                                    productByServiceModel
                                                            .success
                                                            ?.items?[index]
                                                            .name ??
                                                        ' تظليل',
                                                    productByServiceModel
                                                            .success
                                                            ?.items?[index]
                                                            .description ??
                                                        'شركة جونسون اد جونسون.',
                                                    productByServiceModel
                                                            .success
                                                            ?.items?[index]
                                                            .price ??
                                                        '355',
                                                    '',
                                                    '',
                                                    productByServiceModel
                                                            .success
                                                            ?.items?[index]
                                                            .is_favorite ??
                                                        355,
                                                    productByServiceModel
                                                            .success
                                                            ?.items?[index]
                                                            .id ??
                                                        355),
                                              );
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                    )
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  TextButton textButtonModel(name, index, id) {
    return TextButton(
      onPressed: () {
        setState(() {
          pageIndex = index;
          serviceId = id;
          _fetchedServiceProductsRequest = _getServicesProductData(0);
        });
      },
      child: pageIndex == index
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 3.w),
              decoration: BoxDecoration(
                color: Color(0xffF57A38),
                borderRadius: BorderRadius.circular(10.w),
                // border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'DINNEXTLTARABIC',
                      fontWeight: FontWeight.normal),
                ),
              ),
            )
          : Container(
              // width: 60.w,
              // height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 3.w),
              decoration: BoxDecoration(
                // color: Colors.orange[300],
                borderRadius: BorderRadius.circular(10.w),
                border: Border.all(
                  color: const Color(0xffF57A38),
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontFamily: 'DINNEXTLTARABIC',
                    fontWeight: FontWeight.normal),
              ),
            ),
    );
  }
}
