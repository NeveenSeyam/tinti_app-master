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
import 'package:tinti_app/provider/products_provider.dart';
import '../../../Helpers/failure.dart';
import '../../../Widgets/custom_appbar.dart';
import '../../../Widgets/latest_offers_card.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/on_boarding_content_home.dart';
import '../../../Widgets/page_view_indicator_Home.dart';
import '../../../Widgets/servieses_card.dart';
import '../../../Widgets/text_widget.dart';
import '../../../provider/company_provider.dart';
import '../../../provider/services_provider.dart';

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

  Future _getServicesProductData() async {
    final prov = ref.read(productsProvider);

    return await prov.getProductDataByServisesRequset(id: serviceId);
  }

  late Future _fetchedServiceProductsRequest;

  late PageController _pageController;
  int _currentPage = 0;
  Future _getContentData() async {
    final prov = ref.read(companyProvider);

    return await prov.getCompanyDataRequset();
  }

  Future _getSalesProductContentData() async {
    final prov = ref.read(productsProvider);

    return await prov.getSalesProductDataRequset();
  }

  late Future _fetchedMyRequest;
  late Future _fetchedSalesProductsRequest;

  @override
  void initState() {
    _fetchedServiceRequest = _getServicesContentData();
    _fetchedServiceProductsRequest = _getServicesProductData();
    _fetchedMyRequest = _getContentData();
    _fetchedSalesProductsRequest = _getSalesProductContentData();
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          "الرئيسية",
          isNotification: false,
          isProfile: false,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              _fetchedMyRequest = _getContentData();
              _fetchedServiceProductsRequest = _getServicesProductData();
              _fetchedSalesProductsRequest = _getSalesProductContentData();
            });
            return _fetchedMyRequest;
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.w),
                    color: Color.fromRGBO(255, 255, 255, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          // width: 350.w,
                          height: 150.h,
                          child: Consumer(
                            builder: (context, ref, child) => FutureBuilder(
                              future: _fetchedMyRequest,
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
                                  return PageView(
                                    scrollDirection: Axis.horizontal,
                                    // controller: _pageController,
                                    physics: const BouncingScrollPhysics(),
                                    onPageChanged: (int currentPage) {
                                      setState(
                                          () => _currentPage = currentPage);
                                    },
                                    children: [
                                      OnBoardingContentHome(
                                        image:
                                            companyModel.companies?[0].image ??
                                                'assets/images/sa1.jpeg',
                                        text: companyModel.companies?[0].name ??
                                            'جونسون اند جونسون',
                                        about:
                                            companyModel.companies?[0].about ??
                                                '',
                                        id: companyModel.companies?[0].id ?? 0,
                                      ),
                                      OnBoardingContentHome(
                                        image:
                                            companyModel.companies?[1].image ??
                                                'assets/images/sa2.jpeg',
                                        text: companyModel.companies?[1].name ??
                                            'جونسون اند جونسون',
                                        about:
                                            companyModel.companies?[1].about ??
                                                '',
                                        id: companyModel.companies?[1].id ?? 0,
                                      ),
                                      OnBoardingContentHome(
                                        image:
                                            companyModel.companies?[2].image ??
                                                'assets/images/sa3.jpeg',
                                        text: companyModel.companies?[2].name ??
                                            'جونسون اند جونسون',
                                        about:
                                            companyModel.companies?[2].about ??
                                                '',
                                        id: companyModel.companies?[2].id ?? 0,
                                      ),
                                      OnBoardingContentHome(
                                        image:
                                            companyModel.companies?[3].image ??
                                                'assets/images/sa4.jpeg',
                                        text: companyModel.companies?[3].name ??
                                            'جونسون اند جونسون',
                                        about:
                                            companyModel.companies?[3].about ??
                                                '',
                                        id: companyModel.companies?[3].id ?? 0,
                                      ),
                                      //   OnBoardingContentHome(
                                      //     image:
                                      //         companyModel.companies?[4].image ??
                                      //             'assets/images/sa5.jpeg',
                                      //     text: companyModel.companies?[4].name ??
                                      //         'جونسون اند جونسون',
                                      //     about:
                                      //         companyModel.companies?[4].about ??
                                      //             '',
                                      //     id: companyModel.companies?[4].id ?? 0,
                                      //   ),
                                      //
                                    ],
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: _currentPage < 5,
                              maintainSize: true,
                              maintainState: true,
                              maintainAnimation: true,
                              child: Row(
                                children: [
                                  PageViewIndicatorCustomHome(
                                    isCurrentPage: _currentPage == 0,
                                    // marginEnd: 1.w,
                                  ),
                                  PageViewIndicatorCustomHome(
                                    isCurrentPage: _currentPage == 1,
                                    // marginEnd: 1.w,
                                  ),
                                  PageViewIndicatorCustomHome(
                                    // marginEnd: 1.w,
                                    isCurrentPage: _currentPage == 2,
                                  ),
                                  PageViewIndicatorCustomHome(
                                    // marginEnd: 1.w,
                                    isCurrentPage: _currentPage == 3,
                                  ),
                                  PageViewIndicatorCustomHome(
                                    // marginEnd: 1.w,
                                    isCurrentPage: _currentPage == 4,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 15.w, top: 12.h),
                  child: Text('العروض',
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
                      padding:
                          EdgeInsetsDirectional.only(start: 15.w, top: 5.h),
                      child: Text('كل عروض الخدمات التي تريدها هنا',
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
                        padding:
                            EdgeInsetsDirectional.only(end: 15.w, top: 5.h),
                        child: Text('المزيد',
                            style: TextStyle(
                              color: Colors.grey,
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

                          var productModel = ref
                              .watch(productsProvider)
                              .getProductsSellsDataList;
                          print('aaaa ${productModel?.success?.items?.length}');

                          return Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 15.w, top: 5.h),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: productModel?.success?.items?.length,
                              itemBuilder: (BuildContext context, int index) =>
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
                                              id: productModel?.success
                                                      ?.items?[index].id ??
                                                  0,
                                              row_id: productModel?.success
                                                      ?.items?[index].id ??
                                                  0,
                                            )),
                                  );
                                },
                                child: latestOffersCard(
                                    // productModel?.image ??
                                    productModel
                                            ?.success?.items?[index].image ??
                                        'assets/images/sa1.jpeg',
                                    productModel?.success?.items?[index].name ??
                                        'تنظيف بالبخار ',
                                    productModel
                                            ?.success?.items?[index].service ??
                                        'شركة ليومار',
                                    productModel?.success?.items?[index]
                                            .salePrice ??
                                        '355',
                                    'assets/images/cardtile.png',
                                    productModel
                                            ?.success?.items?[index].price ??
                                        '460\$'),
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
                  padding: EdgeInsetsDirectional.only(start: 15.w, top: 12.h),
                  child: Text('الخدمات',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontFamily: 'DINNextLTArabic',
                      )),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('كل الخدمات التي قد تبحث عنها',
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
                                  builder: (context) => ServicesScreen()),
                            );
                          },
                          child: Text('المزيد',
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                itemCount: serviecesModel?.services?.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    textButtonModel(
                                        serviecesModel?.services?[index].name,
                                        serviecesModel?.services?[index].id,
                                        serviecesModel?.services?[index].id)),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 300,
                                            childAspectRatio: 2 / 2.5,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemCount: productByServiceModel
                                        .success?.items?.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ServiceDetailsScreen(
                                                      id: productByServiceModel
                                                              .success
                                                              ?.items?[index]
                                                              .id ??
                                                          0,
                                                      row_id: 0 ?? 0,
                                                    )),
                                          );
                                        },
                                        child: ServicesCard(
                                            // productByServiceModel.Products.length ??
                                            productByServiceModel.success
                                                    ?.items?[index].image ??
                                                'assets/images/sa1.jpeg',
                                            productByServiceModel.success
                                                    ?.items?[index].name ??
                                                ' تظليل',
                                            productByServiceModel
                                                    .success
                                                    ?.items?[index]
                                                    .description ??
                                                'شركة جونسون اد جونسون.',
                                            productByServiceModel.success
                                                    ?.items?[index].price ??
                                                '355',
                                            '',
                                            ''),
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
          _fetchedServiceProductsRequest = _getServicesProductData();
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
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
                style: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
            ),
    );
  }
}
