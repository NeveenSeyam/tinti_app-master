import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Models/product/service_products_model.dart';
import 'package:tinti_app/Modules/Home/a.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/button_widget.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';
import 'package:tinti_app/Widgets/wish_list_card.dart';
import 'package:tinti_app/provider/products_provider.dart';

import '../../../../Helpers/failure.dart';
import '../../../../Models/product/sales_products_model.dart';
import '../../../../Widgets/custom_appbar.dart';
import '../../../../Widgets/loader_widget.dart';
import '../../../../Widgets/servieses_card.dart';
import '../../../../Widgets/text_widget.dart';
import '../../../../Widgets/type.dart';
import '../../../../provider/services_provider.dart';
import 'details/servies_details.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  ServicesScreen({
    super.key,
  });

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  TextEditingController _search = TextEditingController();
  int serviceId = 1;
  bool isSearch = false;
  int pageIndex = 1;
  var hight = 620.h;
  String? dataSearch;
  Future _getContentData() async {
    final prov = ref.read(servicesProvider);

    return await prov.getServiecesDataRequset();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    ref.read(productsProvider).cleanProductsBySirvesList();
    _fetchedMyRequest = _getContentData();
    _fetchedProductRequest = _getProductsData(1);
    isSearch = false;
    _fetchedServiceProductsRequest = _getServicesProductData(0, serviceId);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() async {
        print("object");

        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          var portalRequset =
              ref.watch(productsProvider).getProductsSellsDataList ??
                  ProductModel();
          if ((portalRequset.success?.pageNumber ?? 0) <
              (portalRequset.success?.totalPages ?? 0)) {
            print("has more pages");
            setState(() {
              showLoding = true;
              hight = 590.h;
            });
            final prov = ref.read(productsProvider);

            await prov
                .getProductDataByServisesRequset(
                    id: serviceId,
                    page: (portalRequset.success?.pageNumber ?? 0) + 1,
                    isNewProduct: false)
                .then((value) {
              setState(() {
                showLoding = false;
                hight = 620.h;
              });
              setState(() {});
            });
          }
        }
      });
    });
    super.initState();
  }
// try now

  bool showLoding = false;
  Future _getServicesProductData(page, id) async {
    final prov = ref.read(productsProvider);

    return await prov.getProductDataByServisesRequset(id: id, page: page);
  }

  late Future _fetchedServiceProductsRequest;

  int updateServiceId(int service) {
    setState(() {
      serviceId = service;
    });
    return serviceId;
  }

  late Future _fetchedMyRequest;

  Future _getProductsData(page) async {
    final prov = ref.read(productsProvider);

    return await prov.getAllProductDataRequset(page: page);
  }

  Future _getSearchProductsData(dataSearch2) async {
    final prov = ref.read(productsProvider);

    return await prov.getSearchRequsett(name: dataSearch2 ?? '');
  }

  late Future _fetchedProductRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        isProfile: false,
        "services".tr(),
        isNotification: false,
        isHome: true,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _fetchedProductRequest = _getProductsData(0);
            _search.text = '';
          });
          return _fetchedProductRequest;
        },
        child: Consumer(
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
                  child: Text('لا يوجد نتائج مطابقة'),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data is Failure) {
                  return Center(child: TextWidget('لا يوجد نتائج مطابقة'));
                }
                //
                //  print("snapshot data is ${snapshot.data}");

                var serviecesModel = ref.watch(servicesProvider).getDataList;

                return ListView(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                      child: Consumer(
                        builder: (context, ref, child) => FutureBuilder(
                          future: _fetchedMyRequest,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('لا يوجد نتائج مطابقة'),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data is Failure) {
                                return Center(
                                    child: TextWidget('لا يوجد نتائج مطابقة'));
                              }
                              //
                              //  print("snapshot data is ${snapshot.data}");

                              var serviecesModel =
                                  ref.watch(servicesProvider).getDataList;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 290.w,
                                    child: RoundedInputField(
                                      hintText: 'search'.tr(),
                                      hintColor: AppColors.scadryColor,
                                      seen: false,
                                      controller: _search,
                                      onChanged: (val) {
                                        setState(() {
                                          isSearch = true;
                                          _fetchedProductRequest =
                                              _getSearchProductsData(val);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.search,
                                        color: AppColors.scadryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60.w,
                                    child: ButtonWidget(
                                      onPressed: () {
                                        if (_search.text.isNotEmpty) {
                                          setState(() {
                                            _fetchedProductRequest =
                                                _getSearchProductsData(
                                                    _search.text);
                                            isSearch = true;
                                            // _search.text = '';
                                          });
                                        } else {
                                          isSearch = false;
                                          _fetchedProductRequest =
                                              _getProductsData(0);
                                        }
                                      },
                                      widget: Icon(
                                        Icons.search,
                                      ),
                                      backgroundColor: AppColors.orange,
                                    ),
                                  )
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isSearch ? true : false,
                      child: Consumer(
                        builder: (context, ref, child) => FutureBuilder(
                          future: _fetchedProductRequest,
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
                                child: Text('لا يوجد نتائج مطابقة'),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data is Failure) {
                                return Center(
                                    child: TextWidget('لا يوجد نتائج مطابقة'));
                              }
                              //
                              //  print("snapshot data is ${snapshot.data}");

                              var productModel = ref
                                  .watch(productsProvider)
                                  .getProductsDataList;
                              var searchProductModel =
                                  ref.watch(productsProvider).getSearchDataList;
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.only(
                                        start: 15.w,
                                        end: 15.w,
                                        top: 5.h,
                                        bottom: 20.h),
                                    child: SizedBox(
                                      height: 620.h,
                                      child: GridView.builder(
                                          // physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 300,
                                                  childAspectRatio: 2 / 2.3,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10),
                                          itemCount: searchProductModel
                                                  ?.success?.length ??
                                              0,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ServiceDetailsScreen(
                                                            id: searchProductModel
                                                                    ?.success?[
                                                                        index]
                                                                    .id ??
                                                                0,
                                                            row_id: searchProductModel
                                                                    ?.success?[
                                                                        index]
                                                                    .id ??
                                                                0,
                                                            isFavorite: 0,
                                                          )),
                                                );
                                                // print(
                                                //     ' sssssssss ${productByServiceModel.success?.items?.length}');
                                              },
                                              child: ServicesCard(
                                                  // productByServiceModel.Products.length ??
                                                  searchProductModel
                                                          ?.success?[index]
                                                          .image ??
                                                      'assets/images/sa1.jpeg',
                                                  searchProductModel
                                                          ?.success?[index]
                                                          .name ??
                                                      ' تظليل',
                                                  searchProductModel
                                                          ?.success?[index]
                                                          .description ??
                                                      'شركة جونسون اد جونسون.',
                                                  searchProductModel
                                                          ?.success?[index]
                                                          .price ??
                                                      '355',
                                                  '',
                                                  '',
                                                  0,
                                                  searchProductModel
                                                          ?.success?[index]
                                                          .id ??
                                                      0),
                                            );
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  )
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isSearch ? false : true,
                      child: Consumer(
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

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      width: 370.w,
                                      height: 48.h,
                                      child: Center(
                                        child: ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              serviecesModel?.services?.length,
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              TextButton(
                                            onPressed: () {
                                              setState(() {
                                                pageIndex = index;
                                                serviceId = serviecesModel
                                                        ?.services?[index].id ??
                                                    0;
                                                _fetchedProductRequest =
                                                    _getProductsData(0);
                                                _fetchedServiceProductsRequest =
                                                    _getServicesProductData(
                                                        0,
                                                        serviecesModel
                                                            ?.services?[index]
                                                            .id);
                                              });
                                            },
                                            child: pageIndex == index
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.all(3.w),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffF57A38),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.w),
                                                      // border: Border.all(color: Colors.grey),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        serviecesModel
                                                                ?.services?[
                                                                    index]
                                                                .name ??
                                                            '',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12.sp,
                                                            fontFamily:
                                                                'DINNEXTLTARABIC',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    // width: 60.w,
                                                    // height: 30.h,
                                                    padding:
                                                        EdgeInsets.all(3.w),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.orange[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.w),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xffF57A38),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      serviecesModel
                                                              ?.services?[index]
                                                              .name ??
                                                          '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              'DINNEXTLTARABIC',
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Consumer(
                                    builder: (context, ref, child) =>
                                        FutureBuilder(
                                      future: _fetchedProductRequest,
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

                                          var productByServiceModel = ref
                                                  .watch(productsProvider)
                                                  .getProductsSirvesDataList ??
                                              ServiceProductModel();
                                          return Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                start: 15.w,
                                                end: 15.w,
                                                top: 5.h,
                                                bottom: 20.h),
                                            child: SizedBox(
                                              height: 620.h,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: hight,
                                                    child: GridView.builder(
                                                        // physics: BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        controller:
                                                            _scrollController,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    300,
                                                                childAspectRatio:
                                                                    2 / 2.3,
                                                                crossAxisSpacing:
                                                                    10,
                                                                mainAxisSpacing:
                                                                    10),
                                                        itemCount:
                                                            productByServiceModel
                                                                    .success
                                                                    ?.items
                                                                    ?.length ??
                                                                0,
                                                        itemBuilder:
                                                            (BuildContext ctx,
                                                                index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ServiceDetailsScreen(
                                                                              id: productByServiceModel.success?.items?[index].id ?? 0,
                                                                              row_id: productByServiceModel.success?.items?[index].id ?? 0,
                                                                              isFavorite: productByServiceModel.success?.items?[index].is_favorite ?? 0,
                                                                            )),
                                                              );
                                                              print(
                                                                  ' sssssssss ${productByServiceModel.success?.items?.length}');
                                                            },
                                                            child: ServicesCard(
                                                                // productByServiceModel.Products.length ??
                                                                productByServiceModel
                                                                        .success
                                                                        ?.items?[
                                                                            index]
                                                                        .image ??
                                                                    'assets/images/sa1.jpeg',
                                                                productByServiceModel
                                                                        .success
                                                                        ?.items?[
                                                                            index]
                                                                        .name ??
                                                                    ' تظليل',
                                                                productByServiceModel
                                                                        .success
                                                                        ?.items?[
                                                                            index]
                                                                        .description ??
                                                                    'شركة جونسون اد جونسون.',
                                                                productByServiceModel
                                                                        .success
                                                                        ?.items?[
                                                                            index]
                                                                        .price ??
                                                                    '355',
                                                                '',
                                                                '',
                                                                productByServiceModel
                                                                        .success
                                                                        ?.items?[
                                                                            index]
                                                                        .is_favorite ??
                                                                    0,
                                                                productByServiceModel
                                                                        .success
                                                                        ?.items?[
                                                                            index]
                                                                        .id ??
                                                                    0),
                                                          );
                                                        }),
                                                  ),
                                                  if (showLoding)
                                                    CircularProgressIndicator(),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                );
              }
              return Container();
            },
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
          _fetchedProductRequest = _getProductsData(0);
        });
      },
      child: pageIndex == index
          ? Container(
              padding: EdgeInsets.all(3.w),
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
              // height: 30.h,
              padding: EdgeInsets.all(3.w),
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
